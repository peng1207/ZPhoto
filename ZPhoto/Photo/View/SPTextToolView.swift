//
//  SPTextToolView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPTextToolComplete = (_ type : SPButtonClickType)->Void
class SPTextToolView:  UIView{
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickClose), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickSelect), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var toolView : SPPhotoToolView = {
        let view = SPPhotoToolView()
        view.isAverage = true
        view.dataArray = [
            SPToolModel.sp_init(type: SPToolType.edit)
            ,SPToolModel.sp_init(type: .textColor)
            ,SPToolModel.sp_init(type: .fontName)
            ,SPToolModel.sp_init(type: .fontSize)
            ]
        return view
    }()
    var btnBlock : SPTextToolComplete?
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
        self.addSubview(self.selectBtn)
        self.addSubview(self.toolView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(40)
            maker.left.equalTo(0)
        }
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(self.closeBtn).offset(0)
            maker.right.equalTo(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.left.equalTo(self.closeBtn.snp.right).offset(0)
            maker.right.equalTo(self.selectBtn.snp.left).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPTextToolView {
    @objc fileprivate func sp_clickClose(){
        sp_dealComplete(type: .close)
    }
    @objc fileprivate func sp_clickSelect(){
        sp_dealComplete(type: .select)
    }
    fileprivate func sp_dealComplete(type  : SPButtonClickType){
        guard let block = self.btnBlock  else {
            return
        }
        block(type)
    }
}
