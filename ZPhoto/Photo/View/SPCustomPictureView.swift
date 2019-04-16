//
//  SPCustomPictureView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/4/10.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCustomPictureView:  UIView,UIScrollViewDelegate{
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    var boder : CGFloat = 5.0 {
        didSet{
            self.sp_updateImgLayout()
            self.sp_setLayerBorder()
        }
    }
    var boderColor : UIColor = UIColor.white {
        didSet{
            self.sp_setLayerBorder()
        }
    }
    var netRotation : CGFloat = 0;//旋转
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
    fileprivate let minScale : CGFloat = 0.1
    /// 切割多边形的点
    var points : [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_setLayerBorder()
        sp_addGesture()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setLayerBorder(){
        self.layer.borderWidth = self.boder
        self.layer.borderColor = self.boderColor.cgColor
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
 
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imgView)
        self.sp_addConstraint()
       
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        sp_updateImgLayout()
    }
    fileprivate func sp_updateImgLayout(){
        guard self.imgView.superview != nil else {
            return
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(boder)
            maker.top.equalTo(self.scrollView.snp.top).offset(boder)
            maker.width.equalTo(self.scrollView.snp.width).offset(-2 * boder)
            maker.height.equalTo(self.scrollView.snp.height).offset(-2 * boder)
        }
    }
    
    func sp_drawMaskLayer(){
        guard (points != nil) else {
            return
        }
        let bezierPath1 = UIBezierPath()
        bezierPath1.move(to: points![0])
        for index in 1..<points!.count {
              bezierPath1.addLine(to: points![index])
        }
           bezierPath1.addLine(to: points![0])
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath1.cgPath
        self.layer.mask = shapeLayer
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if points != nil {
            if (super.hitTest(point, with: event) == scrollView){
                print(self,point)
                print(points!)
                let isInner = sp_isInnerView(with: point)
                if isInner {
                    return self.scrollView
                }else {
                    return nil
                }
            }
        }else{
            return super.hitTest(point, with: event)
        }
        return nil
    }
    /// 判断点是否在多边形内部（射线法）
    /// 参考链接：http://www.html-js.com/article/1528
    /// - Parameter point: 点位置
    /// - Returns: 是否在内部
    fileprivate func sp_isInnerView(with point: CGPoint) -> Bool {
        let pX = point.x , pY = point.y
        var flag = false
        
        var oldIndex = points!.count - 1
        for newIndex in 0..<points!.count {
            let newX = points![newIndex].x
            let newY = points![newIndex].y
            let oldX = points![oldIndex].x
            let oldY = points![oldIndex].y
            
            // 点与多边形顶点重合
            if (pX == newX && pY == newY) || (pX == oldX && pY == oldY) {
                return false
            }
            
            // 判断线段两端点是否在射线两侧
            if (oldY > pY && newY < pY) || (oldY < pY && newY > pY) {
                // 线段上与射线 Y 坐标相同的点的 X 坐标
                let x = newX + (pY - newY) * (oldX - newX) / (oldY - newY)
                
                // 点在多边形的边上
                if(x == pX) {
                    return false
                }
                
                // 射线穿过多边形的边界
                if(x > pX) {
                    flag = !flag
                }
            }
            oldIndex = newIndex
        }
        // 射线穿过多边形边界的次数为奇数时点在多边形内
        return flag ? true : false
    }
    deinit {
        
    }
}
extension SPCustomPictureView {
    
    fileprivate func sp_addGesture(){
        // 点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
        // 旋转手势
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(sp_handleRotateGesture(sender:)))
        self.addGestureRecognizer(rotateGesture)
        // 缩放手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(sp_handlePinchGesture(sender:)))
        self.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc fileprivate func sp_clickTap(){
        SPLog("点击view")
    }
    @objc fileprivate func sp_handleRotateGesture(sender : UIRotationGestureRecognizer){
        //浮点类型，得到sender的旋转度数
        let rotation : CGFloat = sender.rotation
        //旋转角度CGAffineTransformMakeRotation,改变图像角度
        SPLog(rotation)
        var transform = CGAffineTransform(rotationAngle: rotation+netRotation)
        transform = transform.scaledBy(x: lastScaleFactor, y: lastScaleFactor)
        imgView.transform = transform
//        imgView.transform = CGAffineTransform(rotationAngle: rotation+netRotation)
        //状态结束，保存数据
        if sender.state == UIGestureRecognizerState.ended{
            netRotation += rotation
        }
        
    }
    @objc fileprivate func sp_handlePinchGesture(sender:UIPinchGestureRecognizer){
        let factor = sender.scale
        var transform : CGAffineTransform!
        if factor > 1{
            //图片放大
           transform = CGAffineTransform(scaleX: lastScaleFactor+factor-1, y: lastScaleFactor+factor-1)
        }else{
            //缩小
            var scale = lastScaleFactor*factor
            if scale < minScale {
                scale = minScale
            }
           transform = CGAffineTransform(scaleX: scale, y:scale)
        }
        transform = transform.rotated(by: netRotation)
        self.imgView.transform = transform
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.ended{
            if factor > 1{
                lastScaleFactor = lastScaleFactor + factor - 1
            }else{
                lastScaleFactor = lastScaleFactor * factor
                if lastScaleFactor < minScale {
                    lastScaleFactor = minScale
                }
            }
        }
        
    }
}
