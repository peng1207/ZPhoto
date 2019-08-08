//
//  SPImage.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func sp_image(color:UIColor,size : CGSize = CGSize(width: 1, height: 1)) ->UIImage?{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    class func sp_image(view : UIView)->UIImage?{
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
    /// 对视频图片或拍照图片进行处理 防止旋转不对
    ///
    /// - Parameter imgae: 需要处理的图片
    /// - Returns: 处理后的图片
    class func sp_picRotating(imgae:CIImage?) -> CIImage? {
        guard let outputImage = imgae else {
            return nil
        }
        let orientation = UIDevice.current.orientation
        var t: CGAffineTransform!
        if orientation == UIDeviceOrientation.portrait {
            t = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2.0))
        } else if orientation == UIDeviceOrientation.portraitUpsideDown {
            t = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))
        } else if (orientation == UIDeviceOrientation.landscapeRight) {
            t = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        } else {
            t = CGAffineTransform(rotationAngle: 0)
        }
        return  outputImage.transformed(by: t)
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg:UIImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->UIImage?{
        
        if text.count > 0 {
            let size = inputImg.size
            UIGraphicsBeginImageContext(size)
            inputImg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let textAttributes = [ NSAttributedString.Key.foregroundColor: textColor ,NSAttributedString.Key.font : font]
           
            let textSize = NSString(string: text).size(withAttributes: textAttributes)
            let textFrame = CGRect(x: point.x, y: point.y, width: textSize.width, height: textSize.height)
            NSString(string: text).draw(in: textFrame, withAttributes: textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }else{
            return inputImg
        }
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg : CIImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CIImage?{
        let image = UIImage(ciImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point: point)
        if let outImg = outputImg, let outCIImg = CIImage(image: outImg) {
            return outCIImg
        }
        return  inputImg
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg : CGImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CGImage?{
        let image = UIImage(cgImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point:point)
        if let outImg = outputImg, let outCGImg = outImg.cgImage {
            return outCGImg
        }
        return  inputImg
    }
}
