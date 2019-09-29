//
//  SPRecordVideoManager.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/4/9.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreFoundation
import SPCommonLibrary
typealias PropertyChangeBlock = ()->Void
// 没有相机权限的回调
typealias NOAuthBlock = () ->Void


class SPRecordVideoManager: NSObject,CAAnimationDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    /// 摄像头数组
    fileprivate let devices = { () -> [AVCaptureDevice] in
        if SP_VERSION_10_UP == false{
            return AVCaptureDevice.devices(for: AVMediaType.video)
        }else{
            let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            return (deviceDiscovery.devices)
        }
    }()
    /// 当前摄像头
    fileprivate var currentDevice : AVCaptureDevice?
    //音频输入设备
    fileprivate let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    /// 视频源的出口
    fileprivate var videoOutput : AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    ///  音频源的出口
    fileprivate var audioOutput : AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
 
    var videoLayer : AVCaptureVideoPreviewLayer? {
        didSet{
            videoLayer?.videoGravity = AVLayerVideoGravity.resize
        }
    }
    /// 没有相机权限的回调
   fileprivate var noCameraAuthBlock : NOAuthBlock?
    /// 没有麦克风的权限
    fileprivate var noMicrophoneBlock : NOAuthBlock?
    // 放大最大的倍数
    fileprivate let maxZoomActore :CGFloat = 5.00
    /// 缩放最小的倍数
    fileprivate let minZoomActore : CGFloat = 1.00

    // 开始录制
    fileprivate var startRecording : Bool = false
    /// 是否首帧是视频帧
    fileprivate var isFirstVideo : Bool = false
    fileprivate var assetWriter: AVAssetWriter?
    /// 视频写入
    fileprivate var videoWriterInput: AVAssetWriterInput?
    /// 音频写入
    fileprivate var audioWriterInput: AVAssetWriterInput?
    /// 视频写入
    fileprivate var videoWriterPixelbufferInput : AVAssetWriterInputPixelBufferAdaptor?
    /// 最后时间
    fileprivate var lastSampleTime : CMTime?
    /// 音频文件
    fileprivate let  filePath : String = "\(kVideoTempDirectory)/temp.mp4"
    /// 滤镜
    var filter : CIFilter?
    /// 没有加滤镜的图片
    @objc dynamic var noFilterCIImage : CIImage?
    ///  有没摄像头权限
    var cameraAuth : Bool = false
    /// image 的布局
    var videoLayoutType : SPVideoLayoutType = .none
    /// 人脸的遮盖image
    var faceCoverImg : UIImage?
    /// 视频输出线程
    fileprivate let videoDataOutputQueue :DispatchQueue = DispatchQueue(label: "com.hsp.videoDataOutputQueue")
    /// 音频输入线程
    fileprivate let audioDataOutputQueue : DispatchQueue = DispatchQueue(label: "com.hsp.audioDataOutputQueue")
    // 写入音频参数
    fileprivate let audioSetting: [String: AnyObject] = [
        AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: 1 as AnyObject,
        AVSampleRateKey: 22050 as AnyObject
    ]
   fileprivate lazy var ciContext: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [CIContextOption.workingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    /// 视频的大小
    fileprivate var videoSize : CGSize = sp_screenPixels()
    override init() {
        super.init()
    }
    // 设置视频的初始化
    func sp_initRecord(){
        SPAuthorizatio.sp_isCamera{ (authorized) in
            self.cameraAuth = authorized
            if authorized{
                // 有权限
                self.sp_isRecordAuth()
            }else{
                // 没有权限
                self.sp_noAuthorizedComplete(noAuthBlock: self.noCameraAuthBlock)
            }
        }
    }
    /// 添加回调
    func sp_complete(noCameraAuthBlock:NOAuthBlock?,noMicrophoneBlock:NOAuthBlock?){
        self.noCameraAuthBlock = noCameraAuthBlock
        self.noMicrophoneBlock = noMicrophoneBlock
    }
    
    /*
     判断麦克风权限
     */
    fileprivate func sp_isRecordAuth(){
        SPAuthorizatio.sp_isRecord { (authorized) in
             self.sp_init()
            if authorized == false {
                self.sp_noAuthorizedComplete(noAuthBlock: self.noMicrophoneBlock)
            }
        }
    }
    /*
     初始化组件
     */
    fileprivate func sp_init(){
        self.sp_captureInpunt(postion: .back)
        self.captureSession.startRunning()
    }
    /*
     没有权限时的回调
     */
    fileprivate func sp_noAuthorizedComplete(noAuthBlock :NOAuthBlock?){
        guard let complete = noAuthBlock else {
            return
        }
        complete()
    }
    fileprivate func sp_getCVPixelFormatType()->OSType{
        return kCVPixelFormatType_32BGRA
    }
    /// 获取视频输出的尺寸
    ///
    /// - Returns: 尺寸
    fileprivate func sp_pixeSize()->CGSize{
        return sp_screenPixels()
    }
    
    /// 设置输入输出设备类型
    ///
    /// - Parameter postion: 前摄像头还是后摄像头
    fileprivate func sp_captureInpunt(postion : AVCaptureDevice.Position){
        self.sp_videoDevice(postion: postion)
        guard self.currentDevice != nil else {
            return
        }
        let videoInput = try? AVCaptureDeviceInput(device: self.currentDevice!)
        let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!)
        self.captureSession.beginConfiguration()
        for input in self.captureSession.inputs {
            self.captureSession.removeInput(input)
        }
        if self.captureSession.canAddInput(videoInput!) {
            self.captureSession.addInput(videoInput!)
        }
        if self.captureSession.canAddInput(audioInput!) {
            self.captureSession.addInput(audioInput!)
        }
     
        self.sp_changeDeviceProperty {
            
            self.currentDevice?.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: framesPerSecond)
            self.currentDevice?.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: framesPerSecond)
        }
        let needAdd : Bool = self.captureSession.outputs.count > 0 ? false : true
        
        if needAdd == true {
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(sp_getCVPixelFormatType())] as [String : Any]
            
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            audioOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
            /// 开启防抖
            let videoConnect = videoOutput.connection(with: .video)
            if let device = self.currentDevice, device.activeFormat.isVideoStabilizationModeSupported(AVCaptureVideoStabilizationMode.cinematic){
                videoConnect?.preferredVideoStabilizationMode = .cinematic
            }
            
            if self.captureSession.canAddOutput(videoOutput){
                self.captureSession.addOutput(videoOutput)
            }
 
            if self.captureSession.canAddOutput(audioOutput) {
                self.captureSession.addOutput(audioOutput)
            }
        }
        self.captureSession.commitConfiguration()
    }
    /// 获取摄像头
    fileprivate func sp_videoDevice(postion : AVCaptureDevice.Position) {
        var videoDevice : AVCaptureDevice?
        
        if SP_VERSION_10_UP {
            videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: postion)
        }else{
            for device in devices {
                if device.position == postion {
                    videoDevice = device
                }
            }
        }
        if let currDevice = videoDevice {
            self.currentDevice = currDevice
        }
    }
    deinit {
        sp_log(message: "销毁对象 ")
        self.sp_cance()
    }
    
}
//MARK: - action
extension SPRecordVideoManager{
    // 开始录制
    func sp_startRecord(){
        guard cameraAuth else {
            return
        }
        
        sp_mainQueue {
            self.sp_setupAssertWrirer()
            self.isFirstVideo = false
            self.startRecording = true
            self.assetWriter?.startWriting()
            self.assetWriter?.startSession(atSourceTime: self.lastSampleTime!)
        }
    }
    /**< 初始化writer 文件输入  */
    fileprivate func sp_setupAssertWrirer(){
        FileManager.sp_directory(createPath: kVideoTempDirectory)
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                FileManager.remove(path: filePath)
                sp_log(message: "file is exist ")
            }
            self.videoSize = sp_pixeSize()
            let size = self.videoSize
            
