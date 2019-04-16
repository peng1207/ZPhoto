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
class SPSplicingToolView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPSplicingToolCollectionCellID"
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
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPSplicingToolCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
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


class SPSplicingToolCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
