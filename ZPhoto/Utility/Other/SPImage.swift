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
    /// view 转换成图片
    ///
    /// - Parameter view: 需要转换的view
    /// - Returns: 图片
    class func sp_img(of view : UIView)->UIImage?{
        let saveFrame = view.frame
        var saveContentOffset : CGPoint = CGPoint.zero
        var isScroll = false
        if view is UIScrollView {
            isScroll = true
        }
        /// 若view 是scrollview 则生成图片为 contentSize
        if isScroll , let scrollView = view as? UIScrollView {
            UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
            saveContentOffset = scrollView.contentOffset
            scrollView.contentOffset = CGPoint.zero
            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        }else{
              UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        }
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        if isScroll {
            view.frame = saveFrame
            (view as! UIScrollView).contentOffset = saveContentOffset
        }
        UIGraphicsEndImageContext()
        return img
    }
    
}
