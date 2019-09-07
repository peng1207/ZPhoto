//
//  SPVideoLayoutView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/7.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

typealias SPVideoLayoutSelectBlock = (_ type : SPVideoLayoutType)->Void

class SPVideoLayoutView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var dataArray : [SPVideoLayoutType] = {
       return [SPVideoLayoutType.none , SPVideoLayoutType.bisection,SPVideoLayoutType.quadrature,SPVideoLayoutType.sextant,SPVideoLayoutType.nineEqualparts]
    }()
    fileprivate let cellID = "videoLayoutCellID"
    var selectBlock : SPVideoLayoutSelectBlock?
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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 40, height: 40)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPVideoLayoutCollectCell.self, forCellWithReuseIdentifier: self.cellID)
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
extension SPVideoLayoutView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPVideoLayoutCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPVideoLayoutCollectCell
        if indexPath.row < sp_count(array: self.dataArray) {
            cell.type = self.dataArray[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray) {
            guard let block = self.selectBlock else {
                return
            }
            block(self.dataArray[indexPath.row])
        }
    }
}

class SPVideoLayoutCollectCell: UICollectionViewCell {
    var type : SPVideoLayoutType = .none {
        didSet{
            self.sp_dealType()
        }
    }
    fileprivate lazy var h1View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    fileprivate lazy var h2View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    fileprivate lazy var v1View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    fileprivate lazy var v2View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue).withAlphaComponent(0.5)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_dealType(){
        sp_allHidden()
        switch type {
        case .bisection:
            self.h1View.isHidden = false
        case .quadrature:
            self.h1View.isHidden = false
            self.v1View.isHidden = false
        case .sextant:
            self.v1View.isHidden = false
            self.v2View.isHidden = false
            self.h1View.isHidden = false
        case .nineEqualparts:
            self.v1View.isHidden = false
            self.v2View.isHidden = false
            self.h1View.isHidden = false
            self.h2View.isHidden = false
        default:
            sp_log(message: "")
        }
        sp_addConstraint()
    }
    fileprivate func sp_allHidden(){
        self.v2View.isHidden = true
        self.v1View.isHidden = true
        self.h2View.isHidden = true
        self.h1View.isHidden = true
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.v1View)
        self.contentView.addSubview(self.v2View)
        self.contentView.addSubview(self.h1View)
        self.contentView.addSubview(self.h2View)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.h1View.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_scale(value: 1))
            if type == .nineEqualparts {
                maker.centerY.equalTo(1.0 / 3.0 * 40)
            }else{
                maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            }
            
        }
        self.h2View.snp.remakeConstraints { (maker) in
            maker.left.right.height.equalTo(self.h1View).offset(0)
            maker.centerY.equalTo(2.0 / 3.0 * 40)
        }
        self.v1View.snp.remakeConstraints { (maker) in
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(sp_scale(value: 1))
            if type == .quadrature {
                maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            }else{
                maker.centerX.equalTo(1.0 / 3.0 * 40)
            }
        }
        self.v2View.snp.remakeConstraints { (maker) in
            maker.top.bottom.width.equalTo(self.v1View).offset(0)
            maker.centerX.equalTo(2.0 / 3.0 * 40)
        }
    }
    deinit {
        
    }
}
