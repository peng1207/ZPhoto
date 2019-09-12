//
//  SPCameraManager.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/26.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import CoreFoundation
import SPCommonLibrary

class SPCameraManager : NSObject {
    //捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    /// 获取摄像头设备
    fileprivate let devices = { () -> [AVCaptureDevice] in
        if SP_VERSION_10_UP{
            let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            return (deviceDiscovery.devices)
        }else{
            return AVCaptureDevice.devices(for: AVMediaType.video)
        }
    }()
    /// 展示layer
    var videoLayer : AVCaptureVideoPreviewLayer? {
        didSet{
            videoLayer?.videoGravity = AVLayerVideoGravity.resize
        }
    }
    /// 当前摄像头设备
    fileprivate var currentDevice : AVCaptureDevice?
    /// 图像流输出
    fileprivate var output:  AVCaptureVideoDataOutput!
    /// 视频线程
    fileprivate let videoDataOutputQueue :DispatchQueue = DispatchQueue(label: "com.hsp.videoDataOutputQueue")
    /// 没有滤镜的图片
    @objc dynamic  var noFilterCIImage : CIImage?
    /// 处理滤镜之后展示的图片
    var showOutputCGImage : CGImage?
    /// 滤镜
    var filter : CIFilter?
    /// 人脸遮盖的图片
    var faceCoverImg : UIImage?
    /// 有没摄像头权限
    var cameraAuth : Bool = false
    /// image 的布局
    var videoLayoutType : SPVideoLayoutType = .none
    // 放大最大的倍数
    fileprivate let maxZoomActore :CGFloat = 5.00
    /// 缩放最小的倍数
    fileprivate let minZoomActore : CGFloat = 1.00
    fileprivate lazy var ciContext: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [CIContextOption.workingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    /// 初始化相机
    func sp_initCamera(){
       sp_checkAuth()
    }
    /// 检查相机权限
    fileprivate func sp_checkAuth(){
        SPAuthorizatio.sp_isCamera { [weak self](success) in
             self?.cameraAuth = success
            if success {
                //  有权限
                self?.sp_setupCamera()
            }else{
                // 没有权限
            }
        }
    }
    /// 设置摄像头
    fileprivate func sp_setupCamera(){
        sp_initCaptureInput(postion: .back)
        self.captureSession.startRunning()
    }
    /// 初始化输入的设备
    ///
    /// - Parameter postion: 摄像头位置
    fileprivate func sp_initCaptureInput(postion : AVCaptureDevice.Position){
        sp_getVideoDevice(postion: postion)
        let videoInput = try? AVCaptureDeviceInput(device: self.currentDevice!)
        
        self.captureSession.beginConfiguration()
        for input in self.captureSession.inputs {
            self.captureSession.removeInput(input)
        }
        if self.captureSession.canAddInput(videoInput!) {
            self.captureSession.addInput(videoInput!)
        }
        let needAdd : Bool = self.captureSession.outputs.count > 0 ? false : true
        
        if needAdd {
            self.output = AVCaptureVideoDataOutput()
            self.output.alwaysDiscardsLateVideoFrames = true
            self.output.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
            /// 开启防抖
            let videoConnect = self.output.connection(with: .video)
            if let device = self.currentDevice, device.activeFormat.isVideoStabilizationModeSupported(AVCaptureVideoStabilizationMode.cinematic){
                videoConnect?.preferredVideoStabilizationMode = .cinematic
            }
            if self.captureSession.canAddOutput(self.output){
                self.captureSession.addOutput(self.output)
            }
        }
        self.captureSession.sessionPreset = .hd1280x720
        self.captureSession.commitConfiguration()
        
    }
    /// 获取当前的摄像头
    ///
    /// - Parameter postion: 前置还是后置
    fileprivate func sp_getVideoDevice(postion : AVCaptureDevice.Position) {
        var videoDevive : AVCaptureDevice?
        
        if SP_VERSION_10_UP {
               videoDevive = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: postion)
        }else{
            for device in devices {
                if device.position == postion {
                    videoDevive = device
                }
            }
        }
        if let currentDevice = videoDevive {
            self.currentDevice = currentDevice
        }
    }
    // MARK: -- 私有方法
    
