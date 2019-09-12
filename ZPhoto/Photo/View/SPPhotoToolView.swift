//
//  SPSplicingToolView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/4/10.
//  Copyright © 2019 huangshupeng. All rights reserved.
//
// 拼接工具栏

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
typealias SPPhotoToolComplete = (_ type : SPToolType)->Void
class SPPhotoToolView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPToolCollectionCellID"
    var selectType : SPToolType?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var dataArray : [SPToolModel]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectBlock : SPPhotoToolComplete?
    /// 是否平分 按数组的进行平分
    var isAverage : Bool = false
    /// 是否展示选中的图片
    var canShowSelect : Bool = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
        self.collectionView.register(SPSplicingToolCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPhotoToolView : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPSplicingToolCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPSplicingToolCollectionCell
        if indexPath.row < sp_count(array:  self.dataArray) {
            if let model = self.dataArray?[indexPath.row] {
                if canShowSelect == true, let select = self.selectType , select == model.type {
                    cell.isSelect = true
                }else{
                    cell.isSelect = false
                }
                cell.model = model
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isAverage {
            let height = self.frame.size.height - 5
            let width = (self.frame.size.width - 20 - CGFloat((sp_count(array: self.dataArray) - 1)) * 5.0 ) / CGFloat(sp_count(array: self.dataArray))
            return CGSize(width: width, height: height)
        }else{
            let height = self.frame.size.height - 5
            return CGSize(width: height - 20, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray){
            if let model = self.dataArray?[indexPath.row] {
                if let select = self.selectType , select == model.type {
                    self.selectType = nil
                }else{
                    self.selectType = model.type
                }
                sp_dealSelect(type: model.type)
              
            }
        }
    }
    fileprivate func sp_dealSelect(type : SPToolType){
        guard let block = self.selectBlock else {
            return
        }
        block(type)
    }
}

class SPSplicingToolCollectionCell: UICollectionViewCell {
    
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font =  sp_fontSize(fontSize:  12)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var model : SPToolModel? {
        didSet{
            self.sp_setupData()
        }
    }
    var isSelect : Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: self.model?.title)
        if let selectImg = self.model?.selectImg , self.isSelect == true{
             self.iconImgView.image = selectImg
        }else{
             self.iconImgView.image = self.model?.img
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.titleLabel.snp.top).offset(-5)
            maker.width.equalTo(self.iconImgView.snp.height).offset(0)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView).offset(-5)
        }
    }
    deinit {
        
    }
}
