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

/// 按钮点击回调
typealias SPCameraBtnClickBlock = (_ type : ButtonClickType)->Void

class SPCameraBtnView:  UIView{
    
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "back"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var cameraBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "recordStart"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickTakePhoto), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var flashBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "flashOn"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "flashOff"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickFlash), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var filterBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
       btn.setImage(UIImage(named: "filter"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickFilter), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var changeDevBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "switchCamera"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickChangeDev), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPCameraBtnClickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.backBtn)
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
        self.backBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.left.equalTo(self.snp.left).offset(12)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.cameraBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.width.height.equalTo(40)
            maker.centerY.equalTo(self.backBtn.snp.centerY).offset(0)
        }
        self.filterBtn.snp.makeConstraints { (maker) in
           maker.left.equalTo(self.cameraBtn.snp.left).multipliedBy(0.5)
            maker.centerY.equalTo(self.backBtn.snp.centerY).offset(0)
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
    /// 点击返回
    @objc fileprivate func sp_clickBack(){
        sp_dealComplete(type: .cance)
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
    fileprivate func sp_dealComplete(type : ButtonClickType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
}
