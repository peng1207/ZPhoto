//
//  SPVideoSelectCollectionCell.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/1.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPVideoSelectCollectionCell: UICollectionViewCell {
    
    lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_fontSize(fontSize:  13)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_fontSize(fontSize:  10)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        label.backgroundColor = sp_getMianColor()
        label.sp_cornerRadius(radius: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.numLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView.snp.right).offset(-3)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-3)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.left.greaterThanOrEqualTo(self.contentView.snp.left).offset(3)
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
