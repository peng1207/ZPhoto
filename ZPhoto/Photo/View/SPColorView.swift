//
//  SPColorView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
typealias SPColorComplete = (_ colorHex : String)->Void

class SPColorView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "ColorCellID"
    fileprivate lazy var dataList : [String] = {
        let path = Bundle.main.path(forResource: "SPColor", ofType: "plist")
        let list = NSArray(contentsOfFile: sp_getString(string: path))
        if let l = list as? [String] {
            return l
        }
        return [String]()
    }()
    var selectBlock : SPColorComplete?
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
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = SPColorForHexString(hex: SPHexColor.color_999999.rawValue)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
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
extension SPColorView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
        if indexPath.row < sp_count(array: self.dataList) {
            let colorHex = self.dataList[indexPath.row]
            cell.contentView.backgroundColor = SPColorForHexString(hex: colorHex)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = Int( (collectionView.sp_width() - 4 - 5)) / 6
        return CGSize(width: w, height: w)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataList) {
            sp_dealSelect(colorHex: sp_getString(string: self.dataList[indexPath.row]))
        }
    }
    /// 处理选择的
    ///
    /// - Parameter colorHex: 颜色值
    fileprivate func sp_dealSelect(colorHex :String){
        sp_log(message: colorHex)
        guard let block = self.selectBlock else {
            return
        }
        
        block(colorHex)
    }
}
