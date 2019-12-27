//
//  SPVideoModel.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/1.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import Photos
import SPCommonLibrary
class SPVideoModel : NSObject{
    var url : URL?{
        didSet{
            asset = AVAsset(url: url!)
        }
    }
    var asset : AVAsset? {
        didSet{
           self.sp_dealAsset()
        }
    }
    var thumbnailImage : UIImage?
    var second : Float64?
    var size : CGSize = CGSize.zero
    override init() {
       url = nil
        asset = nil
    }
    private func sp_dealAsset(){
        guard asset != nil else {
            return
        }
        
        let second = CMTimeGetSeconds(asset!.duration)
        if second <= 0 || asset == nil{
            asset = nil
        }else{
            thumbnailImage = SPVideoHelp.sp_thumbnailImage(assesst: asset!, time: CMTimeMakeWithSeconds(0.00, preferredTimescale: framesPerSecond))
            if let videoTrack =  asset?.tracks(withMediaType: .video).first{
                self.size = videoTrack.naturalSize
            }
//            sp_log(message: "video size is \(self.size)")
            self.second = second
            if thumbnailImage == nil {
                thumbnailImage = sp_appLaunchImg()
            }
        }
    }
    deinit {
        
    }
}
