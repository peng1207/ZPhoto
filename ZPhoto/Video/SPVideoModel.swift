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

struct SPVideoModel {
    var url : URL?{
        didSet{
            asset = AVAsset(url: url!)
        }
    }
    var asset : AVAsset? {
        didSet{
            thumbnailImage = SPVideoHelp.thumbnailImageTo(assesst: asset!, time: CMTimeMakeWithSeconds(0.0, 60))
        }
    }
    var thumbnailImage : UIImage?
    
    init() {
       url = nil
        asset = nil
    }
    
}
