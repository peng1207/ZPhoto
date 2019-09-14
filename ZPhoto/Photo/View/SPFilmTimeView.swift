//
//  SPFilmTimeView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/5.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
typealias SPFilmTimeBlock = (_ picTime : TimeInterval, _ animationTime : TimeInterval)->Void

class SPFilmTimeView:  UIView{
    
    fileprivate lazy var picSlider : UISlider = {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 40
        view.minimumTrackTintColor = UIColor.white
        view.addTarget(self, action: #selector(sp_picSlider), for: UIControl.Event.valueChanged)
        return view
    }()
    fileprivate lazy var animationSlider : UISlider = {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 10
         view.minimumTrackTintColor = UIColor.white
         view.addTarget(self, action: #selector(sp_animationSlider), for: UIControl.Event.valueChanged)
        return view
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_close), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_done), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var picTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 13)
        label.text = SPLanguageChange.sp_getString(key: "PICDURATION")
        return label
    }()
    fileprivate lazy var animationTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 13)
        label.text = SPLanguageChange.sp_getString(key: "ANIMATIONDURATION")
        return label
    }()
    fileprivate lazy var picTimeContentLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = sp_fontSize(fontSize: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate lazy var animationTimeContentLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = sp_fontSize(fontSize: 13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var valueBlock : SPFilmTimeBlock?
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
        self.addSubview(self.doneBtn)
        self.addSubview(self.picTimeLabel)
        self.addSubview(self.animationTimeLabel)
        self.addSubview(self.picSlider)
        self.addSubview(self.animationSlider)
        self.addSubview(self.picTimeContentLabel)
        self.addSubview(self.animationTimeContentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(5)
            maker.left.equalTo(self).offset(5)
            maker.width.height.equalTo(30)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(5)
            maker.right.equalTo(self).offset(-5)
            maker.width.height.equalTo(30)
        }
        self.picTimeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.picSlider).offset(0)
            maker.left.equalTo(self).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.equalTo(self.animationTimeLabel.snp.width).offset(0)
        }
        self.animationTimeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.animationSlider.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(self.picTimeLabel).offset(0)
        }
        self.picSlider.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.picTimeLabel.snp.right).offset(10)
            maker.right.equalTo(self.picTimeContentLabel.snp.left).offset(-8)
            maker.height.equalTo(30)
            maker.top.equalTo(self.closeBtn.snp.bottom).offset(5)
        }
        self.animationSlider.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.picSlider).offset(0)
            maker.top.equalTo(self.picSlider.snp.bottom).offset(10)
            maker.bottom.equalTo(self).offset(-5)
        }
        self.picTimeContentLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.picSlider).offset(0)
            maker.width.equalTo(40)
        }
        self.animationTimeContentLabel.snp.makeConstraints { (maker) in
            maker.right.width.equalTo(self.picTimeContentLabel).offset(0)
            maker.centerY.equalTo(self.animationSlider).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
extension SPFilmTimeView {
    @objc fileprivate func sp_close(){
        sp_mainQueue {
            self.isHidden = true
        }
    }
    @objc fileprivate func sp_done(){
        sp_close()
        sp_dealComplete()
       
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.valueBlock else {
            return
        }
        block(0.5 * TimeInterval(Int(self.picSlider.value)) , 0.5 * TimeInterval(Int(self.animationSlider.value)))
    }
    @objc fileprivate func sp_picSlider(){
        let time = 0.5 * TimeInterval(Int(self.picSlider.value))
        sp_showTime(time: time)
        sp_log(message: time)
        sp_update(picLabel: time)
        
    }
    @objc fileprivate func sp_animationSlider(){
        let time = 0.5 * TimeInterval(Int(self.animationSlider.value))
        sp_log(message: time)
        sp_showTime(time: time)
        sp_update(animationLabel: time)
    }
    fileprivate func sp_showTime(time : TimeInterval){
        guard let supView = self.superview else {
            return
        }
        
        let label = UILabel()
        label.font = sp_fontSize(fontSize: 18)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        label.text = "\(time)s"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sp_cornerRadius(radius: 30)
        supView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(60)
            maker.centerY.equalTo(supView.snp.centerY).offset(0)
            maker.centerX.equalTo(supView.snp.centerX).offset(0)
        }
        sp_asyncAfter(time: 0.5) {
            label.removeFromSuperview()
        }
    }
    
    /// 更新照片时长和动画时长
    ///
    /// - Parameters:
    ///   - picTime: 照片时长
    ///   - animationTimer: 动画时长
    func sp_update(picTime : TimeInterval, animationTimer : TimeInterval){
        self.picSlider.value = Float(picTime / 0.5)
        self.animationSlider.value = Float(animationTimer / 0.5)
        sp_update(picLabel: picTime)
        sp_update(animationLabel: animationTimer)
    }
    fileprivate func sp_update(picLabel picTime : TimeInterval){
        self.picTimeContentLabel.text = "\(picTime)s"
    }
    fileprivate func sp_update(animationLabel animationTime : TimeInterval){
        self.animationTimeContentLabel.text = "\(animationTime)s"
    }
    
}

