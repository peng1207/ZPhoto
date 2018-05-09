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

typealias PropertyChangeBlock = ()->Void
// 没有相机权限的回调
typealias NOAuthBlock = () ->Void


class SPRecordVideoManager: NSObject,CAAnimationDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    fileprivate let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
    fileprivate var currentDevice : AVCaptureDevice?
    //音频输入设备
    fileprivate let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
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
            videoLayer?.videoGravity = AVLayerVideoGravityResize
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
    var assetWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    var audioWriterInput: AVAssetWriterInput?
    var videoWriterPixelbufferInput : AVAssetWriterInputPixelBufferAdaptor?
    var currentVideoDimensions: CMVideoDimensions?
    var lastSampleTime : CMTime?
    let  filePath : String = "\(SPVideoHelp.kVideoTempDirectory)/temp.mp4"
    var filter : CIFilter?
    dynamic  var noFilterCIImage : CIImage?
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
        let options = [kCIContextWorkingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    override init() {
        super.init()
    }
    // 设置视频的初始化
    func setupRecord(){
        SPAuthorizatio.isRightCamera { (authorized) in
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
        SPAuthorizatio.isRightRecord { (authorized) in
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
    
    fileprivate func setCaptureInpunt(postion : AVCaptureDevicePosition){
        self.getVideoDevice(postion: postion)
        let videoInput = try? AVCaptureDeviceInput(device: self.currentDevice)
        let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice)
        self.captureSession.beginConfiguration()
        for input in self.captureSession.inputs {
            self.captureSession.removeInput(input as! AVCaptureInput)
        }
        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
        }
        if self.captureSession.canAddInput(audioInput) {
            self.captureSession.addInput(audioInput)
        }
    
     
        
        self.changeDeviceProperty {
            self.currentDevice?.activeVideoMinFrameDuration = CMTimeMake(1, 15)
            self.currentDevice?.activeVideoMaxFrameDuration = CMTimeMake(1, 15)
        }
        let needAdd : Bool = self.captureSession.outputs.count > 0 ? false : true
        
        if needAdd == true {
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(kCVPixelFormatType_32BGRA)]
            
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            
            audioOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
            
            if self.captureSession.canAddOutput(videoOutput){
                self.captureSession.addOutput(videoOutput)
            }
            videoConnection = videoOutput.connection(withMediaType: AVMediaTypeVideo)
            
            if self.captureSession.canAddOutput(audioOutput) {
                self.captureSession.addOutput(audioOutput)
            }
            audioConnection = audioOutput.connection(withMediaType: AVMediaTypeAudio)
        }
        self.captureSession.commitConfiguration()
    }
    
    // 获取当前的摄像头
    fileprivate func getVideoDevice(postion : AVCaptureDevicePosition) {
        var videoDevice : AVCaptureDevice?
        for device in devices {
            if device.position == postion {
                videoDevice = device
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
        
        dispatchMainQueue {
            self.setupAssertWrirer()
            self.startRecording = true
            self.assetWriter?.startWriting()
            self.assetWriter?.startSession(atSourceTime: self.lastSampleTime!)
        }
    }
    /**< 初始化writer  */
    fileprivate func setupAssertWrirer(){
        FileManager.directory(createPath: SPVideoHelp.kVideoTempDirectory)
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                FileManager.remove(path: filePath)
                SPLog("file is exist ")
            }
            
            let size = screenPixels()
            assetWriter = try AVAssetWriter(url:  URL(fileURLWithPath: filePath), fileType: AVFileTypeMPEG4)
            
            let videoOutputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoWidthKey : size.width,
                                       AVVideoHeightKey : size.height,
                                       ] as [String : Any]
            var videoFormat : CMFormatDescription? = nil
            CMVideoFormatDescriptionCreate(kCFAllocatorDefault, kCMVideoCodecType_H264, Int32(size.width), Int32(size.height), nil, &videoFormat)
            
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoOutputSettings)
            videoWriterInput?.expectsMediaDataInRealTime = true
            videoWriterInput?.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI/2))
            
            let sourcePixelBufferAttributesDictionary = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_32BGRA),
                String(kCVPixelBufferWidthKey) : size.width,
                String(kCVPixelBufferHeightKey) : size.height ,
                String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                ] as [String : Any]
            
            videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput!, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
            
            if (assetWriter?.canAdd(videoWriterInput!))! {
                assetWriter?.add(videoWriterInput!)
            }else {
                SPLog("is no add  videoWriterInput")
            }
            audioWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio, outputSettings: audioSetting)
            audioWriterInput?.expectsMediaDataInRealTime = true
            if (assetWriter?.canAdd(audioWriterInput!))! {
                assetWriter?.add(audioWriterInput!)
            }else{
                SPLog("is no add audioWriterInput")
            }
            self.logWriterStatus()
            SPLog("setupAssertWrirer end ")
        }catch {
            SPLog("writer is catch \(error)")
        }
    }
    
    // 停止录制
    func sp_stopRecord(){
        guard cameraAuth else {
            return
        }
        self.startRecording = false
        if (self.videoWriterInput?.isReadyForMoreMediaData)!{
            videoWriterInput?.markAsFinished()
        }
        if (self.audioWriterInput?.isReadyForMoreMediaData)! {
            audioWriterInput?.markAsFinished()
        }
        assetWriter?.finishWriting(completionHandler: { [weak self] () in
            SPLog("assetwriter error is \(String(describing: self?.assetWriter?.error.debugDescription))")
            if self?.assetWriter?.error != nil{
                //                FileManager.remove(path: self.filePath)
            }else{
                let asset = AVAsset(url: URL(fileURLWithPath: (self?.filePath)!))
                SPVideoHelp.recordForDeal(asset: asset, outputPath: "\(SPVideoHelp.kVideoDirectory)/\(SPVideoHelp.getVideoName())") {
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
        changeAnimate.type = "oglFlip"
        changeAnimate.subtype = kCATransitionFromRight
        videoLayer?.add(changeAnimate, forKey: "changeAnimate")
    }
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    // 放大
    func sp_zoomIn(scale : CGFloat = 1.0){
        
        if let zoomFactor = self.currentDevice?.videoZoomFactor{
            SPLog("\(zoomFactor)")
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
            SPLog("\(zoomFactor)")
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
        if self.currentDevice?.position == AVCaptureDevicePosition.front {
            return
        }
        if self.currentDevice?.torchMode == AVCaptureTorchMode.off {
            self.changeDeviceProperty(propertyBlock: { [weak self]() in
                self?.currentDevice?.torchMode = AVCaptureTorchMode.on
                self?.currentDevice?.flashMode = AVCaptureFlashMode.on
            })
        }else{
            self.changeDeviceProperty(propertyBlock: { [weak self]() in
                self?.currentDevice?.torchMode = AVCaptureTorchMode.off
                self?.currentDevice?.flashMode = AVCaptureFlashMode.off
            })
            
        }
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
    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
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
                noFilterOutputImage = picRotating(imgae: noFilterOutputImage)
                self.noFilterCIImage =  CIImage(cgImage:  self.ciContext.createCGImage(noFilterOutputImage!, from: (noFilterOutputImage?.extent)!)!)
                
                if self.filter != nil {
                    self.filter?.setValue(outputImage!, forKey: kCIInputImageKey)
                    outputImage = self.filter?.outputImage
                }
            }
            
            if startRecording == true && self.assetWriter != nil{
                if output == self.videoOutput {
                    let newPixelbuffer = self.pixelBuffer(fromImage:   UIImage.convertCIImageToCGImage(ciImage: outputImage!),pixelBufferPool: self.videoWriterPixelbufferInput?.pixelBufferPool)
                    self.writerVideo(toPixelBuffer: newPixelbuffer, time: currentSampleTime)
                    
                }
                if (output == self.audioOutput){
                    // 音频
                    self.writerAudio(didOutputSampleBuffer: sampleBuffer)
                }
            }
            if outputImage != nil {
                outputImage = picRotating(imgae: outputImage)
                let cgImage = self.ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
                dispatchMainQueue {
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
                SPLog("video append failur is \(String(describing: self.assetWriter?.error.debugDescription))")
            }
        }
    }
    /**< 写入音频文件 */
    fileprivate func writerAudio(didOutputSampleBuffer sampleBuffer: CMSampleBuffer?){
        if startRecording == true ,self.assetWriter != nil ,self.assetWriter?.status == .writing,sampleBuffer != nil , audioWriterInput != nil ,(audioWriterInput?.isReadyForMoreMediaData)!  {
            let success = audioWriterInput?.append(sampleBuffer!)
            if success == false{
                SPLog("audio append is failure \(String(describing: assetWriter?.error.debugDescription))")
            }
        }
    }
    
    /**< 将 CGImage 转成CVPixelBuffer */
    fileprivate func pixelBuffer(fromImage image:CGImage,pixelBufferPool:CVPixelBufferPool?) -> CVPixelBuffer?{
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        
        let width = image.width
        let height = image.height
        
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, options, &pxbuffer)
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);
        
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
        // 放大
        //        context?.concatenate(CGAffineTransform(rotationAngle: 360))
        //        context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
        
        
        context?.draw(image, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!;
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
        SPLog("销毁对象 ")
        self.sp_cance()
    }
    /**< 打印 writerStatus */
    fileprivate func logWriterStatus(){
        switch self.assetWriter?.status {
        case .none:
            SPLog("none")
        case .some(.unknown):
            SPLog("unkonwn")
        case .some(.writing):
            SPLog("writer")
        case .some(.completed):
            SPLog("completed")
        case .some(.failed):
            SPLog("failed \(String(describing: self.assetWriter?.error))")
        case .some(.cancelled):
            SPLog("cancelled")
        }
    }
    
}
