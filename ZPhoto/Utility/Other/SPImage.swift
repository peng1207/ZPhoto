//
//  SPImage.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    /// 颜色值转图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    class func sp_getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
