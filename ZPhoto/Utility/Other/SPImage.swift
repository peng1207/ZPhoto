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
    
    /// 人脸检测
    ///
    /// - Parameters:
    ///   - inputImg: 检测的图片
    ///   - coverImg: 需要遮盖人脸的图片
    /// - Returns: 处理后的人脸的图片
    class func sp_detectFace(inputImg : CIImage,coverImg : UIImage?)->CIImage?{
        guard let coverImage = coverImg else {
            return inputImg
        }
         var outImg : CIImage?
       
        let context = CIContext(options:[kCIContextUseSoftwareRenderer:true])
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures : [CIFaceFeature]?
        if let orientation : AnyObject = inputImg.properties[kCGImagePropertyOrientation as String] as AnyObject? {
            faceFeatures = detector?.features(in: inputImg, options: [CIDetectorImageOrientation: orientation]) as? [CIFaceFeature]
        }else{
            faceFeatures = detector?.features(in: inputImg) as? [CIFaceFeature]
        }
        
        let inputImageSize = inputImg.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)
        if let list = faceFeatures {
            var baseImage = UIImage(ciImage: inputImg)
            for faceFeature in list {
                let faceViewBounds = faceFeature.bounds.applying(transform)
                let size = inputImageSize
                UIGraphicsBeginImageContext(size)
                baseImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                coverImage.draw(in: faceViewBounds)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let img = image {
                    outImg = CIImage(image: img)
                    baseImage = img
                }
            }
        }
        if outImg == nil {
            outImg = inputImg
        }
        return outImg
    }
    /// 对视频图片进行处理 防止旋转不对
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
            let textAttributes = [NSAttributedStringKey.foregroundColor : textColor ,NSAttributedStringKey.font : font]
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

    /// 将 CGImage 转成CVPixelBuffer
    ///
    /// - Parameters:
    ///   - image: CGImage
    ///   - pixelBufferPool:
    ///   - pixelFormatType: 类型
    /// - Returns: CVPixelBuffer
    class func sp_pixelBuffer(fromImage image:CGImage,pixelBufferPool:CVPixelBufferPool?,pixelFormatType : OSType = kCVPixelFormatType_32BGRA) -> CVPixelBuffer?{
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        
        let size = screenPixels()
        let width = size.width
        let height = size.height
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, Int(width), Int(height),
                                         pixelFormatType, options, &pxbuffer)
        
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        context?.draw(image, in: CGRect(x:0, y:0, width:width, height: height));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!;
    }
    
}
