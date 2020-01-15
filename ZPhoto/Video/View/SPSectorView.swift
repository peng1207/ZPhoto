//
//  SPSectorView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/12/24.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
/// 转盘中一个块
class SPSectorView:  UIView{
    fileprivate var shapeLayer : CAShapeLayer = CAShapeLayer()
    
    /// 扇形角度  大于0 小于等于180
    public var degress : CGFloat = 0{
        didSet{
            self.sp_setupPath()
        }
    }
    public var  rotationAngle : CGFloat = 0
    fileprivate var pointList : [CGPoint] = [CGPoint]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.layer.mask = self.shapeLayer
        self.sp_addConstraint()
    }
    fileprivate func sp_setupPath(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0 ))
        var radius = sp_height()
        if sp_height() != sp_width() {
            radius = sp_height() / 2.0
        }
        path.addArc(withCenter:  CGPoint(x: 0, y: radius), radius: radius, startAngle: sp_getRadians(to: -90), endAngle: sp_getRadians(to: degress - 90), clockwise: true)
        let newPoint = sp_getPoint(to: CGPoint(x: 0, y: radius), radius: radius, degress: degress)
        path.addLine(to: newPoint)
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addLine(to: CGPoint(x: 0, y: 0))
        self.shapeLayer.path = path.cgPath
        self.pointList.append(CGPoint(x: 0, y: 0))
        self.pointList.append(CGPoint(x: 0, y: sp_height()))
        self.pointList.append(newPoint)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sp_log(message: self.rotationAngle)
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (super.hitTest(point, with: event) == self){
            let isInner = sp_isInnerView(with: point)
            if isInner {
                return self
            }else {
                return nil
            }
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
        
        var oldIndex = pointList.count - 1
        for newIndex in 0..<pointList.count {
            let newX = pointList[newIndex].x
            let newY = pointList[newIndex].y
            let oldX = pointList[oldIndex].x
            let oldY = pointList[oldIndex].y
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
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
    
}
