//
//  SPLongGraphLayoutView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPLongGraphLayoutView:  UIView{
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickClose), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var verticalBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "layout_vertical"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickVertical), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var horizontalBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "layout_horizontal"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickHorizontal), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var direction : SPDirection = .vertical
    var clickBlock : SPBtnComplete?
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
        self.addSubview(self.verticalBtn)
        self.addSubview(self.horizontalBtn)
 
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.closeBtn.snp.height).offset(0)
        }
        self.verticalBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.closeBtn.snp.right).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.verticalBtn.snp.height).offset(0)
        }
        self.horizontalBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.verticalBtn.snp.right).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.horizontalBtn.snp.height).offset(0)
        }
        
    }
    deinit {
        
    }
}
extension SPLongGraphLayoutView {
    @objc fileprivate func sp_clickClose(){
        self.isHidden = true
    }
    @objc fileprivate func sp_clickVertical(){
        self.direction = .vertical
        sp_dealComplete()
    }
    @objc fileprivate func sp_clickHorizontal(){
        self.direction = .horizontal
        sp_dealComplete()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
}
