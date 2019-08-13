//
//  SPLayerView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/21.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

typealias SPLayoutSelectComplete = (_ type :SPSPlicingType)->Void

class SPLayoutView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "layoutCellID"
    fileprivate var typeList : [SPSPlicingType]?
    fileprivate var totalCount : Int = 0
    var selectBlock : SPLayoutSelectComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_update(typeList : [SPSPlicingType]? , count : Int ){
        self.typeList = typeList
        self.totalCount = count
        self.collectionView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
//        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPLayoutCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
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
extension SPLayoutView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.typeList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.typeList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPLayoutCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPLayoutCollectionCell
        if indexPath.row < sp_count(array: self.typeList) {
            let type = self.typeList?[indexPath.row]
            cell.type = type
            cell.count = self.totalCount
            cell.sp_setupData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height - 10
        return CGSize(width: h, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.typeList) {
            if let type = self.typeList?[indexPath.row]{
                sp_dealSelect(type: type)
            }
        }
    }
    fileprivate func sp_dealSelect(type : SPSPlicingType){
        guard let block = self.selectBlock else {
            return
        }
        block(type)
    }
}

class SPLayoutCollectionCell: UICollectionViewCell {
    
    var type : SPSPlicingType?
    var count : Int = 0
    fileprivate let LayoutTag = 100
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        guard let selectType = self.type else {
            return
        }
        if self.count > 0 {
            for i in 0..<count{
                let value = SPPhotoSplicingHelp.sp_frameAndSpace(tyep: selectType, value: SPPhotoSplicingStruct(index: i, count: self.count, width: 50, height: 50, margin: 4, padding: 4))
                if  let view = self.contentView.viewWithTag(LayoutTag + i ){
                    
                    view.frame = CGRect(x: value.frame.origin.x + value.space.left, y: value.frame.origin.y + value.space.top, width: value.frame.size.width - value.space.left - value.space.right, height: value.frame.size.height - value.space.top - value.space.bottom)
                    view.isHidden = false
                }
            }
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        for i in 0..<9 {
            let view = UIView()
            view.tag = LayoutTag + i
            view.isHidden = true
            view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
            self.contentView.addSubview(view)
        }
        self.contentView.backgroundColor = UIColor.white
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
