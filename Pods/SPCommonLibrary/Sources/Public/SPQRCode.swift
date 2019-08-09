//
//  SPQRCode.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/7/29.
//

import Foundation
import UIKit
import AVFoundation
public class SPQRCode {
    /// 创建二维码
    ///
    /// - Parameters:
    ///   - qrCode: 二维码内容
    ///   - iconImg: 中心的图片
    ///   - size: 二维码大小
    ///   - iconSize: 中心图片的大小
    /// - Returns: 二维码图片 
    public class func sp_create(qrCode:String,iconImg : UIImage? = nil,size : CGSize = CGSize(width: 300, height: 300),iconSize : CGSize = CGSize(width: 30, height: 30))->UIImage?{
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setDefaults()
            if let data = qrCode.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                filter.setValue(data, forKey: "inputMessage")
//                filter.setValue("H", forKey: "inputCorrectionLevel")
                if let outputImg = filter.outputImage {
                    // 生成的二维码需要转换高清的 否则会模糊的
                    if let qrCodeImg = UIImage.sp_highImg(image: outputImg, size: size) {
                        return sp_center(image: qrCodeImg, iconImg: iconImg, iconSize: iconSize)
                    }
                }
            }
            
        }
        return nil
    }
    /// 添加中间图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - iconImg: 中间logo图片
    ///   - iconSize: 终极logo图片的大小
    /// - Returns: 转换后的图片
    public class func sp_center(image : UIImage,iconImg : UIImage?,iconSize : CGSize  = CGSize(width: 30, height: 30))->UIImage?{
        return image.sp_image(centerImg: iconImg, iconSize: iconSize)
    }
    
    /// 从图片中识别二维码内容
    ///
    /// - Parameter codeImg: 二维码图片
    /// - Returns: 识别到的数据
    public class func sp_recognizeQRCode(codeImg : UIImage?)-> [String]?{
        guard let img = codeImg  else {
            return nil
        }
        if let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh]) {
            if let ciImg = CIImage(image: img) {
                let features = detector.features(in: ciImg)
                 var list = [String]()
                for object in features {
                    if let feature = object as? CIQRCodeFeature {
                        let resultStr = feature.messageString
                        if sp_getString(string: resultStr).count > 0 {
                            list.append(sp_getString(string: resultStr))
                        }
                    }
                }
                return list
            }
        }
        return nil
    }
    
    /// 修改二维码图片的颜色
    ///
    /// - Parameters:
    ///   - color1: 二维码内容图片颜色
    ///   - bgColor: 二维码背景颜色
    ///   - image: 二维码图片
    /// - Returns: 转换后的图片
    public class func sp_color(color1 : UIColor,bgColor : UIColor?,image : UIImage) ->UIImage?{
        if let filter = CIFilter(name: "CIFalseColor"){
            filter.setDefaults()
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            filter.setValue(CIColor(color: color1), forKey: "inputColor0")
            if let bg = bgColor {
                 filter.setValue(CIColor(color: bg), forKey: "inputColor1")
            }else{
                 filter.setValue(nil, forKey: "inputColor1")
            }
           
            if let outputImg = filter.outputImage {
                let newImg = UIImage(ciImage: outputImg)
                return newImg.sp_image(centerImg: nil, iconSize: CGSize.zero)
            }
        }
        return image
    }
    /// 添加背景图片
    ///
    /// - Parameters:
    ///   - bgImg: 背景图片
    ///   - image: 原始图片
    ///   - minHueAngle: 去掉背景颜色最低的颜色值HSV
    ///   - maxHueAngle: 去掉背景颜色最高的颜色值HSV
    /// - Returns:  转换后的图片
    public class func sp_add(bgImg : UIImage,image:UIImage,minHueAngle:Float,maxHueAngle:Float) -> UIImage?{
        let cubeMap = createCubeMap(minHueAngle, maxHueAngle)
        let data = NSData(bytesNoCopy: cubeMap.data, length: Int(cubeMap.length), freeWhenDone: true)
        
        if let colorCubeFilter = CIFilter(name: "CIColorCube") {
            colorCubeFilter.setValue(cubeMap.dimension, forKey: "inputCubeDimension")
            colorCubeFilter.setValue(data, forKey: "inputCubeData")
            colorCubeFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let colorOutputImg =  colorCubeFilter.outputImage {
                if let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing"){
                    sourceOverCompositingFilter.setValue(colorOutputImg, forKey: kCIInputImageKey)
                    sourceOverCompositingFilter.setValue(CIImage(image:bgImg), forKey: kCIInputBackgroundImageKey)
                    if let outputImg = sourceOverCompositingFilter.outputImage {
                        let context = CIContext(options: nil)
                        if let cgImg = context.createCGImage(outputImg, from: outputImg.extent) {
                           let newImg = UIImage(cgImage: cgImg)
                            return newImg.sp_image(centerImg: nil, iconSize: CGSize.zero)
                        }
                    }
                }
            }
        }
        return image
    }
    
}
