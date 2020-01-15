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
    
    fileprivate lazy var videoPlayerView : SPVideoPlayView  = {
        let view = SPVideoPlayView()
        view.buttonView.isHidden = true
        return view
    }()
    fileprivate lazy var timeView : SPTimeView = {
        let view = SPTimeView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.sp_cornerRadius(radius: 100)
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
    fileprivate var valueData : SPVideoSampleBuffer?
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
        sp_setupVideo()
        sp_setupData()
      
    }
    /// 添加UI
    override func sp_setupUI(){
        self.view.addSubview(self.videoPlayerView)
        self.videoPlayerView.addSubview(self.playBtn)
        self.view.addSubview(self.timeView)
        self.sp_addConstraint()
        
        let turntableView = SPTurntableView(frame: CGRect(x: 0, y: 0, width: sp_screenWidth(), height: sp_screenWidth()))
        turntableView.isHidden = false
        self.view.addSubview(turntableView)
        let list = [SPHexColor.color_00a1fe.rawValue, SPHexColor.color_333333.rawValue,SPHexColor.color_2a96fd.rawValue,SPHexColor.color_01b5da.rawValue,SPHexColor.color_189cdd.rawValue,SPHexColor.color_8e8e8e.rawValue]
        var colorList : [String] = [String]()
        for i in 0..<6 {
            colorList.append(list[i % 6])
        }
        turntableView.list = colorList
        sp_asyncAfter(time: 1) {
            turntableView.sp_start()
        }
    }
    fileprivate func sp_addConstraint(){
        self.videoPlayerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        self.playBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(40)
            maker.centerX.equalTo(self.videoPlayerView).offset(0)
            maker.centerY.equalTo(self.videoPlayerView).offset(0)
        }
        self.timeView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(200)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
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
        if let second = self.videoModel?.second {
            self.timeView.second = CGFloat(second)
        }
//        sp_sync {
//            self.valueData = SPVideoHelp.sp_videoBuffer(asset: self.videoModel?.asset )
//            sp_mainQueue {
//                sp_log(message: "开始刷新 \(sp_count(array: self.valueData?.timeList))")
//            }
//        }
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
