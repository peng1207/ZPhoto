//
//  SPView.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/7/27.
//

import Foundation
import UIKit


public extension UIView {
    
    /// 获取最小的x值
    ///
    /// - Returns: x坐标
    func sp_x() -> CGFloat {
        return self.frame.origin.x
    }
     /// 获取最小的y值
     ///
     /// - Returns: y坐标
     func sp_y() -> CGFloat {
        return self.frame.origin.y
    }
    /// 获取宽度
    ///
    /// - Returns: 宽度
    func sp_width() -> CGFloat {
        return self.frame.size.width
    }
    /// 获取高度
    ///
    /// - Returns: 高度
    func sp_height() -> CGFloat {
        return self.frame.size.height
    }
    /// 获取最大的x坐标
    ///
    /// - Returns: 坐标
    func sp_maxX() -> CGFloat {
        return sp_x() + sp_width()
    }
    /// 获取最大的y坐标
    ///
    /// - Returns: 坐标
    func sp_maxY() -> CGFloat{
        return sp_y() + sp_height()
    }
    /// 设置圆角
    ///
    /// - Parameter radius: 圆角半径
    func sp_cornerRadius(radius : CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    /// 设置边框
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框大小
    func sp_border(color : UIColor? , width :  CGFloat) {
        if let c = color {
            self.layer.borderColor = c.cgColor
        }else{
            self.layer.borderColor = nil
        }
        self.layer.borderWidth = width
    }
    
    
    
}
