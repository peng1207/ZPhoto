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
typealias ExportSuccess = (_ assert : AVAsset?,_ url : String)-> Void
let kVideoChangeNotification : String = "VideoChangeNotification"

class SPVideoHelp: NSObject {
  
    
    // 获取视频的名称
    class func getVideoName() -> String {
        let date = NSDate()
        return "video_\(Int(date.timeIntervalSince1970)).mp4"
    }
    
    // 合并视频片段
    class func mergeVideos(videoAsset : [AVAsset],outputPath:String,exportSuuccess:@escaping ExportSuccess) {
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
        // 旋转视图图像，防止90度颠倒
        firstTrack!.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: compostition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            exportSuuccess(AVAsset(url: URL(fileURLWithPath: outputPath)),outputPath)
        })
    }
    /**< 对录制好的视频处理  */
    class func recordForDeal(asset:AVAsset,outputPath:String,complete : @escaping ExportSuccess)-> Void{
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
        sp_log(message: videoTrack?.naturalSize)
        sp_log(message: componsition.naturalSize)
        videoTrack!.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
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
    class func sp_videoAsset(asset : AVAsset,audioAsset:AVAsset,outputPath : String,complete : @escaping ExportSuccess)->Void{
        let compostion = AVMutableComposition()
        let videoTrack = compostion.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        
        guard let videoAsset = asset.tracks(withMediaType: .video).first else {
            return
        }
 
        let videoDuration = videoAsset.timeRange.duration
        let videoStart = videoAsset.timeRange.start
      
        let audioCurrentTrack = asset.tracks(withMediaType: .audio).first
        let audioInputTrack = audioAsset.tracks(withMediaType: .audio).first
        
        if audioCurrentTrack != nil || audioInputTrack != nil {
             let audioTrack = compostion.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())
            if let inputTrack = audioCurrentTrack {
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
            if let inputTrack = audioInputTrack {
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
        }
        do {
            try videoTrack!.insertTimeRange(CMTimeRangeMake(start: videoStart, duration: videoDuration), of: videoAsset, at: CMTime.zero)
        }catch _{
            
        }
        videoTrack!.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            complete(AVAsset(url: URL(fileURLWithPath: outputPath)),outputPath)
        })
       
    }
    /**< 根据assesst和time 获取对应的图片 */
    class func thumbnailImageTo(assesst: AVAsset,time : CMTime) -> UIImage?{
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
    /**< 获取视频文件 转为 */
    class func videoFile() -> [SPVideoModel]? {
        var videoArray = [SPVideoModel]()
        let fileArray = sp_getfile(forDirectory: kVideoDirectory)
        for file in fileArray! {
            let path = "\(kVideoDirectory)/\(file)"
            let model = getVideoModel(path: path)
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
    class func getVideoModel(path:String) -> SPVideoModel{
        let model = SPVideoModel();
        model.url = URL(fileURLWithPath: path)
        return model
    }
    
    
    /**
     删除视频文件
     */
    class func remove(videoUrl:URL) -> Void{
        remove(fileUrl: videoUrl)
        sendNotification(notificationName: kVideoChangeNotification)
    }
    /**
     删除文件
     */
    class func remove(fileUrl:URL) -> Void{
        try!  FileManager.default.removeItem(at: fileUrl)
    }
    /**< 发送通知 */
    class func sendNotification(notificationName:String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    /**< 根据AVAsset 获取图片数组(默认为每一秒 若传入小于等于0 则为0.01)*/
    class func images(asset:AVAsset?,second:Float64 = 1.0) -> [UIImage]! {
        var secondDurr = second
        if secondDurr <= 0 {
            secondDurr = 0.01
        }
        // 获取视频秒数
        let assetSecond = CMTimeGetSeconds(asset!.duration)
        // 开始秒数
        var startSecond = 0.00
        var imageArray = [UIImage]()
        while  startSecond <= assetSecond {
            let thumbnailImage = self.thumbnailImageTo(assesst: asset!, time: CMTimeMakeWithSeconds(startSecond, preferredTimescale: 60))
            if let image = thumbnailImage {
                imageArray.append(image)
            }
            if startSecond < assetSecond {
                startSecond = startSecond + secondDurr
                if startSecond > assetSecond {
                    startSecond = assetSecond
                }
            }else{
                startSecond = startSecond + secondDurr
            }
            
        }
        return imageArray
    }
    /**< 剪切视频 timeRange 剪切的位置  */
    class func shear(asset:AVAsset,timeRange: CMTimeRange,completionHandler:@escaping (_ outUrl:URL)->Void) ->  Void{
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
        videoTrack!.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
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
    class func sp_getVideoBuffer(asset : AVAsset?) ->(videoBuffers : [CMSampleBuffer]?,audioBuffers : [CMSampleBuffer]?){
        guard let videoAsset = asset else {
            return (nil,nil)
        }
        let asserReader = try! AVAssetReader(asset: videoAsset)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first
        let audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
        if videoTrack == nil {
            return (nil, nil)
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
        if let audioTrackOutput = audioOutput {
            while let audioSample = audioTrackOutput.copyNextSampleBuffer(){
                sp_log(message: "读取音频中")
                audioSamples.append(audioSample)
            }
        }
        
        var samples: [CMSampleBuffer] = []
        while let sample = trackOutput.copyNextSampleBuffer() {
            sp_log(message: "读取视频中")
            samples.append(sample)
//            CMSampleBufferInvalidate(sample)
        }
        sp_log(message: "读取结束")
        asserReader.cancelReading()
        return (samples,audioSamples)
    }
    private class func sp_dealVideoUnpend(asset:AVAsset?,url : String,complete : ExportSuccess? = nil){
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
    class func sp_videoUnpend(asset : AVAsset?,complete : ExportSuccess? = nil){
        guard let videoAsset = asset else {
            sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
            return
        }
        sp_sync {
            let data = sp_getVideoBuffer(asset: videoAsset)
            let samples = data.videoBuffers
//            let audioSamples = data.audioBuffers
            if sp_count(array:  samples) > 0 {
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
                    videoWriterInput.transform = videoTrack!.preferredTransform
                    let sourcePixelBufferAttributesDictionary = [
                        String(kCVPixelBufferPixelFormatTypeKey) : kCVPixelFormatType_32BGRA,
                        String(kCVPixelBufferWidthKey) : size.width,
                        String(kCVPixelBufferHeightKey) : size.height ,
                        String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                        ] as [String : Any]
                    
                    let videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
                    assetWriter.add(videoWriterInput)
 
                    assetWriter.startWriting()
                    
                    let startTime = CMSampleBufferGetPresentationTimeStamp(samples!.first!)
                    assetWriter.startSession(atSourceTime: startTime)
                    let group = DispatchGroup()
                
                    group.enter()
                    sp_log(message: "开始转换 倒放")
                    for i in 0..<sp_count(array:  samples){
                        if let samplesBuffer = samples?[i] {
                            let time = CMSampleBufferGetPresentationTimeStamp(samplesBuffer)
                            let dataBuffer = samples?[sp_count(array:  samples) - i - 1]
                            
                            if  let imageBufferRef = CMSampleBufferGetImageBuffer(dataBuffer!){
                                while !videoWriterInput.isReadyForMoreMediaData{
                                    Thread.sleep(forTimeInterval: 0.1)
                                }
                                videoWriterPixelbufferInput.append(imageBufferRef, withPresentationTime: time)
                            }
                        }
                    }
                    sp_log(message: "结束转换 倒放")
                    group.leave()
                    
                    group.notify(queue: .main, execute: {
                        videoWriterInput.markAsFinished()
                        assetWriter.finishWriting {
                            let newAssert = AVAsset(url: URL(fileURLWithPath: filePath))
                            sp_log(message: "视频倒放转换成功 \(newAssert)")
                            sp_dealVideoUnpend(asset: newAssert, url: filePath, complete: complete)
                        }
                    })
                   
                }else{
                    sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
                }
            }else{
                sp_dealVideoUnpend(asset: nil, url: "", complete: complete)
            }
        }
       
        
       
    }
}
