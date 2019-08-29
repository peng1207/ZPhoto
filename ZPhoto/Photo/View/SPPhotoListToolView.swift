//
//  SPPhotoListEditView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/15.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPPhotoListToolView:  UIView{
    
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "share_disable"), for: UIControl.State.disabled)
        btn.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickShare), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var deleteBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "delete_trash"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "delete_disable"), for: UIControl.State.disabled)
        btn.addTarget(self, action: #selector(sp_clickDelete), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var shareBlock : SPBtnComplete?
    var deleteBlock : SPBtnComplete?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func sp_clickShare(){
        guard let block = self.shareBlock else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickDelete(){
        guard let block = self.deleteBlock else {
            return
        }
        block()
    }
    func sp_dealBtn(isEnabled : Bool){
        self.deleteBtn.isEnabled = isEnabled
        self.shareBtn.isEnabled = isEnabled
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.shareBtn)
        self.addSubview(self.deleteBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.left.equalTo(self.snp.left).offset(10)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(29)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
    }
    deinit {
        
    }
}
