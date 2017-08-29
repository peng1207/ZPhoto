//
//  SPVideoScheduleView.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/13.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import SnapKit
// MARK: -- 进度view  主要用来切割视频的
class SPVideoScheduleView : UIView {
    fileprivate let maxSpace : CGFloat = 20.00
    var assert : AVAsset?
    // 左边拖动的view
    lazy var leftPanView : UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = UIColor.red
        view.isUserInteractionEnabled = true
        return view
    }()
    // 右边拖动的view
    lazy var rightPanView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = UIColor.red
        view.isUserInteractionEnabled = true
        return view
    }()
    // 左边拖动后显示遮盖view
   lazy var leftShowView : UIView! = { return SPVideoScheduleView.getView() }()
    //  右边拖动后显示遮盖view
   lazy var rightShowView : UIView! = { return  SPVideoScheduleView.getView() }()
    // 左边拖动的手势
    var leftPanGuest : UIPanGestureRecognizer!
    // 右边拖动的手势
    var rightPanGues : UIPanGestureRecognizer!
    var leftConstraint:Constraint?
    var rightConstraint:Constraint?
    var lastright_X : CGFloat = 0.00
    var lastleft_X : CGFloat = 0.00
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.addAction()
    }
    
    
    fileprivate class func getView()-> UIView{
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: -- UI
extension SPVideoScheduleView {
    /**< 创建UI  */
    fileprivate func setupUI(){
        self.addSubview(self.leftPanView)
        self.addSubview(self.rightPanView)
        self.addSubview(self.leftShowView)
        self.addSubview(self.rightShowView)
        self.addConstraintView()
    }
    private func addConstraintView(){
        self.leftPanView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self).offset(0)
         self.leftConstraint = make.left.equalTo(self).offset(5).constraint
            make.width.equalTo(12)
        }
        self.rightPanView.snp.makeConstraints { (make) in
           make.top.bottom.equalTo(self).offset(0)
            make.width.equalTo(self.leftPanView.snp.width).offset(0);
           self.rightConstraint = make.right.equalTo(self.snp.right).offset(-5).constraint
        }
        self.leftShowView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self.leftPanView.snp.left).offset(0)
            make.top.bottom.equalTo(self).offset(0)
            
        }
        self.rightShowView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.top.bottom.equalTo(self).offset(0)
            make.left.equalTo(self.rightPanView.snp.right).offset(0)
        }
        
    }
    
}
// MARK: -- action
extension SPVideoScheduleView {
    /**< 添加事件 */
    fileprivate func addAction(){
        self.leftPanGuest = UIPanGestureRecognizer(target: self, action: #selector(leftAction(panGesture:)))
        self.rightPanGues = UIPanGestureRecognizer(target: self, action: #selector(rightAction(panGesture:)))
        self.leftPanView.addGestureRecognizer(self.leftPanGuest)
        self.rightPanView.addGestureRecognizer(self.rightPanGues)
    }
    /**< 左边滑动事件  */
    @objc fileprivate func  leftAction(panGesture : UIPanGestureRecognizer) {
        if panGesture.state == .began {
            lastleft_X = 0.00
        }
        let point = panGesture.translation(in: panGesture.view)
        var x = point.x - lastleft_X
        x = self.leftPanView.frame.origin.x + x
        
        if self.rightPanView.sp_x() - x - self.leftPanView.sp_width() < maxSpace{
            x = self.rightPanView.sp_x() - self.leftPanView.sp_width() - maxSpace
        }
        if x < 5 {
            x = 5
        }
        lastleft_X = point.x
        self.leftConstraint?.update(offset: x)
    }
    /**< 右边滑动事件 */
    @objc fileprivate func rightAction(panGesture : UIPanGestureRecognizer) {
        if panGesture.state == .began {
            lastright_X = 0
        }
        let point = panGesture.translation(in: panGesture.view)
        var x = point.x - lastright_X
        x =  -(self.sp_width() - self.rightPanView.sp_MaxX()) + x
        if self.sp_width() - (-x + self.rightPanView.sp_width()) - self.leftPanView.sp_MaxX() < maxSpace {
            x = -(self.sp_width() - self.leftPanView.sp_MaxX() - maxSpace - self.rightPanView.sp_width())
        }
        if x > -5 {
            x = -5
        }
        lastright_X = point.x
        self.rightConstraint?.update(offset: x)
    }
    
}

