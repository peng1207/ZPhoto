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
                 thumbnailImage = SPVideoHelp.thumbnailImageTo(assesst: asset!, time: CMTimeMakeWithSeconds(0.00, framesPerSecond))
                if thumbnailImage == nil {
                    thumbnailImage = UIImage(named: "default")
                }
                
            }

        }
    }
    var thumbnailImage : UIImage?
    
    override init() {
       url = nil
        asset = nil
    }
    
}
