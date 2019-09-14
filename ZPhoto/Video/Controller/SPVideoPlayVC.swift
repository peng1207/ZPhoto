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
import SPCommonLibrary

class SPVideoPlayVC : SPBaseVC {
    var videoModel : SPVideoModel?
    
    fileprivate lazy var videoPlayView : SPVideoPlayView = {
        let playView = SPVideoPlayView()
        return playView
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        button.frame = CGRect(x: 10, y: sp_statusBarHeight(), width: 30, height: 30)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sp_close), for: UIControl.Event.touchUpInside)
        return button
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_share), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         sp_setupUI()
        sp_setupData()
    }
    fileprivate func sp_setupData(){
        self.videoPlayView.videoModel = self.videoModel
    }
    override func sp_setupUI() {
        
        self.view.addSubview(self.videoPlayView)
        self.view.addSubview(self.closeBtn)
        self.view.addSubview(self.shareBtn)
        sp_addConstraint()
    }
    fileprivate func sp_addConstraint(){
        self.videoPlayView.snp.makeConstraints({ (maker) in
            maker.left.right.top.bottom.equalTo(self.view).offset(0)
        })
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view).offset(sp_statusBarHeight() + 7)
            maker.width.height.equalTo(30)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view).offset(-10)
            maker.width.height.top.equalTo(self.closeBtn).offset(0)
        }
    }
    
    deinit {
        self.sp_removeAllView()
    }
     func sp_removeAllView(){
        videoPlayView.stopTime()
    }
}

// MARK: -- action
extension SPVideoPlayVC{
    @objc fileprivate func sp_close(){
        self.dismiss(animated: true) {
              self.sp_removeAllView()
        }
    }
    @objc fileprivate func sp_share(){
        if let url = self.videoModel?.url {
            SPShare.sp_share(videoUrls: [url], vc: self)
        }
    }
}
