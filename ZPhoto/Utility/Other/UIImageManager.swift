//
//  UIImageManager.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import SPCommonLibrary
extension  UIImage {
  
  
    
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
    
    /// 视频帧进行布局
    ///
    /// - Parameters:
    ///   - layoutType: 布局类型
    ///   - outputImg: 当前的图片
    /// - Returns: 布局之后的图片
    class func sp_video(layoutType : SPVideoLayoutType, outputImg : CIImage?)->CIImage?{
        guard let ciImg = outputImg else {
            return outputImg
        }
        guard layoutType != .none else {
            return outputImg
        }
        
        
        var newOutputImg : CIImage?
        let img = UIImage(ciImage: ciImg)
        let size = img.size
        UIGraphicsBeginImageContext(img.size)
      
        
        switch layoutType {
        case .none:
            img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        case .bisection:
            let w = size.width / 2.0
                img.draw(in: CGRect(x: 0, y: 0, width: w, height: size.height))
                img.draw(in: CGRect(x: w, y: 0, width: w, height: size.height))
        case .quadrature:
            let w = size.width / 2.0
            let h = size.height / 2.0
            for i in 0..<4 {
                img.draw(in: CGRect(x: i % 2 == 0 ? 0 : w, y: i / 2 != 0 ? h : 0, width: w, height: h))
            }
        case .sextant:
            let w = size.width / 2.0
            let h = size.height / 3.0
            for i in 0..<6 {
                img.draw(in: CGRect(x: i % 2 == 0 ? 0 : w, y: CGFloat(i / 2) * h, width: w, height: h))
            }
        case .nineEqualparts:
            let w = size.width / 3.0
            let h = size.height / 3.0
            for i in 0..<9{
                img.draw(in: CGRect(x: CGFloat( i % 3) * w, y: CGFloat(i / 3) * h, width: w, height: h))
            }
        default:
             img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
 
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let nImg = newImg {
            newOutputImg = CIImage(image: nImg)
            if newOutputImg == nil {
                newOutputImg = outputImg
            }
        }
        return  newOutputImg
    }
    /// 进行人脸识别
    ///
    /// - Parameters:
    ///   - inputImg: 源数据
    ///   - coverImg: 检测到人脸之后的遮盖
    /// - Returns: 处理后的图片
    class func sp_detectFace(inputImg: CIImage?, coverImg: UIImage?)->CIImage? {
        guard let ciImg = inputImg , let faceImg = coverImg else {
            return inputImg
        }
        if let faceDet = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh
//            ,CIDetectorTracking :true
            ]) {
            var featureArray : [CIFaceFeature]?
            if let orientation: AnyObject = ciImg
                .properties[kCGImagePropertyOrientation as String] as AnyObject? {
                featureArray = faceDet.features(in: ciImg, options: [CIDetectorImageOrientation: orientation]) as? [CIFaceFeature]
            }else{
                featureArray =  faceDet.features(in: ciImg) as? [CIFaceFeature]
            }
            if sp_count(array:  featureArray) > 0{
                let img = UIImage(ciImage: ciImg)
                let size = img.size
                UIGraphicsBeginImageContext(img.size)
                img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                if let faceRoateImg = faceImg.sp_roate(){
                    for face in featureArray! {
                        sp_log(message: face.bounds)
                        let bound = face.bounds
                        faceRoateImg.draw(in: bound)
                    }
                }
 
                let newImg = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if  let newOutImg = newImg, let newOutCIImg = CIImage(image: newOutImg) {
                    return newOutCIImg
                }
            }
        }
      
    
        return inputImg
    }
}
