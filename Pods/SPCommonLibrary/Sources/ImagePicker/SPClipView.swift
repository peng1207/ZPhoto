//
//  SPClipView.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/8/5.
//

import Foundation
import UIKit
import SnapKit
class SPClipView : UIView{
    
    fileprivate lazy var topLeftView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var topRightView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var bottomLeftView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var bottomRightView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var h1View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate let K_MIN_H : CGFloat = 50
    fileprivate let K_MIN_W : CGFloat = 50
    fileprivate var lastPoint : CGPoint = CGPoint.zero
    var imgFrameBlock : (()->CGRect)?
    /// 展示的宽高比例 默认为1 若比例小于等于0的 则使用用户拖动的距离计算
    var ratio : CGFloat = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_addGesture()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.topLeftView)
        self.addSubview(self.topRightView)
        self.addSubview(self.bottomLeftView)
        self.addSubview(self.bottomRightView)
        self.addSubview(self.h1View)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.topLeftView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self).offset(0)
            maker.width.equalTo(20)
            maker.height.equalTo(20)
        }
        self.topRightView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.topLeftView).offset(0)
            maker.right.top.equalTo(self).offset(0)
        }
        self.bottomLeftView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.width.height.equalTo(self.topLeftView).offset(0)
        }
        self.bottomRightView.snp.makeConstraints { (maker) in
            maker.right.bottom.equalTo(self).offset(0)
            maker.width.height.equalTo(self.topLeftView).offset(0)
        }
