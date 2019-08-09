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
    
     fileprivate let devices = { () -> [AVCaptureDevice] in
        if SP_VERSION_10_UP == false{
            return AVCaptureDevice.devices(for: AVMediaType.video)
        }else{
            let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
            return (deviceDiscovery.devices)
        }
    }()
    
    fileprivate var currentDevice : AVCaptureDevice?
    //音频输入设备
    fileprivate let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    
    // 视频源的出口
    var videoOutput : AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    //是视频源的控制中心
    var videoConnection: AVCaptureConnection?
    //  音频源的出口
    var  audioOutput : AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
    //音频源的控制中心
    var audioConnection: AVCaptureConnection?
    var videoLayer : AVCaptureVideoPreviewLayer? {
        didSet{
            videoLayer?.videoGravity = AVLayerVideoGravity.resize
            //            videoLayer?.setSessionWithNoConnection(captureSession)
        }
    }
 
   fileprivate var noCameraAuthBlock : NOAuthBlock?
    fileprivate var noMicrophoneBlock : NOAuthBlock?
    // 放大最大的倍数
    var maxZoomActore :CGFloat = 5.00
    var minZoomActore : CGFloat = 1.00
    // 开始录制
    var startRecording : Bool = false
    var isFirstVideo : Bool = false
    var assetWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    var audioWriterInput: AVAssetWriterInput?
    var videoWriterPixelbufferInput : AVAssetWriterInputPixelBufferAdaptor?
    var currentVideoDimensions: CMVideoDimensions?
    var lastSampleTime : CMTime?
    let  filePath : String = "\(SPVideoHelp.kVideoTempDirectory)/temp.mp4"
    var filter : CIFilter?
    @objc dynamic  var noFilterCIImage : CIImage?
    var cameraAuth : Bool = false  // 有没摄像头权限
    
    
    let videoDataOutputQueue :DispatchQueue = DispatchQueue(label: "com.hsp.videoDataOutputQueue")
    
    let audioDataOutputQueue : DispatchQueue = DispatchQueue(label: "com.hsp.audioDataOutputQueue")
    // 写入音频参数
    let audioSetting: [String: AnyObject] = [
        AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: 1 as AnyObject,
        AVSampleRateKey: 22050 as AnyObject
    ]
    lazy var ciContext: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [CIContextOption.workingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    override init() {
        super.init()
    }
    // 设置视频的初始化
    func setupRecord(){
        SPAuthorizatio.sp_isCamera{ (authorized) in
            self.cameraAuth = authorized
            if authorized{
                // 有权限
                self.isRecordAuth()
            }else{
                // 没有权限
                self.noAuthorizedComplete(noAuthBlock: self.noCameraAuthBlock)
            }
        }
    }
    func setup(noCameraAuthBlock:NOAuthBlock?,noMicrophoneBlock:NOAuthBlock?){
        self.noCameraAuthBlock = noCameraAuthBlock
        self.noMicrophoneBlock = noMicrophoneBlock
    }
    
    /*
     判断麦克风权限
     */
    fileprivate func isRecordAuth(){
        SPAuthorizatio.sp_isRecord { (authorized) in
             self.setupInit()
            if authorized == false {
                self.noAuthorizedComplete(noAuthBlock: self.noMicrophoneBlock)
            }
        }
    }
    
    /*
     初始化组件
     */
    fileprivate func setupInit(){
        self.setCaptureInpunt(postion: .back)
        self.captureSession.startRunning()
    }
    /*
     没有权限时的回调
     */
    fileprivate func noAuthorizedComplete(noAuthBlock :NOAuthBlock?){
        guard let complete = noAuthBlock else {
            return
        }
        complete()
    }
    fileprivate func sp_getCVPixelFormatType()->OSType{
        return kCVPixelFormatType_32BGRA
    }
    
    fileprivate func setCaptureInpunt(postion : AVCaptureDevice.Position){
        self.getVideoDevice(postion: postion)
        let videoInput = try? AVCaptureDeviceInput(device: self.currentDevice!)
        let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!)
        self.captureSession.beginConfiguration()
        for input in self.captureSession.inputs {
            self.captureSession.removeInput((input as? AVCaptureInput)!)
        }
        if self.captureSession.canAddInput(videoInput!) {
            self.captureSession.addInput(videoInput!)
        }
        if self.captureSession.canAddInput(audioInput!) {
            self.captureSession.addInput(audioInput!)
        }
    
     
        
        self.changeDeviceProperty {
            self.currentDevice?.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 15)
            self.currentDevice?.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 15)
        }
        let needAdd : Bool = self.captureSession.outputs.count > 0 ? false : true
        
        if needAdd == true {
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(sp_getCVPixelFormatType())] as [String : Any]
            
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            
            audioOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
            
            if self.captureSession.canAddOutput(videoOutput){
                self.captureSession.addOutput(videoOutput)
            }
            videoConnection = videoOutput.connection(with: AVMediaType.video)
            
            if self.captureSession.canAddOutput(audioOutput) {
                self.captureSession.addOutput(audioOutput)
            }
            audioConnection = audioOutput.connection(with: AVMediaType.audio)
        }
        self.captureSession.commitConfiguration()
    }
    
    // 获取当前的摄像头
    fileprivate func getVideoDevice(postion : AVCaptureDevice.Position) {
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
    // 开始录制
    func sp_startRecord(){
        guard cameraAuth else {
            return
        }
        
        sp_mainQueue {
            self.setupAssertWrirer()
            self.isFirstVideo = false
            self.startRecording = true
            self.assetWriter?.startWriting()
            self.assetWriter?.startSession(atSourceTime: self.lastSampleTime!)
        }
    }
    /**< 初始化writer  */
    fileprivate func setupAssertWrirer(){
        FileManager.sp_directory(createPath: SPVideoHelp.kVideoTempDirectory)
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                FileManager.remove(path: filePath)
                sp_log(message: "file is exist ")
            }
            
            let size = sp_screenPixels()
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
            videoWriterInput?.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            
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
            self.logWriterStatus()
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
                let asset = AVAsset(url: URL(fileURLWithPath: (self?.filePath)!))
                SPVideoHelp.recordForDeal(asset: asset, outputPath: "\(SPVideoHelp.kVideoDirectory)/\(SPVideoHelp.getVideoName())") { (newAsset ,url) in
                    SPVideoHelp.sendNotification(notificationName: kVideoChangeNotification)
                }
            }
            self?.assetWriter = nil
        })
    }
    // 切换镜头
    func sp_changeVideoDevice(){
        guard cameraAuth else {
            return
        }
        let postion = currentDevice?.position
        self.setCaptureInpunt(postion: postion == .back ? .front : .back)
        self.sp_changeCameraAnimate()
    }
    // 切换镜头的动画
    fileprivate func sp_changeCameraAnimate(){
        let changeAnimate = CATransition()
        changeAnimate.delegate = self
        changeAnimate.duration = 0.4
        changeAnimate.type = CATransitionType(rawValue: "oglFlip")
        changeAnimate.subtype = CATransitionSubtype.fromRight
        videoLayer?.add(changeAnimate, forKey: "changeAnimate")
    }
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    // 放大
    func sp_zoomIn(scale : CGFloat = 1.0){
        
        if let zoomFactor = self.currentDevice?.videoZoomFactor{
            sp_log(message: "\(zoomFactor)")
            if zoomFactor < maxZoomActore {
                let newZoomFactor = min(zoomFactor + scale, maxZoomActore)
                self.changeDeviceProperty(propertyBlock: {  [weak self]()  in
                    // 平滑放大
                    //                    self?.currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 2.0)
                    self?.currentDevice?.videoZoomFactor = newZoomFactor
                })
            }
        }
    }
    //缩小
    func sp_zoomOut(scale : CGFloat = 1.0) {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            sp_log(message: "\(zoomFactor)")
            if zoomFactor > minZoomActore {
                let newZoomFactor = max(zoomFactor - scale, minZoomActore)
                self.changeDeviceProperty(propertyBlock: { [weak self]()  in
                    // 平滑放大
                    //                    self?.currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 2.0)
                    self?.currentDevice?.videoZoomFactor = newZoomFactor
                })
            }
        }
    }
    // MARK: -- 闪光灯设置
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
    func sp_flashOn(){
        if SP_IS_IPAD {
            return
        }
        if !(self.currentDevice?.hasFlash)! {
            return
        }
        if  !(self.currentDevice?.hasTorch)! {
            return
        }
        self.changeDeviceProperty(propertyBlock: { [weak self]() in
            if self?.currentDevice?.torchMode == AVCaptureDevice.TorchMode.off {
                self?.currentDevice?.torchMode = AVCaptureDevice.TorchMode.on
            }
            if self?.currentDevice?.flashMode == AVCaptureDevice.FlashMode.off {
                self?.currentDevice?.flashMode = AVCaptureDevice.FlashMode.on
            }
           
        })
    }
    /*
     关闭闪光灯
     */
    func sp_flashOff(){
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
        self.changeDeviceProperty(propertyBlock: { [weak self]() in
            if self?.currentDevice?.torchMode == AVCaptureDevice.TorchMode.on {
                self?.currentDevice?.torchMode = AVCaptureDevice.TorchMode.off
            }
            if self?.currentDevice?.flashMode == AVCaptureDevice.FlashMode.on {
                self?.currentDevice?.flashMode = AVCaptureDevice.FlashMode.off
            }
        })
        
    }
    
    // MARK: -- 私有方法
    /**< 改变属性操作 */
    fileprivate func changeDeviceProperty(propertyBlock:PropertyChangeBlock?){
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
                // 执行判断人脸 然后增加头像上去
//                outputImage = UIImage.sp_detectFace(inputImg: outputImage!, coverImg: UIImage(named: "filter"))
                if self.filter != nil {
                    self.filter?.setValue(outputImage!, forKey: kCIInputImageKey)
                    outputImage = self.filter?.outputImage
                }
            }
            
            if startRecording == true && self.assetWriter != nil{
                if output == self.videoOutput {
                    self.isFirstVideo = true
                    // 写入图像
                    let newPixelbuffer = UIImage.sp_pixelBuffer(fromImage: UIImage.convertCIImageToCGImage(ciImage: outputImage!), pixelBufferPool: self.videoWriterPixelbufferInput?.pixelBufferPool,pixelFormatType: sp_getCVPixelFormatType())
                    self.writerVideo(toPixelBuffer: newPixelbuffer, time: currentSampleTime)
                }
                // 必须第一帧为视频流后才能加入音频
                if (output == self.audioOutput && self.isFirstVideo){
                    // 音频
                    self.writerAudio(didOutputSampleBuffer: sampleBuffer)
                }
            }
            if outputImage != nil {
                outputImage =  UIImage.sp_picRotating(imgae: outputImage)
                let cgImage = self.ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
                sp_mainQueue {
                    self.videoLayer?.contents = cgImage
                }
            }
        }
    }
    
    /**< 写入视频文件 */
    fileprivate func writerVideo(toPixelBuffer pixelBuffer:CVPixelBuffer?, time :CMTime? ){
        if self.startRecording == true,self.assetWriter != nil ,self.assetWriter?.status == .writing,self.videoWriterPixelbufferInput != nil , (self.videoWriterPixelbufferInput?.assetWriterInput.isReadyForMoreMediaData)! , pixelBuffer != nil , time != nil {
            let success = self.videoWriterPixelbufferInput?.append(pixelBuffer!, withPresentationTime: time!)
            if success == false{
                sp_log(message: "video append failur is \(String(describing: self.assetWriter?.error.debugDescription))")
            }
        }
    }
    /**< 写入音频文件 */
    fileprivate func writerAudio(didOutputSampleBuffer sampleBuffer: CMSampleBuffer?){
        if startRecording == true ,self.assetWriter != nil ,self.assetWriter?.status == .writing,sampleBuffer != nil , audioWriterInput != nil ,(audioWriterInput?.isReadyForMoreMediaData)!  {
            let success = audioWriterInput?.append(sampleBuffer!)
            if success == false{
                sp_log(message: "audio append is failure \(String(describing: assetWriter?.error.debugDescription))")
            }
        }
    }
    /**< 点击取消  */
    func sp_cance(){
        if let  assetWriter = assetWriter{
            videoWriterInput = nil
            audioWriterInput = nil
            if assetWriter.status == .writing {
                assetWriter.cancelWriting()
            }
        }
        self.assetWriter = nil
    }
    deinit {
        sp_log(message: "销毁对象 ")
        self.sp_cance()
    }
    /**< 打印 writerStatus */
    fileprivate func logWriterStatus(){
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
