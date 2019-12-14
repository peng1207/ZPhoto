//
//  SPImagePickerListCollectionCell.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/15.
//

import Foundation
import UIKit
import SnapKit
/// 图片cell 
class SPImagePickerListCollectionCell: UICollectionViewCell {
    lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    lazy var selectImgView : UIImageView = {
        let view = UIImageView()
        view.image = Bundle.sp_getImg(name: "sdk_select@2x")
        return view
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
        self.contentView.addSubview(self.selectImgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.selectImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(25)
            maker.bottom.equalTo(self.contentView).offset(-5)
            maker.right.equalTo(self.contentView).offset(-5)
        }
    }
    deinit {
        
    }
}
