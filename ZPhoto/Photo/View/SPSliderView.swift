//
//  SPFontSizeView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

/// 获取滑块值变化
typealias SPSliderComplete = (_ value : Float)->Void

class SPSliderView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 16)
        return label
    }()
    lazy var slider : UISlider = {
        let view = UISlider()
        view.addTarget(self, action: #selector(sp_sliderChange), for: UIControl.Event.valueChanged)
        view.minimumValue = 15
        view.maximumValue = 40
        return view
    }()
    var value : Float = 15{
        didSet {
            sp_setupValue()
        }
    }
    var title : String?
    var valueBlock : SPSliderComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupValue(){
        self.slider.value = self.value
        sp_setupData()
    }
    /// 赋值
    fileprivate func sp_setupData(){
       self.titleLabel.text = sp_getString(string: self.title) + "  " + sp_getString(string: Int(self.slider.value))
    }
    @objc fileprivate func sp_sliderChange(){
        sp_setupData()
        guard let block = self.valueBlock else {
            return
        }
        block(self.slider.value)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.slider)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.slider.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.height.equalTo(30)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
