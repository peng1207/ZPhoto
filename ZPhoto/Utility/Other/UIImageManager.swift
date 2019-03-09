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
    /// CIImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    class func convertCIImageToUIImage(ciImage:CIImage) -> UIImage {
        let uiImage = UIImage.init(ciImage: ciImage)
        // 注意！！！这里的uiImage的uiImage.cgImage 是nil
        // 注意！！！上面的cgImage是nil，原因如下，官方解释
        // returns underlying CGImageRef or nil if CIImage based
        return uiImage
    }
    
    // CGImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    // 原理同上
    class func convertCIImageToUIImage(cgImage:CGImage) -> UIImage {
        let uiImage = UIImage.init(cgImage: cgImage)
        // 注意！！！这里的uiImage的uiImage.ciImage 是nil
       
        // 注意！！！上面的ciImage是nil，原因如下，官方解释
        // returns underlying CIImage or nil if CGImageRef based
        return uiImage
    }
    // MARK:- convert the CGImageToCIImage
    /// convertCGImageToCIImage
    ///
    /// - Parameter cgImage: input cgImage
    /// - Returns: output CIImage
   class func convertCGImageToCIImage(cgImage:CGImage) -> CIImage{
        return CIImage.init(cgImage: cgImage)
    }
    
    // MARK:- convert the CIImageToCGImage
    /// convertCIImageToCGImage
    ///
    /// - Parameter ciImage: input ciImage
    /// - Returns: output CGImage
   class func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
        
        
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
    /// UIImage转为CIImage
    /// UIImage转CIImage有时候不能直接采用uiImage.ciImage获取
    /// 当uiImage.ciImage为nil的时候需要先通过uiImage.cgImage得到
    /// cgImage, 然后通过convertCGImageToCIImage将cgImage装换为ciImage
    class func convertUIImageToCIImage(uiImage:UIImage) -> CIImage {
        
        var ciImage = uiImage.ciImage
        if ciImage == nil {
            let cgImage = uiImage.cgImage
            
            ciImage = UIImage.convertCGImageToCIImage(cgImage: cgImage!)
        }
        return ciImage!
    }
    /// UIImage转为CGImage
    /// UIImage转CGImage有时候不能直接采用uiImage.cgImage获取
    /// 当uiImage.cgImage为nil的时候需要先通过uiImage.ciImage得到
    /// ciImage, 然后通过convertCIImageToCGImage将ciImage装换为cgImage
    class func convertUIImageToCGImage(uiImage:UIImage) -> CGImage {
        var cgImage = uiImage.cgImage
        
        if cgImage == nil {
            let ciImage = uiImage.ciImage
            cgImage = UIImage.convertCIImageToCGImage(ciImage: ciImage!)
        }
        return cgImage!
    }
    
}
