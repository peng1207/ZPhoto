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
import SPCommonLibrary

class SPVideoUpendVC: SPBaseVC {
    
    var videoModel : SPVideoModel?
    fileprivate lazy var videoPlayView : SPVideoPlayView = {
        let playView = SPVideoPlayView()
        playView.isHidden = true
        return playView
    }()
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "SAVE"), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.isHidden = true
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        btn.addTarget(self, action: #selector(sp_clickSave), for: UIControl.Event.touchUpInside)
        return btn
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.saveBtn)
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
        if asset != nil {
            self.saveBtn.isHidden = false
            let model = SPVideoModel()
            model.url = URL(fileURLWithPath: url)
            self.videoPlayView.isHidden = false
            self.videoPlayView.videoModel = model
        }else{
            self.videoPlayView.isHidden = true
            self.saveBtn.isHidden = true
        }
    }
    @objc fileprivate func sp_clickSave(){
        let alertVC = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "SAVE_VIDEO_MSG"), preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "SAVE"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            let path = sp_getString(string: self?.videoPlayView.videoModel?.url?.path)
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path){
                UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
