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
    
    static let kVideoDirectory = "\(kDocumentsPath)/video"
    
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
    /**< 根据assesst和time 获取对应的图片 */
    class func thumbnailImageTo(assesst: AVAsset,time : CMTime) -> UIImage?{
        let assetImageGenerator = AVAssetImageGenerator(asset: assesst)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels
        let thumbnailImageRef = try! assetImageGenerator.copyCGImage(at: time, actualTime: nil)
        let thumbnailImage = UIImage(cgImage: thumbnailImageRef)
        return thumbnailImage
    }
    /**< 获取视频文件 转为 */
    class func videoFile() -> [SPVideoModel]? {
        var videoArray = [SPVideoModel]()
        let fileArray = self.getfile(forDirectory: kVideoDirectory)
        for file in fileArray! {
            var model = SPVideoModel()
            model.url = URL(fileURLWithPath: "\(kVideoDirectory)/\(file)")
            videoArray.append(model)
        }
        return videoArray
    }
    
    /**< 根据目录获取该目录下所有的文件 并排序*/
    class func getfile(forDirectory:String) -> [String]?{
        let fileArray = try! FileManager.default.contentsOfDirectory(atPath: forDirectory)
         let fileSorted = fileArray.sorted { (file1 : String, file2 : String) -> Bool in
            if file1.compare(file2) == ComparisonResult.orderedAscending {
                return false
            }
             return  true
        }
        
       
        return fileSorted
    }
    /**< 发送通知 */
    class func sendNotification(notificationName:String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
}
