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



class SPRecordVideoManager: NSObject,AVCaptureFileOutputRecordingDelegate{
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
    
    var startRecording : Bool = false
    
    var isStop  = false
    
    
    static let kVideoDirectory = "\(kDocumentsPath)/video"
    
    override init() {
        super.init()
        self.setupRecord()
    }
    // 设置视频的初始化
    fileprivate func setupRecord(){
        self.setCaptureInpunt(postion: .back)
        self.captureSession.addOutput(self.fileOutput)
        videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        self.captureSession.startRunning()
    }
    fileprivate func setCaptureInpunt(postion : AVCaptureDevicePosition){
         self .getVideoDevice(postion: postion)
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
    // 获取视频的名称
    fileprivate func getVideoName() -> String {
        let date = NSDate()
        return "video_\(Int(date.timeIntervalSince1970)).mov"
    }
    
    // 开始录制
    func sp_startRecord(){
        startRecording = true
        isStop = false
        let outputFilePath = "\(kTmpPath)/output-\(appendix).mov"
        appendix += 1
        let outputURL = URL(fileURLWithPath: outputFilePath)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: outputFilePath) {
            do {
                try fileManager.removeItem(atPath: outputFilePath)
            } catch _ {
                
            }
        }
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
        do {
            try FileManager.default.createDirectory(atPath: SPRecordVideoManager.kVideoDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch _{
            
        }
        
        SPVideoHelp.mergeVideos(videoAsset: self.videoAssets, outputPath: "\(SPRecordVideoManager.kVideoDirectory)/\(getVideoName())") {
            
        }
    }
    
    
    // 切换镜头
    func sp_changeVideoDevice(){
        let postion = currentDevice?.position
        fileOutput.stopRecording()
        self.setCaptureInpunt(postion: postion == .back ? .front : .back)
        if startRecording  {
            self.sp_startRecord()
        }
        
    }
    // 放大
    func sp_zoomIn(){
        if let zoomFactor = self.currentDevice?.videoZoomFactor{
            if zoomFactor < maxZoomActore {
                let newZoomFactor = min(zoomFactor + 1.0, maxZoomActore)
                // 请求锁定设备
                try! currentDevice?.lockForConfiguration()
                // 平滑放大
                currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                // 释放设备
                currentDevice?.unlockForConfiguration()
            }
        }
    }
    //缩小
    func sp_zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                // 请求锁定设备
                try! currentDevice?.lockForConfiguration()
                // 平滑放大
                currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                // 释放设备
                currentDevice?.unlockForConfiguration()
                
            }
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
