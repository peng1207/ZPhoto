//
//  SPTimeView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/12/16.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
/// 获取角度回调
fileprivate typealias SPDegreesComplete = (_ view : SPTimeStripView) -> Void

class SPTimeView:  UIView{
    
    fileprivate lazy var lastView : SPTimeStripView = {
        let view = SPTimeStripView()
        view.backgroundColor = UIColor.clear
        view.isLeft = true
        view.sp_update(degrees: 360)
        view.degreesBlock = { [weak self](v) in
            self?.sp_dealDegrees(to: v)
        }
       
        return view
    }()
    fileprivate lazy var firstView : SPTimeStripView = {
        let view = SPTimeStripView()
        view.backgroundColor = UIColor.clear
        view.isLeft = false
        view.degreesBlock = { [weak self](v) in
            self?.sp_dealDegrees(to: v)
        }
        return view
    }()
    public var minDegrees : CGFloat = 0.0
    fileprivate var isFirst : Bool = false
    public var second : CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        self.minDegrees = 30
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 处理角度改变的回调
    /// - Parameter view: 当前改变角度的view
    fileprivate func sp_dealDegrees(to view : SPTimeStripView){
        if self.lastView.degrees - self.firstView.degrees < self.minDegrees {
            if view == self.lastView {
                self.lastView.sp_update(degrees: self.firstView.degrees + self.minDegrees)
            }else if view == self.firstView {
                self.firstView.sp_update(degrees: self.lastView.degrees - self.minDegrees)
            }
        }
    }
    fileprivate func sp_drawTitle(att : NSAttributedString, point : CGPoint){
        att.draw(at: point)
    }
    fileprivate func sp_calcu(degress : CGFloat , title : String){
        // 90 180 270 360 字体要16 其它字体14
        var fontSize : CGFloat = 11
        if Int(degress) % 90 == 0 {
            fontSize = 13
        }
        let point = sp_getPoint(to: CGPoint(x: sp_width() / 2.0, y: sp_height() / 2.0), radius: sp_width() / 2.0, degress: degress)
        let att = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : sp_fontSize(fontSize: fontSize) , NSAttributedString.Key.foregroundColor : UIColor.white])
        let titleRect = att.boundingRect(with: CGSize(width: sp_width() / 2.0, height: sp_height() / 2.0), options: [], context: nil)
        let newPoint = CGPoint(x: point.x - (degress == 180 || degress == 360 ? titleRect.size.width / 2.0 : degress < 180 ? titleRect.size.width + 6: -6),
                               y: point.y - ( degress == 180 ? titleRect.size.height : degress == 0 || degress == 360 ? -3 : titleRect.size.height / 2.0))
        sp_drawTitle(att: att, point: newPoint)
    }
    /// 处理数据 根据秒分割数据
    fileprivate func sp_dealValue(){
        guard second > 0 else {
            return
        }
        let degressList : [CGFloat] = [45,90,135,180,225,270,315,360]
        for degress in degressList {
            let ratio = degress / 360.0
            sp_calcu(degress: degress, title: String(format: "%0.2f", second * ratio))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sp_log(message: self.firstView.degrees)
        sp_log(message: self.lastView.degrees)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.lastView)
        self.addSubview(self.firstView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.isFirst == false else {
            sp_dealValue()
            return
        }
        self.sp_dealValue()
        let w :  CGFloat = 15
        self.firstView.frame = CGRect(x: sp_width() / 2.0 , y: 0, width: w, height: sp_height() / 2.0)
        self.lastView.frame = CGRect(x: sp_width() / 2.0 - w, y: 0, width: w, height: sp_height() / 2.0)
        self.firstView.sp_anchorPoint(anchorpoint: CGPoint(x: 0, y: 1))
        self.lastView.sp_anchorPoint(anchorpoint: CGPoint(x: 1, y: 1))
        self.isFirst = true
    }
    deinit {
        
    }
}

fileprivate class SPTimeStripView : UIView {
    
 
    public var isLeft : Bool = true {
        didSet{
            self.sp_updateViewLayout()
            self.sp_setupImg()
        }
    }
    /// 角度回调
    public var degreesBlock : SPDegreesComplete?
    /// 角度
    public var degrees : CGFloat = 0
    /// 最后移动位置
    private var lastPoint : CGPoint = CGPoint.zero
    fileprivate lazy var topView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.alpha = 0.7
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.7
        return view
    }()
    fileprivate lazy var shapeLayer : CAShapeLayer = {
        let l = CAShapeLayer()
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
        sp_addGesture()
        sp_setupImg()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.lineView)
        self.addSubview(self.topView)
        self.sp_addConstraint()
    }
    fileprivate func sp_addConstraint(){
        self.topView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(self).offset(0)
            maker.height.equalTo(self.topView.snp.width).multipliedBy(3.0 / 2.0)
        }
        sp_updateViewLayout()
    }
    fileprivate func sp_updateViewLayout(){
        self.lineView.snp.remakeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(0)
            maker.top.equalTo(self.topView.snp.bottom).offset(0)
            maker.width.equalTo(sp_scale(value: 1))
            if self.isLeft {
                maker.right.equalTo(self).offset(0)
            }else {
                maker.left.equalTo(self).offset(0)
            }
        }
    }
    private func sp_setupImg(){
        if self.isLeft {
            self.topView.image = UIImage(named: "public_left")
        }else{
            self.topView.image = UIImage(named: "public_right")
        }
    }
    /// 添加手势
    fileprivate func sp_addGesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(sp_panGest(pan:)))
        self.topView.addGestureRecognizer(pan)
    }
    /// 手势事件
    /// - Parameter pan: 手势
    @objc fileprivate func sp_panGest(pan : UIPanGestureRecognizer){
        let point = pan.location(in: self.superview)
        if pan.state == .began {
            lastPoint = point
        }
        // 手势移动是否在左边 中间为分割线
        var move_left : Bool = false
        // 手势移动是否在上边 中间为分割线
        var move_up : Bool = false
        var is_add : Bool = true
        var size = self.frame.size
        if let s = self.superview?.frame.size {
            size = s
        }
        if point.x < size.width / 2.0  {
            move_left = true
        }
        if point.y < size.height / 2.0 {
            move_up = true
        }
        if point.y == lastPoint.y {
            if (move_up && point.x > lastPoint.x) || (!move_up && point.x < lastPoint.x) {
                is_add = true
            }else{
                is_add = false
            }
        }else{
            if (move_left && point.y < lastPoint.y) || (!move_left && point.y > lastPoint.y) {
                is_add = true
            }else{
                is_add = false
            }
        }
        let centerPoint = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        // 弧度
        let angle = sp_getAngleToPonts(p1: self.lastPoint, p2: centerPoint, p3: point)
        // 角度
        let d = sp_getDegrees(to: CGFloat(angle))
        sp_update(degrees: is_add ?  self.degrees + d : self.degrees - d)
        lastPoint = point
        sp_dealComplete()
    }
    /// 更新角度
    /// - Parameter degrees: 角度
    public func sp_update(degrees : CGFloat) {
        self.degrees = degrees
        if self.degrees > 360 {
            self.degrees = 360
        }
        if self.degrees < 0 {
            self.degrees = 0
        }
        self.transform = CGAffineTransform(rotationAngle: sp_getRadians(to: self.degrees))
    }
    /// 处理回调
    fileprivate func sp_dealComplete(){
        guard let block = self.degreesBlock else { return }
        block(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
