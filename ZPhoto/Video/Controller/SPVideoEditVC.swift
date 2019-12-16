//
//  SPVideoEditVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/12.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SPCommonLibrary

class  SPVideoEditVC : SPBaseVC {
    lazy fileprivate var scheduleView : SPVideoScheduleView = {
        let view = SPVideoScheduleView()
        return view
    }()
    fileprivate lazy var videoPlayerView : SPVideoPlayView  = {
        let view = SPVideoPlayView()
        view.buttonView.isHidden = true
        return view
    }()
    fileprivate lazy var playBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "VideoStop"), for: .normal)
        btn.setImage(UIImage(named: "VideoPlay"), for: .selected)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_play), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var videoModel : SPVideoModel?
    fileprivate var valueData : SPVideoSampleBuffer!
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
        sp_setupVideo()
        sp_setupData()
    }
    /// 添加UI
    override func sp_setupUI(){
        self.view.addSubview(self.videoPlayerView)
        self.view.addSubview(self.scheduleView)
        self.videoPlayerView.addSubview(self.playBtn)
        self.sp_addConstraint()
    }
    fileprivate func sp_addConstraint(){
        self.videoPlayerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.scheduleView.snp.top).offset(0)
        }
        self.playBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(40)
            maker.centerX.equalTo(self.videoPlayerView).offset(0)
            maker.centerY.equalTo(self.videoPlayerView).offset(0)
        }
        self.scheduleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(50)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
// MARK: -- action
extension SPVideoEditVC {
    /// 播放视频
    /// - Parameter videoModel: 视频model
   fileprivate func  sp_playVideo(videoModel:SPVideoModel){
        let videoPalyVC = SPVideoPlayVC()
        videoPalyVC.videoModel = videoModel
        self.navigationController?.pushViewController(videoPalyVC, animated: true)
    }
    fileprivate func sp_setupData(){
        sp_sync {
            self.valueData = SPVideoHelp.sp_videoBuffer(asset: self.videoModel?.asset )
            sp_mainQueue {
                sp_log(message: "开始刷新")
                self.scheduleView.videoAsset = self.videoModel?.asset
            }
        }
    }
    fileprivate func sp_setupVideo(){
        self.videoPlayerView.videoModel = self.videoModel
        self.playBtn.isHidden = false
    }
    @objc fileprivate func sp_play(){
        self.videoPlayerView.playAction()
        self.playBtn.isSelected = !self.playBtn.isSelected
    }
}
