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
    
    lazy var videoPlayView : SPVideoPlayView? = {
        let playView = SPVideoPlayView()
        return playView
    }()
    lazy fileprivate var closeBtn : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        
        
        button.frame = CGRect(x: 10, y: sp_statusBarHeight(), width: 30, height: 30)
       
        button.clipsToBounds = true 
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    deinit {
        self.removeAllView()
    }
    fileprivate func removeAllView(){
        videoPlayView?.stopTime()
         videoPlayView = nil
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
            maker.top.left.right.equalTo(self.view).offset(0)
              maker.bottom.equalTo(self.view).offset(0);
        })
        self.videoPlayView?.videoModel = videoModel
    }
    private func setupCloseBtn(){
        self.view.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
}
// MARK: -- action
extension SPVideoPlayVC{
    @objc func closeAction(){
        self.dismiss(animated: true) {
              self.removeAllView()
        }
    }
}
