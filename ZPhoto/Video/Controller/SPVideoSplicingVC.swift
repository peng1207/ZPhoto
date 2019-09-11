//
//  SPVideoSplicingVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/6.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
import AVFoundation
/// 视频拼接
class SPVideoSplicingVC: SPBaseVC {
    var selectArray : [SPVideoModel]?
   
    fileprivate lazy var toolView : SPPhotoToolView = {
        let view = SPPhotoToolView()
        view.canShowSelect = false
        view.dataArray = [
//            SPToolModel.sp_init(type: .layout),
            SPToolModel.sp_init(type: .edit)
        ]
        view.selectBlock = { [weak self] (type) in
            self?.sp_deal(toolType: type)
        }
        return view
    }()
    fileprivate lazy var videoPlayView : SPVideoPlayView = {
        let view = SPVideoPlayView()
        return view
    }()
    fileprivate lazy var rightItemView : SPNavItemBtnView = {
        let view = SPNavItemBtnView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
      
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        return view
    }()
    fileprivate var videoModel : SPVideoModel?
    fileprivate var type : SPVideoSplicingType = .nine
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_asyncAfter(time: 0.1) {
            self.sp_setupSplicing()
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
         self.videoPlayView.stopTime()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.videoPlayView)
        self.view.addSubview(self.toolView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightItemView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.videoPlayView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(70)
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
extension SPVideoSplicingVC {
    
    /// 获取拼接的数据
    fileprivate func sp_setupSplicing(){
        SPVideoSplicingHelp.sp_splicing(videoModelList: self.selectArray, type: self.type, outputPath: "\(kVideoTempDirectory)/temp.mp4") { [weak self](asset, filePath) in
            self?.sp_deal(splicingComplete: asset, filePath: filePath)
        }
    }
    /// 处理拼接后的数据
    ///
    /// - Parameters:
    ///   - asset: 视频数据
    ///   - filePath: 保存路径
    fileprivate func sp_deal(splicingComplete asset :AVAsset? ,filePath : String){
        if asset != nil {
            self.videoModel = SPVideoModel()
            self.videoModel?.url = URL(fileURLWithPath: filePath)
            if self.videoModel?.asset == nil {
                self.videoModel?.asset = asset
            }
            sp_setupData()
        }
    }
    
    fileprivate func sp_deal(toolType : SPToolType){
        switch toolType {
        case .layout:
            sp_dealLayout()
        case .edit:
            sp_dealEdit()
        default:
            sp_log(message: "")
        }
    }
    fileprivate func sp_dealLayout(){
        
    }
    fileprivate func sp_dealEdit(){
        let dragVC = SPDragVC()
        dragVC.dataArray = self.selectArray
        dragVC.complete = { [weak self] (array) in
            if let list : [SPVideoModel] = array as? [SPVideoModel]{
                self?.selectArray = list
                self?.sp_setupSplicing()
            }
        }
        self.navigationController?.pushViewController(dragVC, animated: true)
    }
    fileprivate func sp_setupData(){
        sp_mainQueue {
            self.videoPlayView.videoModel = self.videoModel
        }
    }
    fileprivate func sp_deal(btnType : SPButtonClickType){
        switch btnType {
        case .save:
            sp_save()
        case .share:
            sp_share()
        default:
            sp_log(message: "")
        }
    }
    fileprivate func sp_save(){
        if let path = self.videoModel?.url?.path {
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path){
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(sp_video(path:error:contextInfo:)), nil)
            }
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
    fileprivate func sp_share(){
        if let url = self.videoModel?.url {
            SPShare.sp_share(videoUrls: [url], vc: self)
        }
    }
    
}
