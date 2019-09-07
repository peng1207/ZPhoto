//
//  SPNavItemBtnView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/7.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPNavItemBtnView:  UIView{
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_save"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_save), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_share_white"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_share), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var clickBlock : SPBtnTypeComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.saveBtn)
        self.addSubview(self.shareBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.saveBtn.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.left.equalTo(self).offset(0)
            maker.width.equalTo(self.shareBtn.snp.width).offset(0)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.saveBtn.snp.right).offset(5)
            maker.right.equalTo(self).offset(0)
            maker.top.bottom.equalTo(self.saveBtn).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPNavItemBtnView {
    @objc fileprivate func sp_save(){
        sp_dealComplete(type: .save)
    }
    @objc fileprivate func sp_share(){
        sp_dealComplete(type: .share)
    }
    fileprivate func sp_dealComplete(type : SPButtonClickType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
}