            assetWriter = try AVAssetWriter(url:  URL(fileURLWithPath: filePath), fileType: AVFileType.mp4)
            let videoOutputSettings : [String : Any]
            
            if #available(iOS 11.0, *) {
                videoOutputSettings = [AVVideoCodecKey : AVVideoCodecHEVC,
                                       AVVideoWidthKey : size.width,
                                       AVVideoHeightKey : size.height,
                ]
            } else {
                // Fallback on earlier versions
                videoOutputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoWidthKey : size.width,
                                       AVVideoHeightKey : size.height,
                ]
            }
            
            var videoFormat : CMFormatDescription? = nil
            if #available(iOS 11.0, *) {
                CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault, codecType: kCMVideoCodecType_HEVC, width: Int32(size.width), height: Int32(size.height), extensions: nil, formatDescriptionOut: &videoFormat)
            }else{
                CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault, codecType: kCMVideoCodecType_H264, width: Int32(size.width), height: Int32(size.height), extensions: nil, formatDescriptionOut: &videoFormat)
            }
            
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            videoWriterInput?.expectsMediaDataInRealTime = true
//            videoWriterInput?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            
            let sourcePixelBufferAttributesDictionary = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(sp_getCVPixelFormatType()),
                String(kCVPixelBufferWidthKey) : size.width,
                String(kCVPixelBufferHeightKey) : size.height ,
                String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                ] as [String : Any]
            
            videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput!, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
            
            if (assetWriter?.canAdd(videoWriterInput!))! {
                assetWriter?.add(videoWriterInput!)
            }else {
                sp_log(message: "is no add  videoWriterInput")
            }
            audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioSetting)
            audioWriterInput?.expectsMediaDataInRealTime = true
            if (assetWriter?.canAdd(audioWriterInput!))! {
                assetWriter?.add(audioWriterInput!)
            }else{
                sp_log(message: "is no add audioWriterInput")
            }
            self.sp_logWriterStatus()
            sp_log(message: "setupAssertWrirer end ")
        }catch {
            sp_log(message: "writer is catch \(error)")
        }
    }
    
    // 停止录制
    func sp_stopRecord(){
        guard cameraAuth else {
            return
        }
        self.startRecording = false
        self.isFirstVideo = false
        if (self.videoWriterInput?.isReadyForMoreMediaData)!{
            videoWriterInput?.markAsFinished()
        }
        if (self.audioWriterInput?.isReadyForMoreMediaData)! {
            audioWriterInput?.markAsFinished()
        }
        
        assetWriter?.finishWriting(completionHandler: { [weak self] () in
            sp_log(message: "assetwriter error is \(String(describing: self?.assetWriter?.error.debugDescription))")
            if self?.assetWriter?.error != nil{
                //                FileManager.remove(path: self.filePath)
            }else{
                do {
                    try FileManager.default.copyItem(atPath: sp_getString(string: self?.filePath), toPath: "\(kVideoDirectory)/\(SPVideoHelp.getVideoName())")
                    SPVideoHelp.sp_send(notificationName: kVideoChangeNotification)
                }catch _{
                    
                }
            }
            self?.assetWriter = nil
        })
    }
    /// 切换摄像头
    func sp_changeCamera(){
        guard cameraAuth else {
            return
        }
        let postion = currentDevice?.position
        self.sp_captureInpunt(postion: postion == .back ? .front : .back)
        self.sp_changeCameraAnimate()
    }
    /// 切换镜头的动画
    fileprivate func sp_changeCameraAnimate(){
        let changeAnimate = CATransition()
        changeAnimate.delegate = self
        changeAnimate.duration = 0.4
        changeAnimate.type = CATransitionType(rawValue: "oglFlip")
        changeAnimate.subtype = CATransitionSubtype.fromRight
        videoLayer?.add(changeAnimate, forKey: "changeAnimate")
    }
    /// 放大
    func sp_zoomIn(scale : CGFloat = 1.0){
        SPCameraHelp.sp_zoomIn(device: self.currentDevice, scale: scale)
     
    }
    //缩小
    func sp_zoomOut(scale : CGFloat = 1.0) {
        SPCameraHelp.sp_zoomOut(device: self.currentDevice, scale: scale)
    }
    /// 闪光灯设置
    ///
    /// - Returns: 是否打开闪关灯 true 打开 false 没有打开
    func sp_flashlight()->Bool{
        guard cameraAuth else {
            return false
        }
        if SP_IS_IPAD {
            return false
        }
        return SPCameraHelp.sp_flash(device: self.currentDevice)
    }
    // MARK: -- 私有方法
    /**< 改变属性操作 */
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
    
    /// 点击取消
    func sp_cance(){
        SPCameraHelp.sp_flashOff(device: self.currentDevice)
        if let  assetWriter = assetWriter{
            videoWriterInput = nil
            audioWriterInput = nil
            if assetWriter.status == .writing {
                assetWriter.cancelWriting()
            }
        }
        self.assetWriter = nil
        self.captureSession.stopRunning()
        
    }
  
    /// 打印文件输入的状态
    fileprivate func sp_logWriterStatus(){
        switch self.assetWriter?.status {
        case .none:
            sp_log(message: "none")
        case .some(.unknown):
            sp_log(message: "unkonwn")
        case .some(.writing):
            sp_log(message: "writer")
        case .some(.completed):
            sp_log(message: "completed")
        case .some(.failed):
            sp_log(message: "failed \(String(describing: self.assetWriter?.error))")
        case .some(.cancelled):
            sp_log(message: "cancelled")
        }
    }
}
//MARK: - delegate
extension SPRecordVideoManager {
    // MARK: -- delegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        autoreleasepool {
            
