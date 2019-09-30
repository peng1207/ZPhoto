//
//  SPVideoHelp.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/4/9.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SPCommonLibrary

/// 导出成功
typealias SPExportSuccess = (_ assert : AVAsset?,_ url : String)-> Void
let kVideoChangeNotification : String = "VideoChangeNotification"
/// 获取视频中音频视频的帧数据
typealias SPVideoSampleBuffer = (videoBuffers : [CMSampleBuffer]?,audioBuffers : [CMSampleBuffer]?,timeList : [CMTime]?)
class SPVideoHelp: NSObject {
  
    // 获取视频的名称
    class func getVideoName() -> String {
        let date = NSDate()
        return "video_\(Int(date.timeIntervalSince1970)).mp4"
    }
    /// 合并视频片段
    ///
    /// - Parameters:
    ///   - videoAsset: 视频数组
    ///   - outputPath: 导出的路径
    ///   - exportSuuccess: 回调
    class func sp_mergeVideos(videoAsset : [AVAsset],outputPath:String,exportSuuccess:@escaping SPExportSuccess) {
        let compostition = AVMutableComposition()
        //合并视频、音频轨道 
        let firstTrack = compostition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        let audioTrack = compostition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
        var insertTime : CMTime = CMTime.zero
        for asset  in videoAsset {
            do {
                try firstTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: asset.tracks(withMediaType: AVMediaType.video)[0], at: insertTime)
            } catch _ {
                
            }
            do {
                if let audioAsset = asset.tracks(withMediaType: AVMediaType.audio).first{
                     try audioTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: audioAsset, at: insertTime)
                }
            } catch _ {
                
            }
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: compostition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            sp_log(message: exporter.error)
            exportSuuccess(AVAsset(url: URL(fileURLWithPath: outputPath)),outputPath)
        })
    }
    /// 对录制好的视频处理
    ///
    /// - Parameters:
    ///   - asset: 视频
    ///   - outputPath: 导出的路径
    ///   - complete: 回调
    class func sp_recordForDeal(asset:AVAsset,outputPath:String,complete : @escaping SPExportSuccess)-> Void{
        let componsition = AVMutableComposition()
       
        let videoTrack = componsition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
       
        let videoAsset = asset.tracks(withMediaType: AVMediaType.video)[0]
        let videoDuration = videoAsset.timeRange.duration
        
        let videoStart = videoAsset.timeRange.start
        if asset.tracks(withMediaType: AVMediaType.audio).count > 0 {
            let audioTrack = componsition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
            let audioAsset = asset.tracks(withMediaType: AVMediaType.audio)[0]
            var audioDuration = audioAsset.timeRange.duration
            var audioStart = audioAsset.timeRange.start
            if CMTimeGetSeconds(videoAsset.timeRange.duration) < CMTimeGetSeconds(audioAsset.timeRange.duration) {
                audioDuration = videoDuration
                audioStart = videoStart
            }
            do {
                try audioTrack!.insertTimeRange(CMTimeRangeMake(start: audioStart, duration: audioDuration), of: audioAsset, at: CMTime.zero)
            } catch _{
                
            }
        }
        
        do {
            try videoTrack!.insertTimeRange(CMTimeRangeMake(start: videoStart, duration: videoDuration), of: videoAsset, at: CMTime.zero)
        }catch _{
            
        }
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: componsition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
             complete(AVAsset(url: URL(fileURLWithPath: outputPath)),outputPath)
        })
    }
    ///  将音频文件插入视频文件中
    ///
    /// - Parameters:
    ///   - asset: 视频文件
    ///   - audioAsset: 音频文件
    ///   - outPath: 导出的路径
    ///   - complete: 回调
    class func sp_videoAsset(asset : AVAsset,audioAssets:[AVAsset],outputPath : String,complete : @escaping SPExportSuccess)->Void{
        let compostion = AVMutableComposition()
        let videoTrack = compostion.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        
        guard let videoAsset = asset.tracks(withMediaType: .video).first else {
            return
        }
 
        let videoDuration = videoAsset.timeRange.duration
        let videoStart = videoAsset.timeRange.start
        
        if let inputTrack = asset.tracks(withMediaType: .audio).first {
            let audioTrack = compostion.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
            var audioDuration = inputTrack.timeRange.duration
            var audioStart = inputTrack.timeRange.start
            if CMTimeGetSeconds(videoAsset.timeRange.duration) < CMTimeGetSeconds(inputTrack.timeRange.duration) {
                audioDuration = videoDuration
                audioStart = videoStart
            }
            do {
                try audioTrack!.insertTimeRange(CMTimeRangeMake(start: audioStart, duration: audioDuration), of: inputTrack, at: CMTime.zero)
            } catch _{
                
            }
        }
        /// 将多个音频插入视频中
        for audioAsset in audioAssets {
            if let inputTrack = audioAsset.tracks(withMediaType: .audio).first {
                let audioCompositionTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID())
                var audioDuration = inputTrack.timeRange.duration
                var audioStart = inputTrack.timeRange.start
                if CMTimeGetSeconds(videoAsset.timeRange.duration) < CMTimeGetSeconds(inputTrack.timeRange.duration) {
                    audioDuration = videoDuration
                    audioStart = videoStart
                }
                do {
                    try audioCompositionTrack!.insertTimeRange(CMTimeRangeMake(start:  audioStart, duration: audioDuration), of: inputTrack, at: CMTime.zero)
                } catch _{

                }
            }
        }

        do {
            try videoTrack!.insertTimeRange(CMTimeRangeMake(start: videoStart, duration: videoDuration), of: videoAsset, at: CMTime.zero)
        }catch _{
            
        }
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            complete(AVAsset(url: URL(fileURLWithPath: outputPath)),outputPath)
        })
       
    }
    /// 根据assesst和time 获取对应的图片
    ///
    /// - Parameters:
    ///   - assesst: 视频
    ///   - time: 时间
    /// - Returns: 图片
    class func sp_thumbnailImage(assesst: AVAsset,time : CMTime) -> UIImage?{
        var thumbnailImage : UIImage? = nil
        let assetImageGenerator = AVAssetImageGenerator(asset: assesst)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.requestedTimeToleranceAfter = CMTime.zero
        assetImageGenerator.requestedTimeToleranceBefore = CMTime.zero
        assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        do {
            let thumbnailImageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnailImage = UIImage(cgImage: thumbnailImageRef)
            return thumbnailImage
        } catch {
            sp_log(message: "thumbnailImageTo error is \(error)")
            return nil
        }
    }

    /// 获取在本地的视频数据
    ///
    /// - Returns: 视频数组
    class func sp_videoFile() -> [SPVideoModel]? {
        var videoArray = [SPVideoModel]()
        let fileArray = sp_getfile(forDirectory: kVideoDirectory)
        for file in fileArray! {
            let path = "\(kVideoDirectory)/\(file)"
            let model = sp_getVideoModel(path: path)
            if  (model.asset != nil) {
                videoArray.append(model)
            }else{
                FileManager.remove(path:path)
            }
        }
        return videoArray
    }
    /*
     获取videomodel
     */
    class func sp_getVideoModel(path:String) -> SPVideoModel{
        let model = SPVideoModel();
        model.url = URL(fileURLWithPath: path)
        return model
    }
    
    
    /**
     删除视频文件
     */
    class func sp_remove(videoUrl:URL) -> Void{
        remove(fileUrl: videoUrl)
        sp_send(notificationName: kVideoChangeNotification)
    }
    /**
     删除文件
     */
    class func remove(fileUrl:URL) -> Void{
        try!  FileManager.default.removeItem(at: fileUrl)
    }
    ///  发送通知
    ///
    /// - Parameter notificationName: 通知名称
    class func sp_send(notificationName:String) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    /// 剪切视频 timeRange 剪切的位置
    ///
    /// - Parameters:
    ///   - asset: 视频
    ///   - timeRange: 剪切的位置
    ///   - completionHandler: 回调
    class func sp_shear(asset:AVAsset,timeRange: CMTimeRange,completionHandler:@escaping (_ outUrl:URL)->Void) ->  Void{
        let compostion  = AVMutableComposition()
        let videoTrack = compostion.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        let audioTrack = compostion.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
        do {
            try videoTrack!.insertTimeRange(timeRange, of: asset.tracks(withMediaType: AVMediaType.video)[0], at: CMTime.zero)
        }catch _ {
            
        }
        do {
            try audioTrack!.insertTimeRange(timeRange, of: asset.tracks(withMediaType: AVMediaType.audio)[0], at: CMTime.zero)
        }catch _ {
            
        }
//        videoTrack!.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        FileManager.sp_directory(createPath: kVideoTempDirectory)
        
        let exportUrl = URL(fileURLWithPath: "\(kVideoTempDirectory)/\(getVideoName())")
        
        let exportSession = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = exportUrl
        exportSession.exportAsynchronously(completionHandler: {
            completionHandler(exportUrl)
        })
    }
    /// 获取音\视频流数据
    ///
    /// - Parameter asset: 视频
    /// - Returns: 音\视频流数据
    class func sp_videoBuffer(asset : AVAsset?,isReadAudio : Bool = false,isVideoSample : Bool = false) ->SPVideoSampleBuffer{
        guard let videoAsset = asset else {
            return (nil,nil,nil)
        }
        let asserReader = try! AVAssetReader(asset: videoAsset)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first
        let audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
        if videoTrack == nil {
            return (nil, nil,nil)
        }
        let outputSettings :[String:Any] =  [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        let trackOutput = AVAssetReaderTrackOutput(track: videoTrack!, outputSettings: outputSettings)
         asserReader.add(trackOutput)
        var audioOutput : AVAssetReaderTrackOutput?
        if let audio = audioTrack {
            audioOutput = AVAssetReaderTrackOutput(track: audio, outputSettings: nil)
            if asserReader.canAdd(audioOutput!){
                asserReader.add(audioOutput!)
            }
        }
        asserReader.startReading()
        var audioSamples : [CMSampleBuffer] = []
        if isReadAudio {
            if let audioTrackOutput = audioOutput {
                while let audioSample = audioTrackOutput.copyNextSampleBuffer(){
                    audioSamples.append(audioSample)
                }
            }
        }

        var samples: [CMSampleBuffer] = []
        var videoTimeList = [CMTime]()
        while let sample = trackOutput.copyNextSampleBuffer() {
            autoreleasepool {
                if isVideoSample {
                    samples.append(sample)
                }
                videoTimeList.append(CMSampleBufferGetPresentationTimeStamp(sample))
            }
        }
        sp_log(message: "读取结束")
        asserReader.cancelReading()
        return (samples,audioSamples,videoTimeList)
    }
    private class func sp_dealVideoUnpend(asset:AVAsset?,url : String,complete : SPExportSuccess? = nil){
        guard let block = complete else {
            return
        }
        sp_mainQueue {
            block(asset,url)
        }
       
    }
    /// 视频倒放
    ///
    /// - Parameter asset: 视频
    /// - Returns: 处理倒放后的视频
    class func sp_videoUnpend(asset : AVAsset?,complete : SPExportSuccess? = nil){
        guard let videoAsset = asset else {
            sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
            return
        }
        sp_sync {
            let data = sp_videoBuffer(asset: videoAsset)
             let timeList = data.timeList
            if sp_count(array:  timeList) > 0 {
                let  filePath : String = "\(kVideoTempDirectory)/temp.mp4"
                FileManager.sp_directory(createPath:kVideoTempDirectory)
                if FileManager.default.fileExists(atPath: filePath) {
                    FileManager.remove(path: filePath)
                    
                }
                let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first
                if let size = videoTrack?.naturalSize {
                   
                    
                    let assetWriter = try! AVAssetWriter(outputURL: URL(fileURLWithPath: filePath), fileType: AVFileType.mp4)
                    let videoOutputSettings : [String : Any]
                    
                    if #available(iOS 11.0, *) {
                        videoOutputSettings = [AVVideoCodecKey : AVVideoCodecHEVC,
                                               AVVideoWidthKey : size.width,
                                               AVVideoHeightKey : size.height,
                                               AVVideoCompressionPropertiesKey : [AVVideoAverageBitRateKey : videoTrack!.estimatedDataRate]
                        ]
                    } else {
                        // Fallback on earlier versions
                        videoOutputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                               AVVideoWidthKey : size.width,
                                               AVVideoHeightKey : size.height,
                        ]
                    }
                    let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings, sourceFormatHint: (videoTrack?.formatDescriptions.last as! CMFormatDescription))
                    videoWriterInput.expectsMediaDataInRealTime = false
                    let sourcePixelBufferAttributesDictionary = [
                        String(kCVPixelBufferPixelFormatTypeKey) : kCVPixelFormatType_32BGRA,
                        String(kCVPixelBufferWidthKey) : size.width,
                        String(kCVPixelBufferHeightKey) : size.height ,
                        String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                        ] as [String : Any]
                    
                    let videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
                    if assetWriter.canAdd(videoWriterInput){
                        assetWriter.add(videoWriterInput)
                    }

                    assetWriter.startWriting()
                    assetWriter.startSession(atSourceTime: CMTime.zero)
                    sp_log(message: "开始转换 倒放")
                    for i in 0..<sp_count(array:  timeList){
                        autoreleasepool(invoking: {
                            if let time = timeList?[i],let lastTime = timeList?[sp_count(array: timeList) - i - 1]{
                                if   let img =  sp_thumbnailImage(assesst: videoAsset, time: lastTime) {
                                    if let ciImg = img.cgImage {
                                        if let imageBuffer = UIImage.sp_pixelBuffer(fromImage: ciImg, pixelBufferPool: nil, pixelFormatType: kCVPixelFormatType_32BGRA, pixelSize: size) {
                                            while !videoWriterInput.isReadyForMoreMediaData{
                                                Thread.sleep(forTimeInterval: 0.1)
                                            }
                                            videoWriterPixelbufferInput.append(imageBuffer, withPresentationTime: time)
                                        }
                                    }
                                }
                            }
                        })
                    }
            
                    sp_log(message: "结束转换 倒放")
                    videoWriterInput.markAsFinished()
                    assetWriter.finishWriting {
                        let newAssert = AVAsset(url: URL(fileURLWithPath: filePath))
                        sp_log(message: "视频倒放转换成功 \(newAssert)")
                        sp_dealVideoUnpend(asset: newAssert, url: filePath, complete: complete)
                    }
                }else{
                    sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
                }
            }else{
                sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
            }
        }
    }
}
