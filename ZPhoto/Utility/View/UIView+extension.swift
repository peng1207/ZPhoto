//
//  UIView+extension.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/25.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    ///  获取x的坐标
    ///
    /// - Returns: 坐标
    func sp_x() -> CGFloat{
        return self.frame.origin.x
    }
    /// 获取 y的坐标
    ///
    /// - Returns: 坐标
    func sp_y() -> CGFloat{
        return self.frame.origin.y
    }
    /// 获取宽度
    ///
    /// - Returns: 宽度
    func sp_width() ->  CGFloat{
        return self.frame.size.width
    }
    /// 获取高度
    ///
    /// - Returns: 高度
    func sp_height() ->  CGFloat{
        return self.frame.size.height
    }
    /// 获取x最大的值
    ///
    /// - Returns: x坐标
    func sp_MaxX() -> CGFloat{
        return self.sp_x() + self.sp_width()
    }
    /// 获取y最大的值
    ///
    /// - Returns: y坐标
    func sp_MaxY() ->  CGFloat{
        return self.sp_y() + self.sp_height()
    }
    /// 设置圆角
    ///
    /// - Parameter cornerRadius: 圆角
    func sp_cornerRadius(cornerRadius : CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    
}

