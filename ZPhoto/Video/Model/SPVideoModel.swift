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
            let second = CMTimeGetSeconds(asset!.duration)
            if second <= 0 || asset == nil{
                asset = nil
            }else{
                thumbnailImage = SPVideoHelp.sp_thumbnailImage(assesst: asset!, time: CMTimeMakeWithSeconds(0.00, preferredTimescale: framesPerSecond))
                self.second = second
                if thumbnailImage == nil {
                    thumbnailImage = sp_appLaunchImg()
                }
            }
        }
    }
    var thumbnailImage : UIImage?
    var second : Float64?
    override init() {
       url = nil
        asset = nil
    }
    deinit {
        
    }
}
