//
//  SPMainView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/27.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
/// 设置五边形顶角的位置
///
/// - top: 上
/// - bottom: 下
/// - left: 左
/// - right: 右
enum SPPentagonCorners : Int {
    case top            //角 上
    case bottom         //角 下
    case left           //角 左
    case right          //角 右
}

class SPPentagonView:  UIView{
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_fontSize(fontSize:  15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    var clickBlock : SPBtnComplete?
    
    var corners : SPPentagonCorners = .right
    var fillColor : UIColor?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let pathPag = UIBezierPath()
        let space = sp_width()/4.0
        switch self.corners {
        case .right:
            pathPag.move(to: CGPoint(x: 0, y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width() - space, y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: sp_height()/2.0))
          
            pathPag.addLine(to: CGPoint(x: sp_width() - space, y: sp_height()))
            pathPag.addLine(to: CGPoint(x: 0, y: sp_height()))
        case .left:
            pathPag.move(to: CGPoint(x: space, y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: sp_height()))
            pathPag.addLine(to: CGPoint(x: space, y: sp_height()))
            pathPag.addLine(to: CGPoint(x: 0, y: sp_height()/2.0))
        case .top:
            pathPag.move(to: CGPoint(x: 0, y: space))
            pathPag.addLine(to: CGPoint(x: sp_width() / 2.0, y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: space))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: sp_height()))
            pathPag.addLine(to: CGPoint(x: 0, y: sp_height()))
        case .bottom:
            pathPag.move(to: CGPoint(x: 0, y: 0 ))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: 0))
            pathPag.addLine(to: CGPoint(x: sp_width(), y: sp_height() - space))
            pathPag.addLine(to: CGPoint(x: sp_width()/2.0, y: sp_height()))
            pathPag.addLine(to: CGPoint(x: 0, y: sp_height() - space))
            
        }
        if let color = self.fillColor {
            color.set()
        }else{
           sp_getMianColor().set()
        }
        pathPag.close()
        pathPag.fill()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
extension SPPentagonView {
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
}
