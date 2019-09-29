//
//  SPRecordVideoListVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/5/23.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import SPCommonLibrary
// MARK: -- 视频列表
  class SPVideoListVC : SPBaseVC {
    
    fileprivate lazy var videoCollectionView : UICollectionView = {
        let layout = SPVideoCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        let  collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControl.Event.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate let identify:String = "ViewCell"
    fileprivate var videoDataArray : Array<SPVideoModel>? = nil
    fileprivate lazy var noDataView : UILabel = {
        let label = UILabel()
        label.text = SPLanguageChange.sp_getString(key: "NO_VIDEO_TIP")
        label.numberOfLines = 0;
        label.font =  sp_fontSize(fontSize: 15)
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        self.setupUI()
        self.videoData()
        self.sendNotification()
    }
 
}
// MARK: -- UI
extension SPVideoListVC {
    
    fileprivate func setupUI(){
        self.setupCollectionView()
        self.setupNavUI()
    }
    /**< 创建collectionview */
    fileprivate func setupCollectionView(){
        self.view.addSubview(self.videoCollectionView)
        self.view.addSubview(self.noDataView);
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.register(SPVideoCollectionCell.self, forCellWithReuseIdentifier: identify)
        self.videoCollectionView.backgroundColor = UIColor.clear
        self.addConstraintToView()
    }
    /**< 创建导航栏上控件 */
    fileprivate func setupNavUI(){
 
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        addButton.addTarget(self, action: #selector(sp_add), for: .touchUpInside)
    
        addButton.setImage(UIImage(named: "add_white"), for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func addConstraintToView (){
        self.videoCollectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        self.noDataView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.right.equalTo(self.view).offset(-20);
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
    }
}
// MARK: -- action
extension SPVideoListVC {
  
    @objc fileprivate func sp_add(){
        let recordVC = SPRecordVideoVC()
        recordVC.modalPresentationStyle = .fullScreen
        self.present(recordVC, animated: true, completion: nil)
    }
    /**
     点击删除
     */
    fileprivate func sp_detete(videoModel:SPVideoModel?){
        guard let model = videoModel else {
            return
        }
        let alert = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "DELETE_VIDEO_MSG"), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "DELETE"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.videoDataArray?.remove(object: model)
            SPVideoHelp.remove(fileUrl: model.url!)
            self?.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func sp_clickShare(videoModel:SPVideoModel?){
        guard let model = videoModel else {
            return
        }
        if let url = model.url {
            SPShare.sp_share(videoUrls:  [url], vc: self)
        }
        
    }
    /*
     处理没有数据的
     */
    fileprivate func dealNoData(){
        if ((self.videoDataArray?.count)! > 0) {
            self.noDataView.isHidden = true
            self.videoCollectionView.isHidden = false
        }else{
            self.noDataView.isHidden = false
            self.videoCollectionView.isHidden = true
        }
    }
}

// MARK: -- delegate
extension SPVideoListVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.videoDataArray)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.videoDataArray) > 0  ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! SPVideoCollectionCell
        if indexPath.row < sp_count(array:  self.videoDataArray){
              cell.videoModel = self.videoDataArray?[indexPath.row]
        }
        cell.clickComplete = {
            [weak self]  (videoModel:SPVideoModel?) in
            self?.sp_detete(videoModel: videoModel)
        }
        cell.shareComplete = { [weak self] (videoModel:SPVideoModel?) in
            self?.sp_clickShare(videoModel: videoModel)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.videoDataArray) {
            let videoModel = self.videoDataArray?[indexPath.row]
            let videoPlayVC = SPVideoPlayVC()
            videoPlayVC.videoModel = videoModel
            videoPlayVC.modalPresentationStyle = .fullScreen
            self.present(videoPlayVC, animated: true, completion: nil)
        }
    }
}
// MARK: -- 数据
extension SPVideoListVC {
    /**< 获取视频数据  */
    @objc fileprivate func videoData(){
        sp_sync {
            let array = SPVideoHelp.sp_videoFile()
            sp_mainQueue {
                self.videoDataArray = array
                self.reloadData()
            }
        }
    }
    /*
     刷新数据
     */
    fileprivate func reloadData(){
        sp_mainQueue {
            self.videoCollectionView.reloadData()
            self.dealNoData()
        }
    }
    
}
// MARK: -- 通知
extension SPVideoListVC{
    /**< 发送通知 */
    func sendNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(videoData), name:NSNotification.Name(rawValue: kVideoChangeNotification), object: nil)
    }
}
