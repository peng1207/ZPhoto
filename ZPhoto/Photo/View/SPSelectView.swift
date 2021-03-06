//
//  SPPhotoSplicingSelectView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/4/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

class SPSelectView:  UIView{
    
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_fontSize(fontSize:  15)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var clearBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "CLEARSELECT"), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize:  17)
        btn.addTarget(self, action: #selector(sp_clickClear), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var dataArray : [Any] = [Any]()
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPPhotoSplicingSelectCollectionCellID"
    var clearBlock : SPBtnComplete?
    var indexBlock : SPIndexComplete?
    var selectMaxCount : Int = 0{
        didSet{
            self.sp_dealNum()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = sp_getMianColor().withAlphaComponent(0.1)
        self.sp_setupUI()
         sp_dealNum()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.numLabel)
        self.addSubview(self.clearBtn)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = sp_getMianColor().withAlphaComponent(0.1)
//        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPPhotoSplicingSelectCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.addSubview(self.collectionView)
       
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(30)
        }
        self.clearBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.equalTo(30)
            maker.top.equalTo(self).offset(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.numLabel.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSelectView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPPhotoSplicingSelectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPPhotoSplicingSelectCollectionCell
        if indexPath.row < sp_count(array:  self.dataArray) {
            cell.model = self.dataArray[indexPath.row]
        }
        cell.indexPath = indexPath
        cell.indexBlock = { [weak self](index) in
            self?.sp_dealDelete(index: index)
        }
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigth = collectionView.frame.size.height - 10
        return CGSize(width: heigth, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataArray) {
            sp_dealDelete(index: indexPath.row)
        }
    }
}

extension SPSelectView {
    
    fileprivate func sp_dealDelete(index: Int){
        if let block = self.indexBlock {
            block(index)
        }
        sp_remove(index: index)
    }
    
    /// 点击清除所有
    @objc fileprivate func sp_clickClear(){
        if let block = self.clearBlock {
            block()
        }
        self.dataArray.removeAll()
        self.collectionView.reloadData()
        sp_dealNum()
       
    }
    /// 删除某个位置的元素
    ///
    /// - Parameter index: 位置
    fileprivate func sp_remove(index:Int){
        if index < sp_count(array: self.dataArray){
            self.dataArray.remove(at: index)
        }
        self.collectionView.reloadData()
        sp_dealNum()
    }
    
    /// 添加数据
    ///
    /// - Parameter model: 数据源
    func sp_add(model : Any){
        self.dataArray.append(model)
        self.collectionView.reloadData()
        sp_asyncAfter(time: 0.2) {
              self.collectionView.scrollToItem(at: IndexPath(item: self.dataArray.count - 1, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        }
      
        sp_dealNum()
    }
    /// 处理数据显示
    fileprivate func sp_dealNum(){
        if self.selectMaxCount > 0 {
             self.numLabel.text = "\(SPLanguageChange.sp_getString(key: "SELECTED"))\(sp_count(array:  self.dataArray))/\(sp_getString(string: self.selectMaxCount))"
        }else{
             self.numLabel.text = "\(SPLanguageChange.sp_getString(key: "SELECTED"))\(sp_count(array:  self.dataArray))"
        }
    }
    
}
fileprivate class SPPhotoSplicingSelectCollectionCell: UICollectionViewCell {
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var deleteBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_delete"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickDelete), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var model : Any? {
        didSet{
            self.sp_setupData()
        }
    }
    var indexPath : IndexPath!
    var indexBlock : SPIndexComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if  let m = self.model as? SPPhotoModel {
             self.iconImgView.image = m.img
        }else if let m = self.model as? SPVideoModel{
            self.iconImgView.image = m.thumbnailImage
        }else{
            self.iconImgView.image = nil
        }
       
    }
    @objc func sp_clickDelete(){
        guard let block = self.indexBlock else {
            return
        }
        block(indexPath.row)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.deleteBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.top.equalTo(self.contentView).offset(-10)
            maker.right.equalTo(self.contentView).offset(10)
        }
    
    }
    deinit {
        
    }
}
