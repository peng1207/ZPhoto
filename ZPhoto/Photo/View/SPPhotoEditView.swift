//
//  SPPhotoEditView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/17.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

typealias SPPhotoEditComplete = (_ type : ButtonClickType)->Void

class SPPhotoEditView:  UIView{
    
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "CANCE"), for: UIControl.State.normal)
        btn.setTitleColor(sp_getMianColor(), for: UIControl.State.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var finishBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "FINISH"), for: UIControl.State.normal)
        btn.setTitleColor(sp_getMianColor(), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControl.State.disabled)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickFinish), for: UIControl.Event.touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    fileprivate lazy var shearBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("剪切", for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControl.State.selected)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickShear), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var filterBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("滤镜", for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControl.State.selected)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickFilter), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var clickBlock : SPPhotoEditComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.canceBtn)
        self.addSubview(self.finishBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(50)
        }
        self.finishBtn.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(50)
        }
    }
    deinit {
        
    }
}
extension SPPhotoEditView{
    
    @objc fileprivate func sp_clickCance(){
            sp_dealBtnClick(type: .cance)
    }
    @objc fileprivate func sp_clickFinish(){
        sp_dealBtnClick(type: .done)
    }
    @objc fileprivate func sp_clickShear(){
        sp_dealBtnClick(type: .shear)
    }
    @objc fileprivate func sp_clickFilter(){
        sp_dealBtnClick(type: .filter)
    }
    fileprivate func sp_dealBtnClick(type : ButtonClickType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
        
    }
}
