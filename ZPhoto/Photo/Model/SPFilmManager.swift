//
//  SPFilmManager.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/3.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreFoundation
import SPCommonLibrary
/// 影片结构体
struct SPFilmStruct {
    /// 每张图片展示的持续时间
    var picDuration : TimeInterval = 1.0
    /// 动画的时间
    var animationDuratione : TimeInterval = 0.5
    /// 动画类型
    var animationType : SPAnimationType = .none
    /// 动画类型数组 animationType为nil
    var animationTypes : [SPAnimationType]?
    /// 背景颜色或背景图片
    var background : Any?
    /// 视频的比例 宽/高
    var ratio : CGFloat = 1
    ///  每秒的帧数
    var timescale : Int32 = framesPerSecond
    /// 视频的宽度
    var videoWidth : CGFloat = 750
    init(picDuration : TimeInterval,animationType : SPAnimationType,background : Any?){
        self.picDuration = picDuration
        self.animationType = animationType
        self.background = background
    }
}

/// 图片转影片的回调
typealias SPFilmComplete = (_ isSuccess : Bool,_ filePath : String?)->Void
// 保存视频的临时位置目录
//static let kVideoTempDirectory = "\(kTmpPath)/video"
class SPFilmManager {
    
    /// 将图片数组转换为视频
    ///
    /// - Parameters:
    ///   - images: 图片数组
    ///   - filePath: 视频导出的路径
    ///   - filmStruct: 影片结构体
    ///   - complete: 回调
    class func sp_video(images : [UIImage] ,filePath : String, filmStruct : SPFilmStruct,complete : SPFilmComplete?){
        sp_sync {
            do {
                sp_log(message: "开始合成")
                let width = filmStruct.videoWidth
                let size = CGSize(width: width, height: width / filmStruct.ratio)
                
                // 需要将图片压缩成size
                var imgList = [UIImage]()
                for img in images {
                    if let newImg = img.sp_resizeImg(size: size){
                        imgList.append(newImg)
                    }
                }
                
                let videoOutputSettings : [String : Any]
                videoOutputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoWidthKey : size.width,
                                       AVVideoHeightKey : size.height,
                ]
                
                let sourcePixelBufferAttributesDictionary = [
                    String(kCVPixelBufferPixelFormatTypeKey) : Int(sp_getCVPixelFormatType()),
                    String(kCVPixelBufferWidthKey) : size.width,
                    String(kCVPixelBufferHeightKey) : size.height ,
                    String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                    ] as [String : Any]
                
                let assertWriter = try AVAssetWriter(url: URL(fileURLWithPath: filePath), fileType: AVFileType.mp4)
                let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
                let videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
                
                if assertWriter.canAdd(videoWriterInput) {
                    assertWriter.add(videoWriterInput)
                }
                assertWriter.startWriting()
                
                assertWriter.startSession(atSourceTime: CMTime.zero)
                var index : Int = 0
                var frame : Int = 0
                /// 每张图片展示的次数
                let picCount = Int(Double(filmStruct.timescale) * filmStruct.picDuration)
                sp_log(message: "每张图片需要的帧数为 \(picCount)")
                let group = DispatchGroup()
                
                group.enter()
                for img in imgList {
                    var pixeBuffer : CVPixelBuffer?
                    if let cgImg = img.cgImage {
                        pixeBuffer =   UIImage.sp_pixelBuffer(fromImage: cgImg, pixelBufferPool: nil, pixelFormatType: sp_getCVPixelFormatType(), pixelSize: size)
                    }
                    
                    if let newPixBuffer = pixeBuffer {
                        for _ in 0..<picCount {
                            while !videoWriterInput.isReadyForMoreMediaData{
                                Thread.sleep(forTimeInterval: 0.1)
                            }
                            videoWriterPixelbufferInput.append(newPixBuffer, withPresentationTime: CMTimeMake(value: Int64(frame), timescale: filmStruct.timescale))
                            frame = frame + 1
                        }
                    }
                    // 判断是否需要动画
                    if filmStruct.animationType == .none , sp_count(array: filmStruct.animationTypes) == 0{
                        //  不需要动画
                    }else{
                        // 需要动画 不是最后一张图片
                        if index + 1 < imgList.count {
                            let nextImg = imgList[index + 1]
                            let animationImgs = sp_animation(imgs: img, nextImg: nextImg, filmStruct: filmStruct,index: index)
                            for animationImg in animationImgs {
                                if let cgImg = animationImg.cgImage {
                                    pixeBuffer = UIImage.sp_pixelBuffer(fromImage: cgImg, pixelBufferPool: nil, pixelFormatType: sp_getCVPixelFormatType(), pixelSize: size)
                                }else if let ciImg = animationImg.ciImage {
                                    let cgImg = UIImage.convertCIImageToCGImage(ciImage: ciImg)
                                    pixeBuffer = UIImage.sp_pixelBuffer(fromImage: cgImg, pixelBufferPool: nil, pixelFormatType: sp_getCVPixelFormatType(), pixelSize: size)
                                    
                                }
                                if let newPixeBuffer = pixeBuffer {
                                    while !videoWriterInput.isReadyForMoreMediaData{
                                        Thread.sleep(forTimeInterval: 0.1)
                                    }
                                    videoWriterPixelbufferInput.append(newPixeBuffer, withPresentationTime: CMTimeMake(value: Int64(frame), timescale: filmStruct.timescale))
                                    frame = frame + 1
                                }
                            }
                        }
                    }
                    index = index + 1
                }
                group.leave()
                
                group.notify(queue: .main) {
                    sp_log(message: "转换成功 停止写入 帧数为:\(frame)")
                    videoWriterInput.markAsFinished()
                    assertWriter.finishWriting(completionHandler: {
                        self.sp_dealComplete(isSuccess: true, filePath: filePath, complete: complete)
                    })
                }
            }catch {
                self.sp_dealComplete(isSuccess: false, filePath: nil, complete: complete)
            }
        }
    }
    fileprivate class func sp_getCVPixelFormatType()->OSType{
        return kCVPixelFormatType_32BGRA
    }
    fileprivate class func sp_dealComplete(isSuccess : Bool,filePath : String?,complete : SPFilmComplete?){
        guard let block = complete else {
            return
        }
        sp_mainQueue {
             block(isSuccess,filePath)
        }
       
    }
    /// 获取动画的帧数
    ///
    /// - Parameters:
    ///   - currImg: 当前图片
    ///   - nextImg: 下张图片
    ///   - filmStruct: 影片结构体
    ///   - index: 当前展示图片的位置
    /// - Returns: 帧数
    fileprivate class func sp_animation(imgs currImg : UIImage,nextImg : UIImage, filmStruct : SPFilmStruct,index : Int)->[UIImage]{
        var list = [UIImage]()
        let width = filmStruct.videoWidth
        let size = CGSize(width: width, height: width / filmStruct.ratio)
        let animationCount =  Int(Double(filmStruct.timescale) * filmStruct.animationDuratione)
        guard animationCount > 0 else {
            return [UIImage]()
        }
        sp_log(message: "动画需要的展示的帧数为 \(animationCount)")
        var animationType = filmStruct.animationType
        if animationType == .none , sp_count(array: filmStruct.animationTypes) > 0 {
            if index < sp_count(array: filmStruct.animationTypes){
                animationType = filmStruct.animationTypes![index]
            }else{
                animationType = filmStruct.animationTypes!.last!
            }
        }
        for i in 0..<animationCount {
            var newImg : UIImage?
            switch animationType {
            case .push:
                newImg = sp_push(image: currImg, nextImg: nextImg, size: size, index: i, space: size.width / CGFloat(animationCount))
            case .pull:
                newImg = sp_toBook(image: currImg, nextImg: nextImg, index: i,size: size)
            case .fadeOut:
                newImg = sp_fadeOut(image: currImg, nextImg: nextImg, index: i)
            case .cover:
                newImg = sp_cover(image: currImg, nextImg: nextImg, size: size, index: i, space: size.width / CGFloat(animationCount))
            case .hole:
                newImg = sp_hole(image: currImg, nextImg: nextImg, index: i)
            default:
                sp_log(message: "")
            }
            if let img = newImg {
                list.append(img)
            }
        }
        return list
    }
    /// 获取推出动画的帧数
    ///
    /// - Parameters:
    ///   - currImg: 当前的图片
    ///   - nextImg: 下一张图片
    ///   - size: 图片展示的大小
    ///   - index: 当前的位置
    ///   - space: 间距
    /// - Returns: 动画帧数
    fileprivate class func sp_push(image currImg : UIImage,nextImg : UIImage,size : CGSize,index : Int,space : CGFloat) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        currImg.draw(in: CGRect(x: CGFloat(index) * space, y: 0, width: currImg.size.width, height: currImg.size.height))
        var nextX = -(nextImg.size.width - CGFloat(index) * space)
        if  nextX >= 0 {
            nextX = 0
        }
        nextImg.draw(in: CGRect(x: nextX, y: 0, width: nextImg.size.width, height: nextImg.size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    /// 翻书
    ///
    /// - Parameters:
    ///   - currImg: 当前的图片
    ///   - nextImg: 下一张图片
    ///   - index: 当前的位置
    /// - Returns: 动画帧数
    fileprivate class func sp_toBook(image currImg : UIImage,nextImg : UIImage,index : Int,size : CGSize)-> UIImage?{
        if let filter = CIFilter(name: "CIPageCurlWithShadowTransition") {
            filter.setDefaults()
            filter.setValue(CIImage(image: currImg), forKey: kCIInputImageKey)
            filter.setValue(CIImage(image: currImg), forKey: "inputBacksideImage")
            filter.setValue(CIImage(image: currImg), forKey: kCIInputTargetImageKey)
            filter.setValue(0.01, forKey: kCIInputAngleKey)
            filter.setValue(0.01, forKey: kCIInputRadiusKey)
//            filter.setValue(0, forKey: "inputShadowSize")
//            filter.setValue(0, forKey: "inputShadowAmount")
//            filter.setValue( CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputShadowExtent")
//            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: currImg.size.width), forKey:  kCIInputExtentKey)
            filter.setValue(0.1 * CGFloat(index + 1), forKey: kCIInputTimeKey)
            if let outImg = filter.outputImage {
                var newImg = UIImage(ciImage: outImg)
                UIGraphicsBeginImageContext(size)
                nextImg.draw(in: CGRect(origin: CGPoint.zero, size: size))
                newImg.draw(in: CGRect(origin: CGPoint.zero, size: size))
                if let img = UIGraphicsGetImageFromCurrentImageContext() {
                     newImg = img
                }
                UIGraphicsEndImageContext()
                
                return newImg
            }
        }
    
        
        return nil
    }
    /// 淡出
    ///
    /// - Parameters:
    ///   - currImg: 当前的图片
    ///   - nextImg: 下一张图片
    ///   - index: 当前的位置
    /// - Returns: 动画帧数
    fileprivate class func sp_fadeOut(image currImg : UIImage,nextImg : UIImage,index : Int)-> UIImage?{
        if let filter = CIFilter(name: "CIDissolveTransition") {
            filter.setDefaults()
            filter.setValue(CIImage(image: currImg), forKey: kCIInputImageKey)
            filter.setValue(CIImage(image: nextImg), forKey: kCIInputTargetImageKey)
            filter.setValue(0.05 * CGFloat(index + 1), forKey: kCIInputTimeKey)
            if let outImg = filter.outputImage {
                return UIImage(ciImage: outImg)
            }
        }
        return nil
    }
    /// 覆盖
    ///
    /// - Parameters:
    ///   - currImg: 当前的图片
    ///   - nextImg: 下一张图片
    ///   - size: 图片展示的大小
    ///   - index: 当前的位置
    ///   - space: 间距
    /// - Returns: 动画帧数
    fileprivate class func sp_cover(image currImg : UIImage,nextImg : UIImage,size : CGSize,index : Int,space : CGFloat)->UIImage?{
        UIGraphicsBeginImageContext(size)
        
        currImg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        var nextX = -(nextImg.size.width - CGFloat(index) * space)
        if  nextX >= 0 {
            nextX = 0
        }
        nextImg.draw(in: CGRect(x: nextX, y: 0, width: nextImg.size.width, height: nextImg.size.height))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
    }
    /// 洞
    ///
    /// - Parameters:
    ///   - currImg: 当前的图片
    ///   - nextImg: 下一张图片
    ///   - index: 当前的位置
    /// - Returns: 动画帧数
    fileprivate class func sp_hole(image currImg : UIImage,nextImg : UIImage,index : Int)-> UIImage?{
        if let filter = CIFilter(name: "CIModTransition") {
            filter.setDefaults()
            filter.setValue(CIImage(image: currImg), forKey: kCIInputImageKey)
            filter.setValue(CIImage(image: nextImg), forKey: kCIInputTargetImageKey)
            filter.setValue(0.07 * CGFloat(index + 1), forKey: kCIInputTimeKey)
            if let outImg = filter.outputImage {
                return UIImage(ciImage: outImg)
            }
        }
        return nil
    }
}
