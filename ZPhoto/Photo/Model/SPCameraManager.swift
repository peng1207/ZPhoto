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

class SPCameraManager : NSObject {
    //捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    //    fileprivate let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
    fileprivate let devices = { () -> [AVCaptureDevice] in
        if SP_VERSION_10_UP{
            let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            return (deviceDiscovery.devices)
        }else{
            return AVCaptureDevice.devices(for: AVMediaType.video)
        }
    }()
    var videoLayer : AVCaptureVideoPreviewLayer? {
        didSet{
            videoLayer?.videoGravity = AVLayerVideoGravity.resize
        }
    }
    fileprivate var currentDevice : AVCaptureDevice?
    fileprivate var output:  AVCaptureVideoDataOutput! /// 图像流输出
    let videoDataOutputQueue :DispatchQueue = DispatchQueue(label: "com.hsp.videoDataOutputQueue")
    @objc dynamic  var noFilterCIImage : CIImage?
    var filterCGImage : CGImage?
    var filter : CIFilter?
    var cameraAuth : Bool = false  // 有没摄像头权限
    lazy var ciContext: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    /// 初始化相机
    func sp_initCamera(){
       sp_checkAuth()
    }
    fileprivate func sp_checkAuth(){
        SPAuthorizatio.isRightCamera { [weak self](success) in
             self?.cameraAuth = success
            if success {
                //  有权限
                self?.sp_setupCamera()
            }else{
                // 没有权限
            }
        }
    }
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
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            outputImage = CIImage(cvPixelBuffer: imageBuffer)
            var noFilterOutputImage  : CIImage? = outputImage
            noFilterOutputImage =  UIImage.sp_picRotating(imgae: noFilterOutputImage)
            self.noFilterCIImage =  CIImage(cgImage:  self.ciContext.createCGImage(noFilterOutputImage!, from: (noFilterOutputImage?.extent)!)!)
//            outputImage =  UIImage.sp_detectFace(inputImg: outputImage!, coverImg: UIImage(named: "filter"))
            if self.filter != nil {
                self.filter?.setValue(outputImage!, forKey: kCIInputImageKey)
                outputImage = self.filter?.outputImage
            }
            if let oImg = outputImage {
                outputImage =  UIImage.sp_picRotating(imgae: oImg)
                let cgImage = self.ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
                sp_dispatchMainQueue {
                    self.videoLayer?.contents = cgImage
                    self.filterCGImage = cgImage
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
        animation.type = "oglFlip"
        animation.subtype = kCATransitionFromRight
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
        
        if self.currentDevice?.position == AVCaptureDevice.Position.front {
            return
        }
        
        if self.currentDevice?.torchMode == AVCaptureDevice.TorchMode.off {
            sp_flashOn()
        }else{
            sp_flashOff()
        }
    }
    /*
     打开闪光灯
     */
   fileprivate func sp_flashOn(){
        if SP_IS_IPAD {
            return
        }
        if !(self.currentDevice?.hasFlash)! {
            return
        }
        if  !(self.currentDevice?.hasTorch)! {
            return
        }
        self.sp_changeDeviceProperty {  [weak self]() in
            if self?.currentDevice?.torchMode == AVCaptureDevice.TorchMode.off {
                self?.currentDevice?.torchMode = AVCaptureDevice.TorchMode.on
            }
            if self?.currentDevice?.flashMode == AVCaptureDevice.FlashMode.off {
                self?.currentDevice?.flashMode = AVCaptureDevice.FlashMode.on
            }
        }
      
    }
    /*
     关闭闪光灯
     */
   fileprivate func sp_flashOff(){
        if SP_IS_IPAD {
            return
        }
        if self.currentDevice == nil {
            return
        }
        if !(self.currentDevice?.hasFlash)! {
            return
        }
        if  !(self.currentDevice?.hasTorch)! {
            return
        }
        self.sp_changeDeviceProperty { [weak self]() in
            if self?.currentDevice?.torchMode == AVCaptureDevice.TorchMode.on {
                self?.currentDevice?.torchMode = AVCaptureDevice.TorchMode.off
            }
            if self?.currentDevice?.flashMode == AVCaptureDevice.FlashMode.on {
                self?.currentDevice?.flashMode = AVCaptureDevice.FlashMode.off
            }
        }
    }
    /// 取消
    func sp_cane(){
        sp_flashOff()
        sp_stop()
    }
}
