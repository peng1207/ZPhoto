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
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    var boderColor : UIColor = UIColor.white
    var leftBoder : CGFloat = 2.0
    var rightBoder : CGFloat = 2.0
    var topBoder : CGFloat = 2.0
    var bottomBoder : CGFloat = 2.0
    
    fileprivate var netRotation : CGFloat = 0//旋转
    fileprivate var lastScaleFactor : CGFloat! = 1  //放大、缩小
    fileprivate let minScale : CGFloat = 0.1 //  最小的缩放
    /// 切割多边形的点
    var points : [CGPoint]?
    var layoutType : SPPictureLayoutType = .rectangle
    
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
        self.imgView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(0)
            maker.top.equalTo(self.scrollView.snp.top).offset(0)
            if let img = self.imgView.image {
                maker.width.equalTo(img.size.width / SP_DEVICE_SCALE)
                maker.height.equalTo(img.size.height / SP_DEVICE_SCALE)
            }else{
                maker.width.equalTo(self.scrollView.snp.width).offset(0)
                maker.height.equalTo(self.scrollView.snp.height).offset(0)
            }
        }
    }
    func sp_update(left:CGFloat = 2.0,top:CGFloat = 2.0,right : CGFloat = 2.0, bottom : CGFloat
        = 2.0){
        self.leftBoder = left
        self.rightBoder = right
        self.topBoder = top
        self.bottomBoder = bottom
    }
    func sp_update(img:UIImage?){
        self.imgView.image = img
        sp_updateImgLayout()
        if let image = img {
            self.scrollView.contentSize = CGSize(width: image.size.width / SP_DEVICE_SCALE, height: image.size.height / SP_DEVICE_SCALE)
        }
    }
    
    func sp_drawMaskLayer(){
        
        switch self.layoutType {
        case .circular:
            sp_drawCorner()
        case .diamond:
            sp_drawDiamond()
        case .ellipse:
            sp_drawEllipse()
        case .triangle(_):
            sp_drawTriangle()
        case .rectangleCorner(let type,let radius):
            sp_drawRectangleCorner(type: type, radius: CGFloat(radius))
        case .rectangleCornerInner(_):
            sp_drawRectangleCornerInner()
        case .polygon(_):
            sp_drawPolygon()
        case .heart:
            sp_drawHeart()
        case .waterDrop:
            sp_drawWaterDrop()
        case .point:
            sp_drawPoint()
        default:
            sp_drawDefault()
        }
    }
    /// 根据point画图
    fileprivate func sp_drawPoint(){
        sp_drawLayer(bezierPath: sp_getPointPath())
    }
    fileprivate func sp_drawDefault(){
        sp_drawLayer(bezierPath: sp_getDefaultPath())
    }
    /// 画圆
    fileprivate func sp_drawCorner(){
        self.sp_drawLayer(bezierPath: self.sp_getCornerPath())
    }
    ///  画椭圆
    fileprivate func sp_drawEllipse(){
        sp_drawLayer(bezierPath: sp_getEllipsePath())
    }
    /// 画菱形
    fileprivate func sp_drawDiamond(){
        sp_drawLayer(bezierPath: sp_getDiamondPath())
    }
    /// 画三角形
    fileprivate func sp_drawTriangle(){
        sp_drawLayer(bezierPath: sp_getTrianglePath())
    }
    /// 画多边形
    fileprivate func sp_drawPolygon(){
        sp_drawLayer(bezierPath: sp_getPolygonPath())
    }
    /// 画矩形 中带用圆角 圆形朝内
    fileprivate func sp_drawRectangleCornerInner(){
        sp_drawLayer(bezierPath: sp_getRectangleCornerInnerPath())
    }
    /// 画矩形 中带有圆角 圆形朝外
    fileprivate func sp_drawRectangleCorner(type : SPPictureLayoutType.RectangleCorner , radius : CGFloat){
        sp_drawLayer(bezierPath: sp_getRectangleCornerPath(type: type, radiusValue:radius))
    }
    /// 画齿轮
    fileprivate func sp_drawGear(){
        sp_drawLayer(bezierPath: sp_getGearPath())
    }
    /// 画心形
    fileprivate func sp_drawHeart(){
        sp_drawLayer(bezierPath: sp_getHeartPatg())
    }
    /// 画水滴
    fileprivate func sp_drawWaterDrop(){
        sp_drawLayer(bezierPath: sp_getWaterDropPath())
    }
    /// 画layer
    ///
    /// - Parameter bezierPath: 路径
    fileprivate func sp_drawLayer(bezierPath : UIBezierPath){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    fileprivate func sp_getDefaultPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let minX = self.leftBoder
        let minY = self.topBoder
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        bezierPath.move(to: CGPoint(x: minX, y: minY))
        bezierPath.addLine(to: CGPoint(x: minX, y: maxY))
        bezierPath.addLine(to: CGPoint(x: maxX, y: maxY))
        bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
        bezierPath.addLine(to: CGPoint(x: minX, y: minY))
        return bezierPath
    }
    /// 获取点的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getPointPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        if sp_getArrayCount(array: self.points) > 0 {
            bezierPath.move(to: self.points![0])
            for index in 1..<sp_getArrayCount(array: self.points){
                bezierPath.addLine(to: self.points![index])
            }
            bezierPath.addLine(to: self.points![0])
        }
        return bezierPath
    }
    /// 获取圆的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getCornerPath()->UIBezierPath{
        var radius : CGFloat = 0
        
        let width = self.frame.size.width - self.rightBoder - self.leftBoder
        let height = self.frame.size.height - self.topBoder - self.bottomBoder
        let centerY = height / 2.0 + self.topBoder
        let centerX = width / 2.0 + self.leftBoder
        if width > height {
            radius = height / 2.0
        }else{
            radius = width / 2.0
        }
        
        return  UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle:CGFloat.pi * 2.0, clockwise: true)
    }
    /// 获取椭圆的路径
    ///
    /// - Returns: j路径
    fileprivate func sp_getEllipsePath()->UIBezierPath{
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        return  UIBezierPath(ovalIn: CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY))
    }
    /// 获取菱形的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getDiamondPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        bezierPath.move(to: CGPoint(x: centerX, y: minY))
        bezierPath.addLine(to: CGPoint(x: maxX, y: centerY))
        bezierPath.addLine(to: CGPoint(x: centerX, y: maxY))
        bezierPath.addLine(to: CGPoint(x: minX, y: centerY))
        bezierPath.addLine(to: CGPoint(x: centerX, y: minY))
        return bezierPath
    }
    /// 获取三角形的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getTrianglePath()->UIBezierPath{
        let  bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        switch self.layoutType {
        case .triangle(triangle:  .left):
            bezierPath.move(to: CGPoint(x: minX, y: centerY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y:maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: centerY))
            
        case .triangle(triangle:  .top):
            bezierPath.move(to: CGPoint(x: centerX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y:maxY))
            bezierPath.addLine(to: CGPoint(x: centerX, y: minY))
            
        case .triangle(triangle:  .right):
            bezierPath.move(to: CGPoint(x: maxX, y: centerY))
            bezierPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: centerY))
        case .triangle(triangle:  .bottom):
            bezierPath.move(to: CGPoint(x: centerX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezierPath.addLine(to: CGPoint(x: centerX, y: maxY))
        case .triangle(triangle:  .left_bottom):
            bezierPath.move(to: CGPoint(x: minX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: minY))
        case .triangle(triangle:  .right_top):
            bezierPath.move(to: CGPoint(x: maxX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
        case .triangle(triangle:  .left_top):
            bezierPath.move(to: CGPoint(x: minX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezierPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: minY))
        case .triangle(triangle:  .right_bottom):
            bezierPath.move(to: CGPoint(x: maxX, y: minY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: minY))
        default:
            SPLog("")
        }
        return bezierPath
    }
    /// 获取多边形的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getPolygonPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        return bezierPath
    }
    /// 获取矩形 中带用圆角 圆形朝内的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getRectangleCornerInnerPath()->UIBezierPath{
        let bezizerPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        switch self.layoutType {
        case .rectangleCornerInner(type: .left):
            let radius = centerY
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: centerY), radius: radius, startAngle: CGFloat.pi * 0.5 , endAngle: CGFloat.pi * 1.5, clockwise: true)
            bezizerPath.move(to: CGPoint(x: minX + radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: maxY))
        case .rectangleCornerInner(type: .right):
            let radius = centerY
            bezizerPath.addArc(withCenter: CGPoint(x: maxX - radius, y: centerY), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.5, clockwise: false)
            bezizerPath.move(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX - radius, y: maxY))
        case .rectangleCornerInner(type: .top):
            let radius = centerX
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: minY + radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2.0, clockwise: true)
            bezizerPath.move(to: CGPoint(x: minX, y: minY + radius))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY + radius))
        case .rectangleCornerInner(type: .bottom):
            let radius = centerX
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: maxY - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX, y: maxY - radius))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY - radius))
        case .rectangleCornerInner(type: .left_top):
            let radius = self.frame.size.height - self.topBoder - self.bottomBoder
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: maxY), radius: radius, startAngle: CGFloat.pi * 1.5 , endAngle: CGFloat.pi * 1.0, clockwise: false)
            bezizerPath.move(to: CGPoint(x: minX , y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: minY))
        case .rectangleCornerInner(type: .left_bottom):
            let radius = self.frame.size.height - self.topBoder - self.bottomBoder
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: minY), radius: radius, startAngle: CGFloat.pi * 1.0, endAngle: CGFloat.pi * 0.5, clockwise: false)
            bezizerPath.move(to: CGPoint(x: minX + radius, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX , y: minY))
        case .rectangleCornerInner(type: .right_top):
            let radius = self.frame.size.height - self.topBoder - self.bottomBoder
            bezizerPath.addArc(withCenter: CGPoint(x: maxX - radius, y: maxY), radius: radius, startAngle: CGFloat.pi * 2.0, endAngle: CGFloat.pi * 1.5, clockwise: false)
            bezizerPath.move(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX , y: maxY))
        case .rectangleCornerInner(type: .right_bottom):
            let radius = self.frame.size.height - self.topBoder - self.bottomBoder
            bezizerPath.addArc(withCenter: CGPoint(x: maxX - radius, y: minY), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0, clockwise: false)
            bezizerPath.move(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX - radius, y: maxY))
        case .rectangleCornerInner(type: .horizontal):
            let radius = centerY
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: centerY), radius: radius, startAngle: CGFloat.pi * 0.5 , endAngle: CGFloat.pi * 1.5, clockwise: true)
            bezizerPath.move(to: CGPoint(x: minX + radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addArc(withCenter: CGPoint(x: maxX - radius, y: centerY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 0.5, clockwise: true)
            bezizerPath.addLine(to: CGPoint(x: maxX - radius, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: maxY))
        case .rectangleCornerInner(type: .vertical):
            let radius = centerX
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: minY + radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2.0, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX, y: minY + radius))
            bezizerPath.addLine(to: CGPoint(x: maxY, y: maxY - radius))
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: maxY - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY - radius))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY + radius))
            
        default:
            SPLog("")
        }
        
        return bezizerPath
    }
    /// 获取矩形 中带有圆角 圆形朝外的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getRectangleCornerPath(type : SPPictureLayoutType.RectangleCorner , radiusValue : CGFloat)->UIBezierPath{
        let bezizerPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        var radius : CGFloat = radiusValue
        
        
        switch type {
        case .left:
            if radius == 0 {
                radius = centerY
            }
            bezizerPath.addArc(withCenter: CGPoint(x: minX, y: centerY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 0.5, clockwise: true)
            if radiusValue > 0   {
                bezizerPath.move(to: CGPoint(x: minX, y: centerY + radiusValue))
                bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            }else{
                bezizerPath.move(to: CGPoint(x: minX, y: maxY))
            }
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            if radiusValue > 0{
                bezizerPath.addLine(to: CGPoint(x: minX, y: centerY - radiusValue))
            }
            
        case .right:
            if radius == 0 {
                radius = centerY
            }
            bezizerPath.addArc(withCenter: CGPoint(x: maxX, y: centerY), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)
            bezizerPath.move(to: CGPoint(x:maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
        case .top:
            if radius == 0 {
                radius = centerX
            }
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: minY), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat.pi, clockwise: true)
            bezizerPath.move(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
        case .bottom:
            if radius == 0{
                radius = centerX
            }
            bezizerPath.addArc(withCenter: CGPoint(x: centerX, y: maxY), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2.0, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
        case .left_top:
            if radius == 0 {
                radius = self.frame.size.height - self.topBoder - self.bottomBoder
            }
            
            bezizerPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 0.5 , clockwise: true)
            
            bezizerPath.move(to: CGPoint(x: minX, y: self.topBoder + radius))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: minY))
            
        case .left_bottom:
            if radius == 0{
                radius = self.frame.size.height - self.topBoder - self.bottomBoder
            }
            bezizerPath.addArc(withCenter: CGPoint(x: minX, y: maxY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2.0, clockwise: true)
            
            bezizerPath.move(to: CGPoint(x: minX + radius, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY - radius))
        case .right_top:
            if radius == 0 {
                radius = self.frame.size.height - self.topBoder - self.bottomBoder
            }
            
            bezizerPath.addArc(withCenter: CGPoint(x: maxX, y: minY), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.0, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY + radius))
        case .right_bottom:
            if radius == 0 {
                radius = self.frame.size.height - self.topBoder - self.bottomBoder
            }
            bezizerPath.addArc(withCenter: CGPoint(x: maxX, y: maxY), radius: radius, startAngle: CGFloat.pi * 1.0, endAngle: CGFloat.pi * 1.5, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX, y: maxY - radius))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX - radius, y: maxY))
        }
        return bezizerPath
    }
    /// 获取齿轮的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getGearPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        switch self.layoutType {
        case .gear(type: .corner):
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        case .gear(type: .triangle):
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        default:
            SPLog("")
        }
        return bezierPath
    }
    /// 获取心形路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getHeartPatg()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - self.rightBoder
        let maxY = self.frame.size.height - self.bottomBoder
        let minX = self.leftBoder
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        
        let startY = self.frame.size.height / 3.0
        
        let startPoint = CGPoint(x: centerX, y:  startY)
        let endPoint = CGPoint(x: centerX, y: maxY)
        bezierPath.move(to: startPoint)
        bezierPath.addCurve(to: endPoint, controlPoint1: CGPoint(x: minX, y: minY ), controlPoint2: CGPoint(x: 0, y: centerY + startY))
        bezierPath.move(to: endPoint)
        bezierPath.addCurve(to: startPoint, controlPoint1: CGPoint(x: self.frame.size.width, y: centerY + startY), controlPoint2: CGPoint(x: maxX, y: minY ))
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        
        return bezierPath
    }
    /// 获取水滴路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getWaterDropPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        
        let maxY = self.frame.size.height - self.bottomBoder
        
        let minY = self.topBoder
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        let startX = self.frame.size.width / 4.0
        let startPoint = CGPoint(x: centerX, y: minY)
        let endPoint = CGPoint(x: centerX, y: maxY)
        bezierPath.move(to: startPoint)
        bezierPath.addCurve(to: endPoint, controlPoint1: CGPoint(x: 0, y: centerX), controlPoint2: CGPoint(x: startX, y: maxY))
        bezierPath.move(to: endPoint)
        bezierPath.addCurve(to: startPoint, controlPoint1: CGPoint(x:  startX + centerX, y: maxY), controlPoint2: CGPoint(x: self.frame.size.width, y: centerY))
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        return bezierPath
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
        
        var transform = CGAffineTransform(rotationAngle: rotation+netRotation)
        transform = transform.scaledBy(x: lastScaleFactor, y: lastScaleFactor)
        imgView.transform = transform
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
