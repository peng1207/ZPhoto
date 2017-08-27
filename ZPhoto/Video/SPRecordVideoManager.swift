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



class SPRecordVideoManager: NSObject,AVCaptureFileOutputRecordingDelegate,CAAnimationDelegate{
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    fileprivate let captureSession = AVCaptureSession()
    fileprivate let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
    fileprivate var currentDevice : AVCaptureDevice?
    //音频输入设备
    fileprivate let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    //将捕获到的视频输出到文件
    fileprivate let fileOutput = AVCaptureMovieFileOutput()
    //保存所有的录像片段数组
    var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    var assetURLs = [String]()
    //单独录像片段的index索引
    var appendix: Int32 = 1
    //每秒帧数
    var framesPerSecond:Int32 = 30
    var videoLayer : AVCaptureVideoPreviewLayer?
    // 放大最大的倍数
    var maxZoomActore :CGFloat = 5.00
    var minZoomActore : CGFloat = 1.00
    // 开始录制
    var startRecording : Bool = false
    // 是否停止
    var isStop  = false
    
    override init() {
        super.init()
        self.setupRecord()
    }
    // 设置视频的初始化
    fileprivate func setupRecord(){
        self.setCaptureInpunt(postion: .back)
        videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        self.captureSession.startRunning()
    }
    fileprivate func setCaptureInpunt(postion : AVCaptureDevicePosition){
         self.getVideoDevice(postion: postion)
        let videoInput = try! AVCaptureDeviceInput(device: self.currentDevice)
        let audioInput = try! AVCaptureDeviceInput(device: self.audioDevice)
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
        if self.captureSession.canAddOutput(self.fileOutput){
            self.captureSession.addOutput(self.fileOutput)
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
        startRecording = true
        isStop = false
        let outputFilePath = "\(kTmpPath)/output-\(appendix).mov"
        appendix += 1
        let outputURL = URL(fileURLWithPath: outputFilePath)
        
        FileManager.remove(path: outputFilePath)
        fileOutput.startRecording(toOutputFileURL: outputURL, recordingDelegate: self)
    }
    // 停止录制
    func sp_stopRecord(){
        isStop = true
        startRecording = false
        fileOutput.stopRecording()
    }
    // 保存视频
    fileprivate func sp_saveVideo(){
        FileManager.directory(createPath: SPVideoHelp.kVideoDirectory)
        SPVideoHelp.mergeVideos(videoAsset: self.videoAssets, outputPath: "\(SPVideoHelp.kVideoDirectory)/\(SPVideoHelp.getVideoName())") {
            SPVideoHelp.sendNotification(notificationName: kVideoChangeNotification)
        }
    }
    // 切换镜头
    func sp_changeVideoDevice(){
        let postion = currentDevice?.position
        fileOutput.stopRecording()
        self.setCaptureInpunt(postion: postion == .back ? .front : .back)
         self.sp_changeCameraAnimate()
        if startRecording  {
            self.sp_startRecord()
        }
    }
    
    func sp_changeCameraAnimate(){
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
                // 请求锁定设备
                try! currentDevice?.lockForConfiguration()
                // 平滑放大
                currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 2.0)
                // 释放设备
                currentDevice?.unlockForConfiguration()
            }
        }
    }
    //缩小
    func sp_zoomOut(scale : CGFloat = 1.0) {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            SPLog("\(zoomFactor)")
            if zoomFactor > minZoomActore {
                let newZoomFactor = max(zoomFactor - scale, minZoomActore)
                // 请求锁定设备
                try! currentDevice?.lockForConfiguration()
                // 平滑放大
                currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 2.0)
                // 释放设备
                currentDevice?.unlockForConfiguration()
            }
        }
    }
    // MARK: -- 闪光灯设置
    func sp_flashlight(){
        if self.currentDevice?.position == AVCaptureDevicePosition.front {
         return
        }
        if self.currentDevice?.torchMode == AVCaptureTorchMode.off {
            do {
             try currentDevice?.lockForConfiguration()
            }catch _{
             
            }
            currentDevice?.torchMode = AVCaptureTorchMode.on
            currentDevice?.flashMode = AVCaptureFlashMode.on
            currentDevice?.unlockForConfiguration()
        }else{
            do {
                try currentDevice?.lockForConfiguration()
            }catch _{
                
            }
            currentDevice?.torchMode = AVCaptureTorchMode.off
            currentDevice?.flashMode = AVCaptureFlashMode.off
            currentDevice?.unlockForConfiguration()
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        if isStop {
            self.sp_saveVideo()
        }
    }
    
}
