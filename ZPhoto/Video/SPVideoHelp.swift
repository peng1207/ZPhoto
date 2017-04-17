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

class SPVideoHelp: NSObject {
    
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
    
}
