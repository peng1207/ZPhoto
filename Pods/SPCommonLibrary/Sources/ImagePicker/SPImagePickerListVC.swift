//
//  SPImagePickerListVC.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/15.
//

import Foundation
import SnapKit
import UIKit
import Photos
/// 图片列表
class SPImagePickerListVC: UIViewController {
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "imagePickerListCellID"
    var selectArray : [PHAsset] = [PHAsset]()
    var maxSelectNum : Int = 1
    var selectComplete : SPImagePickerComplete?
    var albumItem : SPImageAlbumItem?
    fileprivate var itemSize : CGSize!
    fileprivate var fetchResult : PHFetchResult<PHAsset>!
    fileprivate let imageManager : PHCachingImageManager = PHCachingImageManager()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_dealTitle()
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
    fileprivate func sp_setupUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLibararyLanguage.sp_library(key: "sdk_done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_clickDone))
        guard let item = self.albumItem else {
            return
        }
        self.navigationItem.title = item.title
        self.fetchResult = item.fetchResult
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        let w = Int((self.view.frame.size.width - 6 - 9) / 4.0)
        layout.itemSize = CGSize(width: w, height: w)
        self.itemSize = CGSize(width: layout.itemSize.width * SP_DEVICE_SCALE, height:  layout.itemSize.height * SP_DEVICE_SCALE)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.register(SPImagePickerListCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    fileprivate func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        sp_log(message: "销毁")
    }
}
extension SPImagePickerListVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchResult.count > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPImagePickerListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPImagePickerListCollectionCell
        if indexPath.row < self.fetchResult.count {
            let asset = self.fetchResult[indexPath.row]
            self.imageManager.requestImage(for: asset, targetSize: self.itemSize, contentMode: .default, options: nil) { (image, hasable) in
                cell.iconImgView.image = image
            }
            if self.selectArray.contains(asset) {
                cell.selectImgView.isHidden = false
            }else{
                cell.selectImgView.isHidden = true
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.fetchResult.count{
            let asset = self.fetchResult[indexPath.row]
            sp_dealSelect(asset: asset)
        }
    }
}

extension SPImagePickerListVC {
    /// 点击完成
    @objc fileprivate func sp_clickDone(){
        var imageList = [UIImage]()
        let group = DispatchGroup()
        // 创建多列
        let workingQueue = DispatchQueue(label: "image_queue")
        var canLeave = true
        for asset in self.selectArray {
            group.enter()
            workingQueue.async {
                self.imageManager.requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .default, options: nil) { (image, hasable) in
                    if let i = image{
                        imageList.append(i)
                    }
                    if canLeave {
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue:workingQueue) {[weak self] in
            canLeave = false
            sp_mainQueue {
                self?.sp_dealComplete(images: imageList)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    /// 处理回调
    /// - Parameter images: 选择图片数据
    fileprivate func sp_dealComplete(images : [UIImage]?){
        guard let block = self.selectComplete else {
            return
        }
        block(images,self.selectArray)
    }
    /// 处理选择的图片
    /// - Parameter asset: 图片asset
    fileprivate func sp_dealSelect(asset : PHAsset){
        if self.maxSelectNum > 0 , sp_count(array: self.selectArray) == self.maxSelectNum , self.selectArray.contains(asset) == false{
             // 选择的图片的等于最大的数量
            let alertController = UIAlertController(title: SPLibararyLanguage.sp_library(key: "sdk_tips"), message: SPLibararyLanguage.sp_library(key: "sdk_max_num"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLibararyLanguage.sp_library(key: "sdk_cance"), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if self.selectArray.contains(asset) {
            self.selectArray.remove(object: asset)
        }else{
             self.selectArray.append(asset)
        }
        sp_dealTitle()
        self.collectionView.reloadData()
        if self.maxSelectNum == 1 {
            sp_clickDone()
        }
    }
    /// 处理标题
    fileprivate func sp_dealTitle(){
        if self.maxSelectNum > 0 {
              self.navigationItem.title = sp_getString(string: albumItem?.title) + "(\(sp_count(array: self.selectArray))/\(maxSelectNum))"
        }else
        {
            self.navigationItem.title = sp_getString(string: albumItem?.title)
        }
       
    }
}
