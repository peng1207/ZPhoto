//
//  SPVideoSplicingLayoutView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/12.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class  SPVideoSplicingLayoutView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "VideoSplicingLayoutCellID"
    var dataArray : [[CGRect]]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectBlock : SPIndexComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.backgroundColor = sp_getMianColor()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
//        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPVideoSplicingLayoutCell.self, forCellWithReuseIdentifier: self.cellID)
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
extension SPVideoSplicingLayoutView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPVideoSplicingLayoutCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPVideoSplicingLayoutCell
        if indexPath.row < sp_count(array: self.dataArray) {
            cell.frameList = self.dataArray?[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray) {
            guard let block = self.selectBlock else{
                return
            }
            block(indexPath.row)
        }
    }
}

fileprivate class SPVideoSplicingLayoutCell: UICollectionViewCell {
    fileprivate let viewTag = 1000
    var frameList : [CGRect]?{
        didSet{
            self.sp_dealFrame()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_dealFrame(){
        sp_allViewHidden()
        if  let list = frameList {
            var index = 0
            for f in list {
                if let view = self.contentView.viewWithTag(index + viewTag){
                    view.isHidden = false
                    view.frame = f
                }
                index = index + 1
            }
        }
        
    }
    fileprivate func sp_allViewHidden(){
        for i in 0..<9 {
            if let view = self.contentView.viewWithTag(i + viewTag){
                view.isHidden = true
            }
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        for i in 0..<9 {
            let view = UIView()
            view.tag = viewTag + i
            view.isHidden = true
            view.backgroundColor = i % 2 == 0 ? UIColor.white : SPColorForHexString(hex: SPHexColor.color_eeeeee.rawValue)
            self.contentView.addSubview(view)
            let lineView = UIView()
            lineView.backgroundColor = SPColorForHexString(hex: SPHexColor.color_eeeeee.rawValue)
            view.addSubview(lineView)
            lineView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(view).offset(0)
                maker.height.equalTo(sp_scale(value: 1))
            }
        }
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
