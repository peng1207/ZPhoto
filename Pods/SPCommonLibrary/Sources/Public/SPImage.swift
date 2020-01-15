//
//  SPImage.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    /// 颜色转图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    class func sp_image(color:UIColor,size : CGSize = CGSize(width: 1, height: 1)) ->UIImage?{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
//    /// view转图片
//    /// - Parameter view: 需要转换view
//    class func sp_image(view : UIView)->UIImage?{
//        let saveFrame = view.frame
//        var saveContentOffset : CGPoint = CGPoint.zero
//        var isScroll = false
//        if view is UIScrollView {
//            isScroll = true
//        }
//        var viewSize : CGRect = view.bounds
//        /// 若view 是scrollview 则生成图片为 contentSize
//        if isScroll , let scrollView = view as? UIScrollView {
//            viewSize = CGRect(origin: CGPoint.zero, size: scrollView.contentSize)
//            if viewSize.size.width == 0 {
//                viewSize = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.size.width, height: scrollView.contentSize.height))
//            }
//            if viewSize.size.height == 0 {
//                viewSize = CGRect(origin: CGPoint.zero, size: CGSize(width: viewSize.size.width, height: view.frame.size.height))
//            }
//
//            saveContentOffset = scrollView.contentOffset
//            scrollView.contentOffset = CGPoint.zero
//            scrollView.frame = CGRect(x: 0, y: 0, width: viewSize.size.width, height:viewSize.size.height)
//            view.snp.remakeConstraints { (maker) in
//                maker.left.top.equalTo(0)
//                maker.width.equalTo(viewSize.size.width)
//                maker.height.equalTo(viewSize.size.height)
//            }
//            UIGraphicsBeginImageContextWithOptions(viewSize.size, false, UIScreen.main.scale)
//
//        }else{
//            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        }
//        if let context = UIGraphicsGetCurrentContext() {
//            view.layer.render(in: context)
//        }else{
//            view.drawHierarchy(in: viewSize, afterScreenUpdates: true) // 高清截图
//        }
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        if isScroll {
//            view.frame = saveFrame
//            view.snp.remakeConstraints { (maker) in
//                maker.left.equalTo(saveFrame.origin.x)
//                maker.top.equalTo(saveFrame.origin.y)
//                maker.width.equalTo(saveFrame.size.width)
//                maker.height.equalTo(saveFrame.size.height)
//            }
//            (view as! UIScrollView).contentOffset = saveContentOffset
//        }
//        UIGraphicsEndImageContext()
//        return img
//    }
    /// 对视频图片或拍照图片进行处理 防止旋转不对
    /// - Parameter imgae: 需要处理的图片
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
        }else if orientation == .unknown{
             t = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2.0))
        }else {
            t = CGAffineTransform(rotationAngle: 0)
        }
        return  outputImage.transformed(by: t)
    }
    /// 给图片添加文字
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
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
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    class func sp_drawText(inputImg : CIImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CIImage?{
        let image = UIImage(ciImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point: point)
        if let outImg = outputImg, let outCIImg = CIImage(image: outImg) {
            return outCIImg
        }
        return  inputImg
    }
    /// 给图片添加文字
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    class func sp_drawText(inputImg : CGImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CGImage?{
        let image = UIImage(cgImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point:point)
        if let outImg = outputImg, let outCGImg = outImg.cgImage {
            return outCGImg
        }
        return  inputImg
    }
    /// 生成高清图片
    /// - Parameters:
    ///   - image: 需要生成的图片
    ///   - size: 需要生成的大小
    class func sp_highImg(image : CIImage,size : CGSize) ->UIImage?{
        let integral : CGRect = image.extent.integral
        let proportion : CGFloat = min(size.width / integral.width, size.height / integral.height)
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceGray()
        if let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0) {
            let context = CIContext(options: nil)
            if  let bitmapImage : CGImage = context.createCGImage(image, from: integral) {
                bitmapRef.interpolationQuality = .none
                bitmapRef.scaleBy(x: proportion, y: proportion)
                bitmapRef.draw(bitmapImage, in: integral)
                if  let img : CGImage = bitmapRef.makeImage() {
                    return UIImage(cgImage: img)
                }
            }
        }
        return UIImage(ciImage: image)
    }
    
    /// 将 CGImage 转成CVPixelBuffer
    /// - Parameters:
    ///   - image: CGImage
    ///   - pixelBufferPool:
    ///   - pixelFormatType: 类型
    class func sp_pixelBuffer(fromImage image:CGImage,pixelBufferPool:CVPixelBufferPool?,pixelFormatType : OSType = kCVPixelFormatType_32BGRA,pixelSize : CGSize = sp_screenPixels()) -> CVPixelBuffer?{
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        
        let size = pixelSize
        let width = size.width
        let height = size.height
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, Int(width), Int(height),
                                         pixelFormatType, options, &pxbuffer)
        if pxbuffer == nil {
            return pxbuffer
        }
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        context?.draw(image, in: CGRect(x:0, y:0, width:width, height: height))
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pxbuffer
    }
    
    /// 图片切圆角
    /// - Parameters:
    ///   - size: 图片大小
    ///   - fillColor: 裁切区填充颜色
    func sp_cornetImg(size : CGSize ,fillColor : UIColor = UIColor.white)->UIImage{
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        fillColor.setFill()
        UIRectFill(rect)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        self.draw(in: rect)
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = resultImg {
            return img
        }
        return self
    }
    /// 更改图片的颜色
    /// - Parameters:
    ///   - tintColor: 颜色
    ///   - blendMode: 类型
    func sp_image(tintColor : UIColor,blendMode:CGBlendMode)->UIImage{
        UIGraphicsBeginImageContext(self.size)
        tintColor.setFill()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = resultImg {
            return img
        }
        return self
    }
    /// 给图片添加中间icon图片
    /// - Parameters:
    ///   - centerImg: 中间icon图片
    ///   - iconSize: 展示在中间icon的大小
    func sp_image(centerImg : UIImage?,iconSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        if let icon = centerImg {
            let x = (self.size.width - iconSize.width) * 0.5
            let y = (self.size.height - iconSize.height) * 0.5
            icon.draw(in: CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height))
        }
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = newImg {
              return img
        }
        return self
    }
    /// 获取指定size的图片
    /// - Parameter size: 指定的size
    func sp_resizeImg(size : CGSize)->UIImage?{
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    /// 压缩图片
    /// - Parameters:
    ///   - maxImageLenght: 最大的尺寸
    ///   - maxSizeKB: 最大的大小
    func sp_resizeImg(maxImageLenght : CGFloat = 0, maxSizeKB : CGFloat = 1024)->UIImage{
        var maxSize = maxSizeKB
        var maxImgSize = maxImageLenght
        if maxSize <= 0.0 {
            maxSize = 1024.0
        }
//        if maxImgSize <= 0.0 {
//            maxImgSize = 1024.0
//        }
        var newSize = CGSize(width: self.size.width, height: self.size.height)
        if maxImgSize > 0 {
            let tempHeight = newSize.height / maxImgSize
            let tempWidth = newSize.width / maxImgSize
            if tempWidth > 1.0 && tempWidth > tempHeight{
                newSize = CGSize(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
            }else{
                newSize = CGSize(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
            }
        }
       
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = newImg {
            var  imageData =  img.jpegData(compressionQuality: 1.0)
            var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
            //调整大小
            var resizeRate = 0.9;
            
            while (sizeOriginKB > maxSize && resizeRate > 0.1) {
              
                imageData = img.jpegData(compressionQuality: CGFloat(resizeRate))
                
                sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
                
                resizeRate -= 0.1;
                
            }
            if let data = imageData {
                if let newImage = UIImage(data: data){
                    return newImage
                }
            }
        }
        
        return self
    }
    /// 获取jpeg的data
    func sp_jpegData()-> Data?{
        return  self.jpegData(compressionQuality: 1.0)
    }
    /// 图片逆时针旋转90
    func sp_roate()->UIImage?{
        if let cgImg = self.cgImage {
            var newOrientation  = UIImage.Orientation.up
            if self.imageOrientation == .up {
                newOrientation = .left
            }else if self.imageOrientation == .left {
                newOrientation = .down
            }else if self.imageOrientation == .down {
                newOrientation = .rightMirrored
            }
            let newImg = UIImage(cgImage: cgImg, scale: self.scale, orientation: newOrientation)
            UIGraphicsBeginImageContext(newImg.size)
            newImg.draw(in: CGRect(origin: CGPoint.zero, size: newImg.size))
            let roateImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if roateImg != nil {
                return roateImg
            }
            return newImg
        }
        return self
    }
    /// 裁剪图片
    /// - Parameter newFrame: 需要裁剪图片在当前图片的位置
    func sp_scaled(newFrame : CGRect)-> UIImage{
        if let cgImg = self.cgImage {
            if let newCgImg = cgImg.cropping(to: newFrame) {
                 let newImg = UIImage(cgImage: newCgImg)
                    return newImg
            }
        }
        return self
    }
    /// 对图片裁剪成圆形 居中裁剪
    func sp_circle() -> UIImage?{
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
 


