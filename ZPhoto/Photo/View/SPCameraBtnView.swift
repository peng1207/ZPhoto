//
//  SPCameraBtnView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/27.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

class SPCameraBtnView:  UIView{
    
    fileprivate lazy var layoutBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_layout"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickLayout), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var cameraBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "recordStart"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickTakePhoto), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var flashBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "flashOn"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "flashOff"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(sp_clickFlash), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var filterBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
       btn.setImage(UIImage(named: "filter"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickFilter), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var changeDevBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "switchCamera"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickChangeDev), for: UIControl.Event.touchUpInside)
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
        self.addSubview(self.layoutBtn)
        self.addSubview(self.cameraBtn)
        self.addSubview(self.changeDevBtn)
        if !SP_IS_IPAD {
            self.addSubview(self.flashBtn)
        }
        
        self.addSubview(self.filterBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.layoutBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.left.equalTo(self.snp.left).offset(12)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.cameraBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.width.height.equalTo(40)
            maker.centerY.equalTo(self.layoutBtn.snp.centerY).offset(0)
        }
        self.filterBtn.snp.makeConstraints { (maker) in
           maker.left.equalTo(self.cameraBtn.snp.left).multipliedBy(0.5)
            maker.centerY.equalTo(self.layoutBtn.snp.centerY).offset(0)
            maker.width.height.equalTo(40)
        }
        self.changeDevBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cameraBtn.snp.left).multipliedBy(1.5)
            maker.centerY.equalTo(self.cameraBtn.snp.centerY).offset(0)
            maker.width.height.equalTo(40)
        }
        if !SP_IS_IPAD {
            self.flashBtn.snp.makeConstraints { (maker) in
                maker.right.equalTo(self.snp.right).offset(-12)
                maker.centerY.equalTo(self.cameraBtn.snp.centerY).offset(0)
                maker.width.height.equalTo(40)
            }
        }
    }
    deinit {
        
    }
}
extension SPCameraBtnView {
    /// 点击布局
    @objc fileprivate func sp_clickLayout(){
        sp_dealComplete(type: .layout)
    }
    /// 点击拍照
    @objc fileprivate func sp_clickTakePhoto(){
        sp_dealComplete(type: .done)
    }
    /// 点击闪光灯
    @objc fileprivate func sp_clickFlash(){
        sp_dealComplete(type: .flash)
    }
    /// 点击切换摄像头
    @objc fileprivate func sp_clickChangeDev(){
        sp_dealComplete(type: .change)
    }
    /// 点击滤镜
    @objc fileprivate func sp_clickFilter(){
        sp_dealComplete(type: .filter)
    }
    /// 处理回调
    ///
    /// - Parameter type: 点击类型
    fileprivate func sp_dealComplete(type : SPButtonClickType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
    /// 处理按钮是否选中
    ///
    /// - Parameters:
    ///   - btnType: 按钮类型
    ///   - isSelect: 是否选中
    func sp_deal(btnType : SPButtonClickType,isSelect : Bool){
        switch btnType {
        case .flash:
            self.flashBtn.isSelected = isSelect
        default:
            sp_log(message: "")
        }
        
    }
}
