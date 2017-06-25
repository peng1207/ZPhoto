//
//  UIImageManager.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

extension  UIImage {
    /**< 根据颜色获取图片 */
    class func image(color:UIColor = UIColor.white,imageSize:CGSize = CGSize(width: 1.0, height: 1.0))->UIImage?{
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    /**< 对图片裁剪成圆形 */
    func circle() -> UIImage?{
        // 取出最短边长
        let shotset = min(self.size.width, self.size.height)
        // 输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotset, height: shotset)
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        // 添加圆形裁剪区域
        context?.addEllipse(in: outputRect)
        context?.clip()
        self.draw(in: CGRect(x: (shotset - self.size.width)/2, y: (shotset-self.size.height)/2, width: self.size.width, height: self.size.height))
        // 获取处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return maskedImage ?? nil
    }
}
