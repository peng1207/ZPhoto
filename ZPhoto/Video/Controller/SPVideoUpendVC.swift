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
    fileprivate lazy var rightItemView : SPNavItemBtnView = {
        let view = SPNavItemBtnView()
        view.isHidden = true
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_asyncAfter(time: 0.1) {
            self.sp_setupData()
        }
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightItemView)
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
            self.rightItemView.isHidden = false
            let model = SPVideoModel()
            model.url = URL(fileURLWithPath: url)
            self.videoPlayView.isHidden = false
            self.videoPlayView.videoModel = model
        }else{
            self.videoPlayView.isHidden = true
            self.rightItemView.isHidden = true
        }
    }
    fileprivate func sp_deal(btnType : SPButtonClickType){
        switch btnType {
        case .save:
            sp_clickSave()
        case .share:
            sp_clickShare()
        default:
            sp_log(message: "")
        }
    }
    fileprivate func sp_clickShare(){
        if let url = self.videoPlayView.videoModel?.url {
            SPShare.sp_share(videoUrls: [url], vc: self)
        }
    }
    
    @objc fileprivate func sp_clickSave(){
        let path = sp_getString(string: self.videoPlayView.videoModel?.url?.path)
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path){
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(sp_video(path:error:contextInfo:)), nil)
        }
    }
    @objc func sp_video(path : String?,error : NSError?,contextInfo : Any?){
        
        if let e = error as NSError?
        {
            print(e)
        }
        else
        {
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "SAVE_SUCCESS"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "OK"), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
