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

class  SPVideoEditVC : SPBaseVC {
    lazy fileprivate var scheduleView : SPVideoScheduleView = {
        let view = SPVideoScheduleView()
        return view
    }()
  
    lazy fileprivate var  showImage : UIImageView = {
        return UIImageView()
    }()
    
    var videoModel : SPVideoModel?
    fileprivate var valueData : SPVideoSampleBuffer!
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
        sp_setupData()
    }
    /// 添加UI
    override func sp_setupUI(){
        self.view.addSubview(self.showImage)
        self.view.addSubview(self.scheduleView)
        self.sp_addConstraint()
    }
    fileprivate func sp_addConstraint(){
        self.showImage.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.scheduleView.snp.top).offset(0)
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
    func  playVideo(videoModel:SPVideoModel){
        let videoPalyVC = SPVideoPlayVC()
        videoPalyVC.videoModel = videoModel
        self.navigationController?.pushViewController(videoPalyVC, animated: true)
    }
    fileprivate func sp_setupData(){
//        self.valueData = SPVideoHelp.sp_videoBuffer(asset: self.videoModel?.asset, isReadAudio: false)
    }
}
