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

typealias ExportSuccess = ()-> Void
let kVideoChangeNotification : String = "VideoChangeNotification"

class SPVideoHelp: NSObject {
    // 保存视频的位置目录
    static let kVideoDirectory = "\(kDocumentsPath)/video"
    // 保存视频的临时位置目录
    static let kVideoTempDirectory = "\(kTmpPath)/video"
    
    // 获取视频的名称
     class func getVideoName() -> String {
        let date = NSDate()
        return "video_\(Int(date.timeIntervalSince1970)).mp4"
    }
    
    // 合并视频片段
    class func mergeVideos(videoAsset : [AVAsset],outputPath:String,exportSuuccess:@escaping ExportSuccess) {
        let compostition = AVMutableComposition()
        //合并视频、音频轨道 
        let firstTrack = compostition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let audioTrack = compostition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime : CMTime = kCMTimeZero
        var duration = 0.0
        for asset  in videoAsset {
            do {
                try firstTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: asset.tracks(withMediaType: AVMediaTypeVideo)[0], at: insertTime)
            } catch _ {
            
            }
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: asset.tracks(withMediaType: AVMediaTypeAudio)[0], at: insertTime)
            } catch _ {
                
            }
            duration += asset.duration.seconds
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        // 旋转视图图像，防止90度颠倒
        firstTrack.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: compostition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            exportSuuccess()
        })
    }
    /**< 对录制好的视频处理  */
    class func recordForDeal(asset:AVAsset,outputPath:String,complete : @escaping ExportSuccess)-> Void{
        let componsition = AVMutableComposition()
        let videoTrack = componsition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
       
        let videoAsset = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        let videoDuration = videoAsset.timeRange.duration

        let videoStart = videoAsset.timeRange.start
        if asset.tracks(withMediaType: AVMediaTypeAudio).count > 0 {
             let audioTrack = componsition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
            let audioAsset = asset.tracks(withMediaType: AVMediaTypeAudio)[0]
            var audioDuration = audioAsset.timeRange.duration
            var audioStart = audioAsset.timeRange.start
            if CMTimeGetSeconds(videoAsset.timeRange.duration) < CMTimeGetSeconds(audioAsset.timeRange.duration) {
                audioDuration = videoDuration
                audioStart = videoStart
            }
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(audioStart, audioDuration), of: audioAsset, at: kCMTimeZero)
            } catch _{
                
            }
        }
        
        do {
            try videoTrack.insertTimeRange(CMTimeRangeMake(videoStart, videoDuration), of: videoAsset, at: kCMTimeZero)
        }catch _{
            
        }
    
        videoTrack.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        let videoPath = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: componsition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously(completionHandler: {
            complete()
        })
        
    }
    /**< 根据assesst和time 获取对应的图片 */
    class func thumbnailImageTo(assesst: AVAsset,time : CMTime) -> UIImage?{
        var thumbnailImage : UIImage? = nil
        let assetImageGenerator = AVAssetImageGenerator(asset: assesst)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels
        do {
        
            let thumbnailImageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnailImage = UIImage(cgImage: thumbnailImageRef)
              return thumbnailImage
        } catch {
            SPLog("thumbnailImageTo error is \(error)")
            return nil
        }
    }
    /**< 获取视频文件 转为 */
    class func videoFile() -> [SPVideoModel]? {
        var videoArray = Array<SPVideoModel>()
        let fileArray = self.getfile(forDirectory: kVideoDirectory)
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
        var model = SPVideoModel();
        model.url = URL(fileURLWithPath: path)
        return model
    }
    
    /**< 根据目录获取该目录下所有的文件 并排序*/
    class func getfile(forDirectory:String) -> [String]?{
        FileManager.directory(createPath: forDirectory)
        let fileArray = try! FileManager.default.contentsOfDirectory(atPath: forDirectory)
        let fileSorted = fileArray.sorted { (file1 : String, file2 : String) -> Bool in
            if file1.compare(file2) == ComparisonResult.orderedAscending {
                return false
            }
            return  true
        }
        return fileSorted
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
            let thumbnailImage = self.thumbnailImageTo(assesst: asset!, time: CMTimeMakeWithSeconds(startSecond, 60))
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
        let videoTrack = compostion.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let audioTrack = compostion.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        do {
             try videoTrack.insertTimeRange(timeRange, of: asset.tracks(withMediaType: AVMediaTypeVideo)[0], at: kCMTimeZero)
        }catch _ {
            
        }
        do {
            try audioTrack.insertTimeRange(timeRange, of: asset.tracks(withMediaType: AVMediaTypeAudio)[0], at: kCMTimeZero)
        }catch _ {
            
        }
        videoTrack.preferredTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        FileManager.directory(createPath: kVideoTempDirectory)
        
       let exportUrl = URL(fileURLWithPath: "\(kVideoTempDirectory)/\(getVideoName())")
        
        let exportSession = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = exportUrl
        exportSession.exportAsynchronously(completionHandler: {
            completionHandler(exportUrl)
        })
    }
}
