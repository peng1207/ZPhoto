//
//  SPFilmVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/2.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
import AVFoundation
/// 影片
class SPFilmVC: SPBaseVC {
     var dataArray : [SPPhotoModel]?
    fileprivate lazy var videoPlayView : SPVideoPlayView = {
        let playView = SPVideoPlayView()
        playView.isHidden = true
        return playView
    }()
    fileprivate lazy var filmStruct : SPFilmStruct = {
        return SPFilmStruct(picDuration: 1.0, animationType: .none, background: nil)
    }()
    fileprivate lazy var toolView : SPPhotoToolView = {
        let view = SPPhotoToolView()
        view.canShowSelect = false
        view.backgroundColor = sp_getMianColor()
        view.dataArray = [SPToolModel.sp_init(type: .animation),SPToolModel.sp_init(type: .time),SPToolModel.sp_init(type: .zoom),SPToolModel.sp_init(type: .edit)]
        view.selectBlock = { [weak self] (type) in
            self?.sp_deal(toolType: type)
        }
        return view
    }()
    fileprivate lazy var timeView : SPFilmTimeView = {
        let view = SPFilmTimeView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.valueBlock = { [weak self] (picTime, animationTime)in
            self?.sp_deal(picTime: picTime, animationTime: animationTime)
        }
        return view
    }()
    fileprivate lazy var rightItemView : SPNavItemBtnView = {
        let view = SPNavItemBtnView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        view.isHidden = true
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_asyncAfter(time: 0.1) {
            self.sp_setupFilm()
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
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "FILM")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightItemView)
        self.view.addSubview(self.videoPlayView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.timeView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
            
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.videoPlayView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.view).offset(0)
            maker.height.equalTo(self.videoPlayView.snp.width).multipliedBy(1)
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
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.toolView).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        self.timeView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.toolView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        sp_log(message: "销毁")
    }
}
extension SPFilmVC {
    @objc fileprivate func sp_clickShare(){
        if let videoModel = self.videoPlayView.videoModel,let videoUrl = videoModel.url{
            SPShare.sp_share(videoUrls: [videoUrl], vc: self)
        }
    }
    
    @objc fileprivate func sp_clickSave(){
        if let videoModel = self.videoPlayView.videoModel {
            let path = sp_getString(string: videoModel.url?.path)
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
    fileprivate func sp_setupFilm(play : Bool = false){
        guard sp_count(array: self.dataArray) > 0 else {
            self.navigationController?.popViewController(animated: true)
            return 
        }
        
        guard let list = self.dataArray else {
            return
        }
        
        
        var imgList = [UIImage]()
        for model in list {
            if let img = model.img{
                imgList.append(img)
            }
        }
        guard imgList.count > 0 else {
            return
        }
        let  filePath : String = "\(kVideoTempDirectory)/temp.mp4"
        FileManager.sp_directory(createPath:kVideoTempDirectory)
        if FileManager.default.fileExists(atPath: filePath) {
            FileManager.remove(path: filePath)
        }
        SPFilmManager.sp_video(images: imgList, filePath: filePath, filmStruct:self.filmStruct) { [weak self](isSuccess, path) in
            self?.sp_deal(filmComplete: isSuccess, filePath: path,play: play)
        }
    }
    fileprivate func sp_deal(filmComplete isSucces : Bool , filePath : String?,play : Bool = false){
        if isSucces {
            let videoModel = SPVideoModel()
            videoModel.url = URL(fileURLWithPath: sp_getString(string: filePath))
            sp_mainQueue {
                self.rightItemView.isHidden = false
                self.videoPlayView.isHidden = false
                self.videoPlayView.videoModel = videoModel
                if play{
                    self.videoPlayView.playAction()
                }
            }
        }else{
            sp_mainQueue {
                self.videoPlayView.isHidden = true
                self.videoPlayView.videoModel = nil
            }
        }
    }
    fileprivate func sp_deal(toolType : SPToolType){
        switch toolType {
        case .animation:
            sp_dealAnimation()
        case .time:
            sp_dealTime()
        case .zoom:
            sp_dealZoom()
        case .edit:
            sp_dealEdit()
        default:
            sp_log(message: "")
        }
    }
    fileprivate func sp_dealAnimation(){
        let actionSheetVC = UIAlertController(title: SPLanguageChange.sp_getString(key: "ANIMATION"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_NONE"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_deal(animationType: .none, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_FADEOUT"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_deal(animationType: .fadeOut, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_PUSH"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_deal(animationType: .push, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_COVER"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_deal(animationType: .cover, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_TOBOOK"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_deal(animationType: .toBook, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "ANIMATION_HOLE"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_deal(animationType: .hole, animationTypes: nil)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(actionSheetVC, animated: true, completion: nil)
    }
    fileprivate func sp_dealTime(){
        self.timeView.sp_update(picTime: self.filmStruct.picDuration, animationTimer: self.filmStruct.animationDuratione)
        self.timeView.isHidden = !self.timeView.isHidden
    }
    fileprivate func sp_dealZoom(){
        let actionSheetVC = UIAlertController(title: SPLanguageChange.sp_getString(key: "ZOOM"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheetVC.addAction(UIAlertAction(title: "1:1", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(film: 1.0)
            self?.sp_update(ratio: 1.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "2:1", style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_update(film: 2.0)
            self?.sp_update(ratio: 0.5)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "16:9", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(film: 16.0 / 9.0)
            self?.sp_update(ratio: 9.0 / 16.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "4:5", style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_update(film: 4.0 / 5.0)
            self?.sp_update(ratio: 5.0 / 4.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "4:3", style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_update(film: 4.0 / 3.0)
            self?.sp_update(ratio: 3.0 / 4.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "7:5", style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_update(film: 7.0 / 5.0)
            self?.sp_update(ratio: 5.0 / 7.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "3:2", style: UIAlertAction.Style.default, handler: { [weak self](action) in
             self?.sp_update(film: 3.0 / 2.0)
            self?.sp_update(ratio: 2.0 / 3.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(actionSheetVC, animated: true, completion: nil)
    }
    fileprivate func sp_update(film ration : CGFloat){
        self.filmStruct.ratio = ration
        sp_setupFilm(play: true)
    }
    fileprivate func sp_update(ratio : CGFloat){
        self.videoPlayView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.view).offset(0)
            maker.height.equalTo(self.videoPlayView.snp.width).multipliedBy(ratio)
        }
    }
    fileprivate func sp_deal(picTime : TimeInterval,animationTime : TimeInterval){
        self.filmStruct.picDuration = picTime
        self.filmStruct.animationDuratione = animationTime
       sp_setupFilm(play: true)
    }
    fileprivate func sp_deal(animationType : SPAnimationType, animationTypes : [SPAnimationType]?){
        self.filmStruct.animationType = animationType
        self.filmStruct.animationTypes = animationTypes
        sp_setupFilm(play: true)
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
    fileprivate func sp_dealEdit(){
        let dragVC = SPDragVC()
        dragVC.dataArray = self.dataArray
        dragVC.complete = { [weak self] (array )in
            self?.dataArray = array as? [SPPhotoModel]
            self?.sp_setupFilm()
        }
        self.navigationController?.pushViewController(dragVC, animated: true)
    }
}

