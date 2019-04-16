//
//  SPPhotoListCollectionCell.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/16.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPhotoListCollectionCell: UICollectionViewCell {
  
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.backgroundColor = sp_getMianColor()
        label.sp_cornerRadius(cornerRadius: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    fileprivate lazy var maskHView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    var model : SPPhotoModel?{
        didSet{
           sp_setupData()
        }
    }
    var isSelect : Bool! {
        didSet{
            self.sp_dealSelect()
        }
    }
    var num : Int! {
        didSet{
            self.sp_dealNum()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_dealSelect(){
        if self.isSelect {
            self.maskHView.isHidden = false
            self.numLabel.isHidden = false
        }else{
            self.maskHView.isHidden = true
            self.numLabel.isHidden = true
        }
    }
    fileprivate func sp_dealNum(){
        self.numLabel.text = sp_getString(string: self.num)
    }
    /// 赋值
    fileprivate func sp_setupData(){
     self.iconImgView.image = self.model?.img
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
      
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.maskHView)
        self.contentView.addSubview(self.numLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.maskHView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self.contentView).offset(0)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.bottom.equalTo(self.contentView).offset(-5)
            maker.width.height.equalTo(24)
        }
    }
    deinit {
        
    }
}
