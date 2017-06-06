//
//  SPVideoPlayView.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/4.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SPVideoPlayView : UIView{
    
    fileprivate var videoPlayer : AVPlayer?
    fileprivate var videoPlayerItem : AVPlayerItem?
    fileprivate var playButton : UIButton!
    fileprivate var timeLabel: UILabel!
    fileprivate var progress : UIProgressView!
    
    var videoModel : SPVideoModel? {
        didSet{
            videoPlayerItem = AVPlayerItem(asset: (videoModel?.asset)!)
            videoPlayer = AVPlayer(playerItem: videoPlayerItem)
            let layer = self.layer as! AVPlayerLayer
            layer.player = videoPlayer
             layer.videoGravity = AVLayerVideoGravityResize
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
}
// MARK: -- UI
fileprivate extension SPVideoPlayView {
    /**< 创建UI */
    fileprivate func setupUI(){
    
    }
}
