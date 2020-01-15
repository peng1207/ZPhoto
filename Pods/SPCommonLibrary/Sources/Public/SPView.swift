//
//  SPView.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/7/27.
//

import Foundation
import UIKit
import SnapKit
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
    
    /// 截图
    func sp_screenShot() -> UIImage? {
        
        guard bounds.size.height > 0 && bounds.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        
        // Renders a snapshot of the complete view hierarchy as visible onscreen into the current context.
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)  // 高清截图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    /// view转图片
    func sp_image()->UIImage?{
        let view = self
        let saveFrame = view.frame
        var saveContentOffset : CGPoint = CGPoint.zero
        var isScroll = false
        if view is UIScrollView {
            isScroll = true
        }
        var viewSize : CGRect = view.bounds
        /// 若view 是scrollview 则生成图片为 contentSize
        if isScroll , let scrollView = view as? UIScrollView {
            viewSize = CGRect(origin: CGPoint.zero, size: scrollView.contentSize)
            if viewSize.size.width == 0 {
                viewSize = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.size.width, height: scrollView.contentSize.height))
            }
            if viewSize.size.height == 0 {
                viewSize = CGRect(origin: CGPoint.zero, size: CGSize(width: viewSize.size.width, height: view.frame.size.height))
            }
            
            saveContentOffset = scrollView.contentOffset
            scrollView.contentOffset = CGPoint.zero
            scrollView.frame = CGRect(x: 0, y: 0, width: viewSize.size.width, height:viewSize.size.height)
            view.snp.remakeConstraints { (maker) in
                maker.left.top.equalTo(0)
                maker.width.equalTo(viewSize.size.width)
                maker.height.equalTo(viewSize.size.height)
            }
            UIGraphicsBeginImageContextWithOptions(viewSize.size, false, UIScreen.main.scale)
            
        }else{
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }else{
            view.drawHierarchy(in: viewSize, afterScreenUpdates: true) // 高清截图
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        if isScroll {
            view.frame = saveFrame
            view.snp.remakeConstraints { (maker) in
                maker.left.equalTo(saveFrame.origin.x)
                maker.top.equalTo(saveFrame.origin.y)
                maker.width.equalTo(saveFrame.size.width)
                maker.height.equalTo(saveFrame.size.height)
            }
            (view as! UIScrollView).contentOffset = saveContentOffset
        }
        UIGraphicsEndImageContext()
        return img
    }
    /// 修改view的喵点 防止修改之后view移动
    /// - Parameter anchorpoint: 喵点位置
    func sp_anchorPoint(anchorpoint : CGPoint){
        let oldFrame = self.frame
        self.layer.anchorPoint = anchorpoint
        self.frame = oldFrame
    }
    
}
