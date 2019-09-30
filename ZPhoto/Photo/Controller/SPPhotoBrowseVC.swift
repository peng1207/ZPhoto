//
//  SPPhotoBrowse.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 浏览图片的控制器
class SPPhotoBrowseVC: SPBaseVC {
     fileprivate var collectionView : UICollectionView!
    var dataArray : [SPPhotoModel]?
    fileprivate let cellID = "SPPhotoBrowseCellID"
    var selectModel : SPPhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_addNotification()
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
    /// 赋值
    fileprivate func sp_setupData(){
        if let model = selectModel ,sp_count(array:  self.dataArray) > 0  {
            if let isExist = self.dataArray?.contains(model) ,isExist {
                    var index = 0
                for m in self.dataArray!{
                    if m == model {
                        break
                    }
                    index = index + 1
                }
                if index < sp_count(array:  self.dataArray) {
                    sp_asyncAfter(time: 0.1) {
                         self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
                    }
                }
            }
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(SPPhotoListCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "SAVE"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_clickSave)),
            UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "EDIT"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_clickEdit))
        ]
 
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
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
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPPhotoBrowseVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPPhotoListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPPhotoListCollectionCell
        cell.needUpdateLayout = true
        if indexPath.row < sp_count(array:  self.dataArray) {
            cell.model = self.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataArray) {
//            let model = self.dataArray?[indexPath.row]
//            let vc = SPPhotoEditVC()
//            vc.photoModel = model
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension SPPhotoBrowseVC {
    
    @objc fileprivate func sp_clickEdit(){
        
        let index = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        if index < sp_count(array:  self.dataArray) {
            let model = self.dataArray?[index]
            let vc = SPPhotoEditVC()
            vc.photoModel = model
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    @objc fileprivate func sp_clickSave(){
        let index = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        if index < sp_count(array:  self.dataArray) {
            let model = self.dataArray?[index]
            if let img = model?.img{
                  UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
       {
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

extension SPPhotoBrowseVC {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_imgNotification), name: NSNotification.Name(K_NEWIMAGE_NOTIFICATION), object: nil)
    }
    /// 图片变化通知
    @objc fileprivate func sp_imgNotification(){
        sp_sync {
            self.dataArray = SPPhotoHelp.sp_getPhototList()
            sp_mainQueue {
                self.collectionView.reloadData()
            }
        }
    }
    
}