            if !CMSampleBufferDataIsReady(sampleBuffer) {
                return
            }
            
            let currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
            self.lastSampleTime = currentSampleTime
            var outputImage : CIImage? = nil
            if output == self.videoOutput{
                let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
                outputImage = CIImage(cvPixelBuffer: imageBuffer)
                var noFilterOutputImage  : CIImage? = outputImage
                noFilterOutputImage =  UIImage.sp_picRotating(imgae: noFilterOutputImage)
                self.noFilterCIImage = CIImage(cgImage:  self.ciContext.createCGImage(noFilterOutputImage!, from: (noFilterOutputImage?.extent)!)!)
                outputImage = SPCameraHelp.sp_deal(videoImg: outputImage, filter: self.filter, faceCoverImg: self.faceCoverImg, videoLayoutType: self.videoLayoutType)
            }
            if startRecording == true && self.assetWriter != nil{
                if output == self.videoOutput {
                    self.isFirstVideo = true
                    // 写入图像
                    let newPixelbuffer = UIImage.sp_pixelBuffer(fromImage: UIImage.convertCIImageToCGImage(ciImage: outputImage!), pixelBufferPool: self.videoWriterPixelbufferInput?.pixelBufferPool,pixelFormatType: sp_getCVPixelFormatType(),pixelSize: self.videoSize)
                    self.writerVideo(toPixelBuffer: newPixelbuffer, time: currentSampleTime)
                }
                // 必须第一帧为视频流后才能加入音频
                if (output == self.audioOutput && self.isFirstVideo){
                    // 音频
                    self.writerAudio(didOutputSampleBuffer: sampleBuffer)
                }
            }
            if outputImage != nil {
                let cgImage = self.ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
                sp_mainQueue {
                    self.videoLayer?.contents = cgImage
                }
            }
        }
    }
    /// 写入视频帧数据
    fileprivate func writerVideo(toPixelBuffer pixelBuffer:CVPixelBuffer?, time :CMTime? ){
        if self.startRecording == true,self.assetWriter != nil ,self.assetWriter?.status == .writing,self.videoWriterPixelbufferInput != nil , (self.videoWriterPixelbufferInput?.assetWriterInput.isReadyForMoreMediaData)! , pixelBuffer != nil , time != nil {
            let success = self.videoWriterPixelbufferInput?.append(pixelBuffer!, withPresentationTime: time!)
            if success == false{
                sp_log(message: "video append failur is \(String(describing: self.assetWriter?.error.debugDescription))")
            }
        }
    }
    /// 写入音频帧数据
    fileprivate func writerAudio(didOutputSampleBuffer sampleBuffer: CMSampleBuffer?){
        if startRecording == true ,self.assetWriter != nil ,self.assetWriter?.status == .writing,sampleBuffer != nil , audioWriterInput != nil ,(audioWriterInput?.isReadyForMoreMediaData)!  {
            let success = audioWriterInput?.append(sampleBuffer!)
            if success == false{
                sp_log(message: "audio append is failure \(String(describing: assetWriter?.error.debugDescription))")
            }
        }
    }
}