    ///  改变属性操作
    ///
    /// - Parameter propertyBlock: 回调
    fileprivate func sp_changeDeviceProperty(propertyBlock:PropertyChangeBlock?){
        do {
            // 锁定设备
            try self.currentDevice?.lockForConfiguration()
            if propertyBlock != nil {
                propertyBlock!()
            }
            //  释放设备
            self.currentDevice?.unlockForConfiguration()
        }catch _{
            
        }
    }
    
}
//MARK: - delegate
extension SPCameraManager:AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        autoreleasepool {
            if !CMSampleBufferDataIsReady(sampleBuffer) {
                return
            }
            var outputImage : CIImage? = nil
            if output == self.output{
                let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
                outputImage = CIImage(cvPixelBuffer: imageBuffer)
                var noFilterOutputImage  : CIImage? = outputImage
                noFilterOutputImage =  UIImage.sp_picRotating(imgae: noFilterOutputImage)
                self.noFilterCIImage =  CIImage(cgImage:  self.ciContext.createCGImage(noFilterOutputImage!, from: (noFilterOutputImage?.extent)!)!)
                // 滤镜
                if self.filter != nil , let ciImg = outputImage{
                    self.filter?.setValue(ciImg, forKey: kCIInputImageKey)
                    outputImage = self.filter?.outputImage
                }
                // 执行判断人脸 然后增加头像上去
                outputImage = UIImage.sp_detectFace(inputImg: outputImage!, coverImg:self.faceCoverImg)
                // 视频帧布局
                outputImage = UIImage.sp_video(layoutType: self.videoLayoutType, outputImg: outputImage)
                // 旋转图片
                outputImage =  UIImage.sp_picRotating(imgae: outputImage)
            }
            if let oImg = outputImage {
                let cgImage = self.ciContext.createCGImage(oImg, from: oImg.extent)
                sp_mainQueue {
                    self.videoLayer?.contents = cgImage
                    self.showOutputCGImage = cgImage
                }
            }
        }
    }
  
}

extension SPCameraManager {
    
    /// 切换摄像头
    func sp_changeCamera(){
        /// 获取当前摄像头的位置
        let postion = sp_getPosition()
        self.sp_initCaptureInput(postion: postion == .back ? .front : .back)
        sp_changeCameraAnimation()
    }
    /// 获取当前摄像头的位置
    ///
    /// - Returns: 前置 还是后置
    fileprivate func sp_getPosition()->AVCaptureDevice.Position{
        if let dev = currentDevice {
            return dev.position
        }
        return .back
    }
    /// 切换摄像头的动画
    fileprivate func sp_changeCameraAnimation(){
        let animation = CATransition()
        animation.duration = 0.4
        animation.type = CATransitionType(rawValue: "oglFlip")
        animation.subtype = CATransitionSubtype.fromRight
        videoLayer?.add(animation, forKey: "cameraAnimation")
    }
    func sp_stop(){
        self.captureSession.stopRunning()
    }
    
    // MARK: -- 闪光灯设置
    /// 点击闪光灯
    func sp_flashlight(){
        guard cameraAuth else {
            return
        }
        if SP_IS_IPAD {
            return
        }
        SPCameraHelp.sp_flash(device: self.currentDevice)
    }
    
    /// 取消
    func sp_cane(){
        SPCameraHelp.sp_flashOff(device: self.currentDevice)
        sp_stop()
    }
    /// 放大
    func sp_zoomIn(scale : CGFloat = 1.0){
        SPCameraHelp.sp_zoomIn(device: self.currentDevice, scale: scale)
    }
    /// 缩小
    func sp_zoomOut(scale : CGFloat = 1.0) {
        SPCameraHelp.sp_zoomOut(device: self.currentDevice, scale: scale)
    }
}
