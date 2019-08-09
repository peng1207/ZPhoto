//
//  SPColorView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/27.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

class SPColorView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var cellID = "collectionColorCellID"
    var dataArray : [UIColor]?
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
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.addSubview(self.collectionView)
       
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
extension SPColorView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
        var view = cell.contentView.viewWithTag(100)
        if view == nil {
            view = UIView()
            view?.sp_cornerRadius(radius: 10)
            view?.sp_border(color: UIColor.white, width: 1)
            view?.tag = 100
            cell.contentView.addSubview(view!)
            view?.snp.makeConstraints({ (maker) in
                maker.width.equalTo(20)
                maker.height.equalTo(20)
                maker.centerX.equalTo(cell.contentView.snp.centerX).offset(0)
                maker.centerY.equalTo(cell.contentView.snp.centerY).offset(0)
            })
        }
        
        if indexPath.row < sp_count(array:  self.dataArray) {
            view?.backgroundColor = self.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataArray) {
            
        }
    }
}
