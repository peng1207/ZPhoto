//
//  SPVideoPlayVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/3.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class SPVideoPlayVC : UIViewController {
    var videoModel : SPVideoModel?
    
    lazy var videoPlayView : SPVideoPlayView? = {
        let playView = SPVideoPlayView()
        return playView
    }()
    
    
    lazy fileprivate var closeBtn : UIButton! = {
        let button = UIButton(type: .custom)
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.frame = CGRect(x: 10, y: 20, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
}
// MARK: -- UI
extension SPVideoPlayVC {
    /**< 创建UI */
    fileprivate func setupUI(){
        self.setupPlayer()
        self.setupCloseBtn()
    }
    /**< 创建视频播放器 */
   private func setupPlayer(){
    
        self.view.addSubview(self.videoPlayView!)
        self.videoPlayView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.bottom.equalTo(self.view).offset(0)
        })
        self.videoPlayView?.videoModel = videoModel
    
//        let playeritem = AVPlayerItem(asset: (videoModel?.asset)!)
//        videoPlayer = AVPlayer(playerItem: playeritem)
//        let playerLayer = AVPlayerLayer(player: videoPlayer)
//        playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
//        self.view.layer.addSublayer(playerLayer)
//        videoPlayer?.play()
    }
    private func setupCloseBtn(){
        self.view.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
}
// MARK: -- action
extension SPVideoPlayVC{
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
}
