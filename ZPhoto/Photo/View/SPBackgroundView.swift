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
typealias SPBackgroundSelectComplete = (_ color : UIColor?, _ image : UIImage?)->Void
class SPBackgroundView:  UIView{
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.highlighted)
        btn.addTarget(self, action: #selector(sp_clickClose), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var albumBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_album"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickAlbum), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate var cellID = "collectionColorCellID"
    fileprivate lazy var dataList : [String] = {
        let path = Bundle.main.path(forResource: "SPColor", ofType: "plist")
        let list = NSArray(contentsOfFile: sp_getString(string: path))
        if let l = list as? [String] {
            return l
        }
        return [String]()
    }()
    var selectBlock : SPBackgroundSelectComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.closeBtn)
        self.addSubview(self.albumBtn)
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
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.addSubview(self.collectionView)
       
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.top.equalTo(self).offset(10)
            maker.left.equalTo(self).offset(10)
        }
        self.albumBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.closeBtn.snp.right).offset(10)
            maker.centerY.equalTo(self.closeBtn.snp.centerY).offset(0)
            maker.width.height.equalTo(30)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.top.equalTo(self.closeBtn.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPBackgroundView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
      
        if indexPath.row < sp_count(array:  self.dataList) {
            cell.contentView.backgroundColor =  SPColorForHexString(hex: self.dataList[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height - 10
        return CGSize(width: h, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataList) {
            let colorHX =  self.dataList[indexPath.row]
            sp_dealComplete(color: SPColorForHexString(hex: colorHX),image: nil)
//            sp_log(message: colorHX)
        }
    }
}
extension SPBackgroundView {
    @objc fileprivate func sp_clickClose(){
        self.isHidden = true
    }
    fileprivate func sp_dealComplete(color : UIColor?,image : UIImage?){
        guard let block = self.selectBlock else {
            return
        }
        block(color,image)
    }
    @objc fileprivate func sp_clickAlbum(){
        if let topVC = sp_topVC() {
            let imagePicker = SPImagePickerVC(maxSelectNum: 1) { [weak self](images, data) in
                self?.sp_dealComplete(color: nil, image: images?.first)
            }
            imagePicker.modalPresentationStyle = .fullScreen
            topVC.present(imagePicker, animated: true, completion: nil)
        }
    }
}
