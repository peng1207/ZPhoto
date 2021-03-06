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
import SPCommonLibrary
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
    fileprivate var space : SPSpace = (0,0,0,0)
    fileprivate var netRotation : CGFloat = 0//旋转
    fileprivate var lastScaleFactor : CGFloat! = 1  //放大、缩小
    fileprivate let minScale : CGFloat = 0.1 //  最小的缩放
    fileprivate let maxScale : CGFloat = 2.0
    
    /// 切割多边形的点
    var points : [CGPoint]?
    var layoutType : SPPictureLayoutType = .rectangle
    var canTap : Bool = false{
        didSet{
            self.sp_dealCanTap()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
       
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
                maker.width.greaterThanOrEqualTo(self.scrollView.snp.width).offset(0)
                maker.height.greaterThanOrEqualTo(self.scrollView.snp.height).offset(0)
            }else{
                maker.width.equalTo(self.scrollView.snp.width).offset(0)
                maker.height.equalTo(self.scrollView.snp.height).offset(0)
            }
        }
    }
    func sp_update(space : SPSpace){
        self.space = space
    }
    func sp_update(img:UIImage?){
        self.imgView.image = img
        sp_updateImgLayout()
        if let image = img {
            self.scrollView.contentSize = CGSize(width: image.size.width / SP_DEVICE_SCALE * 2.0, height: image.size.height / SP_DEVICE_SCALE * 2.0)
        }
    }
    func sp_update(filterImg : UIImage?){
        self.imgView.image = filterImg
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
        case .polygon(let type):
            sp_drawPolygon(type: type)
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
    fileprivate func sp_drawPolygon(type : SPPictureLayoutType.Polygon){
        sp_drawLayer(bezierPath: sp_getPolygonPath(type: type))
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
        sp_drawLayer(bezierPath: sp_getHeartPath())
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
        let minX = space.left
        let minY = space.top
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
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
        if sp_count(array:  self.points) > 0 {
            bezierPath.move(to: self.points![0])
            for index in 1..<sp_count(array:  self.points){
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
        
        let width = self.frame.size.width - space.right - space.left
        let height = self.frame.size.height - space.top - space.bottom
        let centerY = height / 2.0 + space.top
        let centerX = width / 2.0 + space.left
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
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
        return  UIBezierPath(ovalIn: CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY))
    }
    /// 获取菱形的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getDiamondPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
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
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
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
            sp_log(message: "")
        }
        return bezierPath
    }
    /// 获取多边形的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getPolygonPath(type : SPPictureLayoutType.Polygon)->UIBezierPath{
        let bezierPath = UIBezierPath()
        
        switch type {
        case .six:
            let w = (self.frame.size.width - space.left - space.right) / 2.0
            let centerY = self.frame.size.height  / 2.0
            let x = (self.frame.size.width - w) / 2.0
            bezierPath.move(to: CGPoint(x: x, y: space.top))
            bezierPath.addLine(to: CGPoint(x: space.left, y: centerY))
            bezierPath.addLine(to: CGPoint(x: x, y: self.frame.height - space.bottom))
            bezierPath.addLine(to: CGPoint(x: x + w, y: self.frame.height - space.bottom))
            bezierPath.addLine(to: CGPoint(x: self.frame.size.width - space.right, y: centerY))
            bezierPath.addLine(to: CGPoint(x: x + w, y: space.top))
            bezierPath.addLine(to: CGPoint(x: x, y: space.top))
        case .eight:
            let w = (self.frame.size.width - space.left - space.right) / 2.0
            let h = (self.frame.size.width - space.top - space.bottom) / 2.0
            let x = (self.frame.size.width - w) / 2.0
            let y =  (self.frame.size.height - h ) / 2.0
            let minX = space.left
            let minY = space.top
            let maxX = self.frame.size.width - space.right
            let maxY = self.frame.size.height - space.bottom
            bezierPath.move(to: CGPoint(x: x, y: minY))
            bezierPath.addLine(to: CGPoint(x: minX, y: y))
            bezierPath.addLine(to: CGPoint(x: minX, y: y + h))
            bezierPath.addLine(to: CGPoint(x: x, y: maxY))
            bezierPath.addLine(to: CGPoint(x: x + w, y: maxY))
            bezierPath.addLine(to: CGPoint(x: maxX, y: y + h))
            bezierPath.addLine(to: CGPoint(x: maxX, y: y))
            bezierPath.addLine(to: CGPoint(x: x + w, y: minY))
            bezierPath.addLine(to: CGPoint(x: x, y: minY))
        default:
            sp_log(message: "")
        }
        
        return bezierPath
    }
    /// 获取矩形 中带用圆角 圆形朝内的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getRectangleCornerInnerPath()->UIBezierPath{
        let bezizerPath = UIBezierPath()
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
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
            let radius = self.frame.size.height - space.top - space.bottom
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: maxY), radius: radius, startAngle: CGFloat.pi * 1.5 , endAngle: CGFloat.pi * 1.0, clockwise: false)
            bezizerPath.move(to: CGPoint(x: minX , y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: minY))
        case .rectangleCornerInner(type: .left_bottom):
            let radius = self.frame.size.height - space.top - space.bottom
            bezizerPath.addArc(withCenter: CGPoint(x: minX + radius, y: minY), radius: radius, startAngle: CGFloat.pi * 1.0, endAngle: CGFloat.pi * 0.5, clockwise: false)
            bezizerPath.move(to: CGPoint(x: minX + radius, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX , y: minY))
        case .rectangleCornerInner(type: .right_top):
            let radius = self.frame.size.height - space.top - space.bottom
            bezizerPath.addArc(withCenter: CGPoint(x: maxX - radius, y: maxY), radius: radius, startAngle: CGFloat.pi * 2.0, endAngle: CGFloat.pi * 1.5, clockwise: false)
            bezizerPath.move(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX , y: maxY))
        case .rectangleCornerInner(type: .right_bottom):
            let radius = self.frame.size.height - space.top - space.bottom
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
            sp_log(message: "")
        }
        
        return bezizerPath
    }
    /// 获取矩形 中带有圆角 圆形朝外的路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getRectangleCornerPath(type : SPPictureLayoutType.RectangleCorner , radiusValue : CGFloat)->UIBezierPath{
        let bezizerPath = UIBezierPath()
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
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
                radius = self.frame.size.height - space.top - space.bottom
            }
            
            bezizerPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 0.5 , clockwise: true)
            
            bezizerPath.move(to: CGPoint(x: minX, y: space.top + radius))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX + radius, y: minY))
            
        case .left_bottom:
            if radius == 0{
                radius = self.frame.size.height - space.top - space.bottom
            }
            bezizerPath.addArc(withCenter: CGPoint(x: minX, y: maxY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2.0, clockwise: true)
            
            bezizerPath.move(to: CGPoint(x: minX + radius, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY - radius))
        case .right_top:
            if radius == 0 {
                radius = self.frame.size.height - space.top - space.bottom
            }
            
            bezizerPath.addArc(withCenter: CGPoint(x: maxX, y: minY), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.0, clockwise: true)
            bezizerPath.move(to: CGPoint(x: maxX - radius, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: minY))
            bezizerPath.addLine(to: CGPoint(x: minX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: maxY))
            bezizerPath.addLine(to: CGPoint(x: maxX, y: minY + radius))
        case .right_bottom:
            if radius == 0 {
                radius = self.frame.size.height - space.top - space.bottom
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
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        switch self.layoutType {
        case .gear(type: .corner):
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        case .gear(type: .triangle):
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        default:
            sp_log(message: "")
        }
        return bezierPath
    }
    /// 获取心形路径
    ///
    /// - Returns: 路径
    fileprivate func sp_getHeartPath()->UIBezierPath{
        let bezierPath = UIBezierPath()
        let maxX = self.frame.size.width - space.right
        let maxY = self.frame.size.height - space.bottom
        let minX = space.left
        let minY = space.top
        let centerY = self.frame.size.height / 2.0
        let centerX = self.frame.size.width / 2.0
        
        let startY = self.frame.size.height / 5.0
        
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
        
        let maxY = self.frame.size.height - space.bottom
        
        let minY = space.top
        let centerX = self.frame.size.width / 2.0
        let startPoint = CGPoint(x: centerX, y: minY)
        let endPoint = CGPoint(x: centerX, y: maxY)
        bezierPath.move(to: startPoint)
        bezierPath.addQuadCurve(to: endPoint, controlPoint: CGPoint(x: -endPoint.x + space.left * 2.0, y: endPoint.y))
        bezierPath.move(to: endPoint)
        bezierPath.addQuadCurve(to: startPoint, controlPoint:  CGPoint(x: self.frame.size.width + endPoint.x - space.right * 2.0, y:endPoint.y))
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        return bezierPath
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.canTap == false {
            return nil
        }
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
    fileprivate func sp_dealCanTap(){
        if self.canTap {
            sp_addGesture()
        }else{
            
        }
    }
    
    fileprivate func sp_addGesture(){
        // 点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
//         旋转手势
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(sp_handleRotateGesture(sender:)))
        self.addGestureRecognizer(rotateGesture)
        // 缩放手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(sp_handlePinchGesture(sender:)))
        self.addGestureRecognizer(pinchGesture)
    }
    
    
    @objc fileprivate func sp_clickTap(){
        sp_log(message: "点击view")
    }
    @objc fileprivate func sp_handleRotateGesture(sender : UIRotationGestureRecognizer){
        //浮点类型，得到sender的旋转度数
        let rotation : CGFloat = sender.rotation
        //旋转角度CGAffineTransformMakeRotation,改变图像角度
        
        var transform = CGAffineTransform(rotationAngle: rotation+netRotation)
        transform = transform.scaledBy(x: lastScaleFactor, y: lastScaleFactor)
        imgView.transform = transform
        //状态结束，保存数据
        if sender.state == UIGestureRecognizer.State.ended{
            netRotation += rotation
        }
        
    }
    @objc fileprivate func sp_handlePinchGesture(sender:UIPinchGestureRecognizer){
        var factor = sender.scale
        var transform : CGAffineTransform!
        if factor > 1{
            //图片放大
            if factor > maxScale {
                factor = maxScale
            }
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
        if sender.state == UIGestureRecognizer.State.ended{
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
