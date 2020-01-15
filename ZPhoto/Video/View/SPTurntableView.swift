//
//  SPTurntableView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/12/25.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
/// 转盘
class SPTurntableView:  UIView{
    fileprivate enum SPRunState {
         case begin
         case enter_end
         case end
     }
    fileprivate var runState : SPRunState = .begin
    fileprivate var degress : CGFloat = 0
    /// 是否在动画中
    fileprivate var isAnimationIng : Bool = false
    var list : [String]? {
        didSet{
            self.sp_setupUI()
        }
    }
    fileprivate var runView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupRun()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupRun(){
        let vH : CGFloat = sp_height() / 4.0
        let vW : CGFloat = 1
        self.runView.frame = CGRect(x: ( sp_width() - vW ) / 2.0, y: self.sp_height() / 2.0 - vH, width: vW, height: vH)
        self.runView.sp_anchorPoint(anchorpoint: CGPoint(x: 0.5, y: 1))
        self.addSubview(self.runView)
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        guard let l = list else {
            return
        }
        _ = self.subviews.map { (view) -> () in
            if view != self.runView {
                view.removeFromSuperview()
            }
        }
        sp_log(message: sp_count(array: l))
        let degress = 360 / CGFloat(sp_count(array: l))
        var current_degress : CGFloat = 0
        for data in l {
            let w = sp_width() / 2.0
            var h = sp_height() / 2.0
            if degress > 90 {
                h = 2 * w
            }
            let view = SPSectorView(frame: CGRect(x: w, y: 0, width: w, height: h))
            view.backgroundColor = SPColorForHexString(hex: data)
            view.sp_anchorPoint(anchorpoint: CGPoint(x: 0, y: degress > 90 ? 0.5 : 1))
            view.degress = degress
            self.addSubview(view)
            view.rotationAngle = current_degress
            view.transform = CGAffineTransform(rotationAngle: sp_getRadians(to: current_degress))
            current_degress += degress
        }
        self.bringSubviewToFront(self.runView)
    }
    
    deinit {
        
    }
    
}
extension SPTurntableView  : CAAnimationDelegate{
    /// 开启转动
    func sp_start(){
        guard self.isAnimationIng == false else { return }
        sp_log(message: "开始动画")
        self.isAnimationIng = true
        self.runState = .begin
        self.degress = CGFloat(arc4random() % 361)
        sp_run()
    }
    /// 处理状态
    fileprivate func sp_dealState(){
        switch self.runState {
        case .begin:
            self.runState = .enter_end
        case .enter_end:
             self.runState = .end
        default:
            self.runState = .begin
        }
    }
    fileprivate func sp_run(){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        if self.runState == .begin{
            animation.duration = 1
            animation.repeatCount = 20 + Float(arc4random() % 5)
            animation.toValue = sp_getRadians(to: 360)
        }else if self.runState == .enter_end{
            animation.duration = 2
            animation.repeatCount = 10 +  Float(arc4random() % 5)
            animation.toValue = sp_getRadians(to: 360)
        }else{
            animation.duration = self.degress > 180 ? 3 : self.degress > 90 ? 2 : 1
            animation.repeatCount = 1
            animation.toValue = sp_getRadians(to: self.degress)
            self.runView.transform = CGAffineTransform(rotationAngle: sp_getRadians(to: self.degress))
        }
        animation.isRemovedOnCompletion = false
        animation.autoreverses = false
        animation.delegate = self
        self.runView.layer.add(animation, forKey: nil)
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        sp_log(message: "动画结束")
        sp_dealState()
        if self.runState == .enter_end {
            sp_run()
        }else if self.runState == .end{
            sp_run()
        }else{
            self.runView.layer.removeAllAnimations()
            self.isAnimationIng = false
        }
    }
}
