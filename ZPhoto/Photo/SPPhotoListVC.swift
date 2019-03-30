//
//  SPPhotoListVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
class SPPhotoListVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    fileprivate var dataArray : [SPPhotoModel]?
    fileprivate var selectArray : [SPPhotoModel] = [SPPhotoModel]()
    fileprivate let cellID = "SPPHOTOLISTCOLLECTCELLID"
    fileprivate var isEdit : Bool = false
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
    /// 赋值
    fileprivate func sp_setupData(){
        self.dataArray = SPPhotoHelp.sp_getPhototList()
        self.collectionView.reloadData()
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPPhotoListCollectionCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
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
        
    }
}
extension SPPhotoListVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPPhotoListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SPPhotoListCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.model = model
            var isSelect = false
            if let m = model, self.selectArray.contains(m){
                isSelect = true
            }
            cell.isSelect = isSelect;
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
              let model = self.dataArray?[indexPath.row]
            if let m = model {
                if isEdit {
                    if self.selectArray.contains(m) {
                        self.selectArray.remove(object: m)
                    }else{
                        self.selectArray.append(m)
                    }
                    self.collectionView.reloadData()
                }else{
                    let vc = SPPhotoBrowseVC()
                    vc.dataArray = self.dataArray
                    vc.selectModel = m
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger( (collectionView.frame.size.width - 3.0) / 4.0)
        return CGSize(width: width, height: width)
    }
}
extension SPPhotoListVC {
    
    /// 删除选择的
    ///
    /// - Parameter model: 选择的model
    open func sp_removeSelect(model : SPPhotoModel){
        self.selectArray.remove(object: model)
        self.collectionView.reloadData()
    }
    
}
