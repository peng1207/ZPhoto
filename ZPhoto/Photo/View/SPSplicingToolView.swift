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

class SPSplicingToolView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPSplicingToolCollectionCellID"
    fileprivate var dataArray : [SPSplicingToolModel] = [SPSplicingToolModel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.dataArray.append(SPSplicingToolModel.sp_init(type: .layout))
        self.dataArray.append( SPSplicingToolModel.sp_init(type: .background))
        self.collectionView.reloadData()
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
        self.collectionView.backgroundColor = sp_getMianColor()
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPSplicingToolCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
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
extension SPSplicingToolView : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPSplicingToolCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPSplicingToolCollectionCell
        if indexPath.row < sp_count(array:  self.dataArray) {
            cell.model = self.dataArray[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.size.height - 5
        return CGSize(width: height - 20, height: height)
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
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        return label
    }()
    var model : SPSplicingToolModel? {
        didSet{
            self.sp_setupData()
        }
    }
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
        self.iconImgView.image = self.model?.img
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
