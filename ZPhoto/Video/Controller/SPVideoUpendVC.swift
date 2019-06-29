//
//  SPVideoUpendVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/28.
//  Copyright © 2019 huangshupeng. All rights reserved.
//  视频倒放

import Foundation
import SnapKit
import AVFoundation
import Photos

class SPVideoUpendVC: SPBaseVC {
    
    var videoModel : SPVideoModel?
    lazy var videoPlayView : SPVideoPlayView = {
        let playView = SPVideoPlayView()
        playView.isHidden = true
        return playView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.videoPlayView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.videoPlayView.snp.makeConstraints({ (maker) in
            maker.left.right.top.bottom.equalTo(self.view).offset(0)
        })
    }
    deinit {
       videoPlayView.stopTime()
    }
}
extension SPVideoUpendVC {
    
    fileprivate func sp_setupData(){
        SPVideoHelp.sp_videoUnpend(asset: self.videoModel?.asset) { [weak self](asset, url) in
                self?.sp_dealSuccess(asset: asset, url: url)
        }
    }
    fileprivate func sp_dealSuccess(asset : AVAsset?,url : String){
        if let newAsset = asset {
            let model = SPVideoModel()
            model.asset = newAsset
            self.videoPlayView.isHidden = false
            self.videoPlayView.videoModel = model
        }else{
            self.videoPlayView.isHidden = true
        }
    }
    
}