//        self.h1View.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self).offset(0)
//            maker.height.equalTo(1)
//            maker.top.equalTo(self.snp.height).multipliedBy(1.00/3.00)
//        }
    }
    
    deinit {
        
    }
    
}
extension SPClipView {
    fileprivate func sp_addGesture(){
        self.topLeftView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sp_topLeft(panGest:))))
        self.topRightView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sp_topRight(panGest:))))
        self.bottomLeftView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sp_bottomLeft(panGest:))))
        self.bottomRightView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sp_bottomRight(panGest:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sp_panGest(panGest:))))
    }
    /// 左右上角手势
    ///
    /// - Parameter panGest: 手势
    @objc fileprivate func sp_topLeft(panGest : UIPanGestureRecognizer){
        let point = panGest.translation(in: self)
        if panGest.state == UIGestureRecognizer.State.began {
            self.lastPoint = CGPoint.zero
        }
        
        var x = self.sp_x()
        var y = self.sp_y()
        var w = self.sp_width()
        var h = self.sp_height()
        let move_x = point.x - self.lastPoint.x
        let move_y = point.y - self.lastPoint.y
        
        if self.ratio <= 0 {
            x = x + move_x
            y = y + move_y
            w = w - move_x
            h = h - move_y
            if w < K_MIN_W {
                w = K_MIN_W
            }
            if  h < K_MIN_H {
                h = K_MIN_H
            }
        }else{
            x = x + move_x
            w = w - move_x
            if w < K_MIN_W {
                w = K_MIN_H
            }
            h = w / self.ratio
            y = y + (sp_height() - h)
            
        }
        let imgFrame = self.sp_imgFrame()
        
        if y < imgFrame.origin.y {
            y = imgFrame.origin.y
        }
        if x < imgFrame.origin.x {
            x = imgFrame.origin.x
        }
        
        if y + h > imgFrame.origin.y + imgFrame.size.height {
            y = imgFrame.origin.y + imgFrame.size.height - h
        }
        
        if y + h >= self.sp_maxY() {

            h = self.sp_maxY() - y
            if h < K_MIN_H {
                h = K_MIN_H
                y = self.sp_maxY() - h
            }
        }
        
        if x + w >= self.sp_maxX() {
            w = self.sp_maxX() - x
            if w < K_MIN_W {
                w = K_MIN_W
                x = self.sp_maxX() - w
            }
            if self.ratio > 0 {
                if h != w / self.ratio {
                    w = h * self.ratio
                    if x + w > self.sp_maxX() {
                        x = self.sp_maxX() - w
                    }
                }
            }
        } 
        let frame = CGRect(x: x, y: y, width: w, height: h)
        self.frame = frame
        sp_updateLayout(frame: frame)
        self.lastPoint = point
    }
    /// 右上角手势
    ///
    /// - Parameter panGest: 手势
    @objc fileprivate func sp_topRight(panGest : UIPanGestureRecognizer){
        let point = panGest.translation(in: self)
        if panGest.state == UIGestureRecognizer.State.began {
            self.lastPoint = CGPoint.zero
        }
        
        let imgFrame = self.sp_imgFrame()
        var x = self.sp_x()
        var y = self.sp_y()
        var w = self.sp_width()
        var h = self.sp_height()
        let move_x = point.x - self.lastPoint.x
        let move_y = point.y - self.lastPoint.y
        if self.ratio <= 0 {
            w = w + move_x
            h = h - move_y
            y = y + move_y
            if h < K_MIN_H {
                h = K_MIN_H
            }
            if w < K_MIN_W {
                w = K_MIN_W
            }
        }else{
            w = w + move_x
            if w < K_MIN_W {
                w = K_MIN_W
            }
            h = w / self.ratio
            y = y + (sp_height() - h)
        }
        
      
        if x + w >= imgFrame.origin.x + imgFrame.size.width {
            w = imgFrame.origin.x + imgFrame.size.width - x
            if self.ratio > 0 {
                h = w / self.ratio
                y = y + (sp_height() - h)
            }
        }
        if y < imgFrame.origin.y {
            y = imgFrame.origin.y
        }
        if x < imgFrame.origin.x {
            x = imgFrame.origin.x
        }
        
        if y > imgFrame.origin.y + imgFrame.size.height {
            y = imgFrame.origin.y + imgFrame.size.height
        }
        if y + h >= self.sp_maxY() {
            h = self.sp_maxY() - y
            
            if h < K_MIN_H {
                h = K_MIN_H
                y = self.sp_maxY() - h
            }
        }
        
        if  self.ratio > 0  {
            if h != w / self.ratio {
                w = self.ratio * h
            }
        }
        
        let newFrame = CGRect(x: x, y: y, width: w, height: h)
        self.frame = newFrame
        sp_updateLayout(frame: newFrame)
        self.lastPoint = point
        
    }
    
    /// 左下角手势
    ///
    /// - Parameter panGest: 手势
    @objc fileprivate func sp_bottomLeft(panGest : UIPanGestureRecognizer){
        let point = panGest.translation(in: self)
        if panGest.state == UIGestureRecognizer.State.began {
            self.lastPoint = CGPoint.zero
        }
   
        var x = self.sp_x()
        var y = self.sp_y()
        var w = self.sp_width()
        var h = self.sp_height()
        let move_x = point.x - self.lastPoint.x
        let move_y = point.y - self.lastPoint.y
         let imgFrame = self.sp_imgFrame()
        if self.ratio <= 0 {
            x = x + move_x
            w = w - move_x
            h = h + move_y
            
            if h < K_MIN_H {
                h = K_MIN_H
            }
            if w < K_MIN_W {
                w = K_MIN_W
            }
        }else{
            x = x + move_x
            w = w - move_x
            if w < K_MIN_W {
                w = K_MIN_W
            }
            h = w / self.ratio
        }
        if y < imgFrame.origin.y {
            y = imgFrame.origin.y
        }
        if x < imgFrame.origin.x {
            x = imgFrame.origin.x
        }
        
        if y > imgFrame.origin.y + imgFrame.size.height {
            y = imgFrame.origin.y + imgFrame.size.height
        }
        
        if y + h > imgFrame.origin.y + imgFrame.size.height {
            h = imgFrame.origin.y + imgFrame.size.height - y
            if h < K_MIN_H{
                h = K_MIN_H
                y = imgFrame.origin.y + imgFrame.size.height - h
            }
        }
        
        
        if x + w >= self.sp_maxX() {
            w = self.sp_maxX() - x
            if w < K_MIN_W {
                w = K_MIN_W
                x = self.sp_maxX() - w
            }
        }
        if self.ratio > 0 {
            if h != w / self.ratio {
                w = self.ratio * h
                x = sp_maxX() - w
            }
            
        }
        let newFrame = CGRect(x: x, y: y , width: w, height: h)
        self.frame = newFrame
        sp_updateLayout(frame: newFrame)
        self.lastPoint = point
        
    }
    /// 右下角手势
    ///
    /// - Parameter panGest: 手势
    @objc fileprivate func sp_bottomRight(panGest : UIPanGestureRecognizer){
        let point = panGest.translation(in: self)
        if panGest.state == UIGestureRecognizer.State.began {
            self.lastPoint = CGPoint.zero
        }
        var x = self.sp_x()
        var y = self.sp_y()
        var w = self.sp_width()
        var h = self.sp_height()
        let move_x = point.x - self.lastPoint.x
        let move_y = point.y - self.lastPoint.y
        
        let imgFrame = self.sp_imgFrame()
        if self.ratio <= 0 {
            w = w + move_x
            h = w + move_y
            
            if w < K_MIN_W {
                w = K_MIN_W
            }
            if  h < K_MIN_H {
                h = K_MIN_H
            }
        }else{
            w = w + max(move_x, move_y)
            if w < K_MIN_W {
                w = K_MIN_W
            }
            h = w / self.ratio
        }
 
        if x < imgFrame.origin.x {
            x = imgFrame.origin.x
        }
        if  y < imgFrame.origin.y {
            y = imgFrame.origin.y
        }
       
        
        if self.ratio > 0 {
            if x + w > imgFrame.origin.x + imgFrame.size.width {
                w = imgFrame.origin.x + imgFrame.size.width - x
                h = w / self.ratio
            }
            if h + y > imgFrame.origin.y + imgFrame.size.height {
                h = imgFrame.origin.y + imgFrame.size.height - y
            }
            if h != w / self.ratio {
                w = h * self.ratio
            }

        }else{
            if x + w > imgFrame.origin.x + imgFrame.size.width {
                w = imgFrame.origin.x + imgFrame.size.width - x
            }
            
            if y + h > imgFrame.origin.y + imgFrame.size.height {
                h = imgFrame.origin.y + imgFrame.size.height - y
            }
        }
     
        let newFrame = CGRect(x: x, y: y, width: w, height: h)
        self.frame = newFrame
        sp_updateLayout(frame: newFrame)
        self.lastPoint = point
    }
    
    @objc fileprivate func sp_panGest(panGest: UIPanGestureRecognizer){
        let point = panGest.translation(in: self)
        if panGest.state == UIGestureRecognizer.State.began {
            self.lastPoint = CGPoint.zero
        }
        let move_x = point.x - self.lastPoint.x
        let move_y = point.y - self.lastPoint.y
        
        var x = self.sp_x()
        var y = self.sp_y()
        
        x = x + move_x
        y = y + move_y
        
        let imgFrame = self.sp_imgFrame()
        
        if x < imgFrame.origin.x {
            x = imgFrame.origin.x
        }
        if y < imgFrame.origin.y {
            y = imgFrame.origin.y
        }
        
        if x + self.sp_width() > imgFrame.origin.x + imgFrame.size.width {
            x = imgFrame.origin.x + imgFrame.size.width - self.sp_width()
        }
        
        if y + self.sp_height() > imgFrame.origin.y + imgFrame.size.height {
            y = imgFrame.origin.y + imgFrame.size.height - self.sp_height()
        }
        let newFrame = CGRect(x: x, y: y, width: self.sp_width(), height: self.sp_height())
        self.frame = newFrame
        self.lastPoint = point
        
    }
    /// 获取图片的位置
    ///
    /// - Returns: 位置
    fileprivate func sp_imgFrame()->CGRect{
        guard let block = self.imgFrameBlock else {
            return CGRect.zero
        }
        return block()
    }
    fileprivate func sp_updateLayout(frame : CGRect){
        if self.superview != nil {
            self.snp.remakeConstraints { (maker) in
                maker.left.equalTo(frame.origin.x)
                maker.top.equalTo(frame.origin.y)
                maker.width.equalTo(frame.size.width)
                maker.height.equalTo(frame.size.height)
            }
        }
    }
    
}
