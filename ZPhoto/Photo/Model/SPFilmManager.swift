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

struct SPFilmStruct {
    /// 每张图片展示的持续时间
    var picDuration : TimeInterval = 0.5
    /// 动画的时间
    var animationDuratione : TimeInterval = 0.5
    /// 动画类型
    var animationType : SPAnimationType = .none
    /// 动画类型数组 animationType为nil
    var animationTypes : [SPAnimationType]?
    /// 背景颜色或背景图片
    var background : Any?
    /// 视频的比例 宽/高
    var ratio : CGFloat = 1.0
    ///  每秒的帧数
    var timescale : Int = 20
    var videoWidth : CGFloat = 750
    init(picDuration : TimeInterval,animationType : SPAnimationType,background : Any?){
        self.picDuration = picDuration
        self.animationType = animationType
        self.background = background
    }
}

/// 图片转影片的回调
typealias SPFilmComplete = (_ isSuccess : Bool)->Void

class SPFilmManager {
    
    class func sp_video(images : [UIImage] ,filePath : String, filmStruct : SPFilmStruct,complete : SPFilmComplete?){
        
        do {
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
                                   AVVideoHeightKey : size.height]
            
            let sourcePixelBufferAttributesDictionary = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(sp_getCVPixelFormatType()),
                String(kCVPixelBufferWidthKey) : size.width,
                String(kCVPixelBufferHeightKey) : size.height ,
                String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                ] as [String : Any]
            
            let assertWriter = try AVAssetWriter(url: URL(fileURLWithPath: filePath), fileType: AVFileType.mov)
            let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
            let videoWriterPixelbufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
            
            if assertWriter.canAdd(videoWriterInput) {
                 assertWriter.add(videoWriterInput)
            }
            assertWriter.startWriting()
        
            assertWriter.startSession(atSourceTime: CMTime.zero)
            videoWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "filmVideoQueue")) {
                var index : Int = 0
                var frame : Int = 0
                /// 每张图片展示的次数
                let picCount = Int(Double(filmStruct.timescale) * filmStruct.picDuration)
                while videoWriterPixelbufferInput.assetWriterInput.isReadyForMoreMediaData {
                    if index >= imgList.count {
                        videoWriterInput.markAsFinished()
                        assertWriter.finishWriting(completionHandler: {
                            
                        })
                        break
                    }
                    let img = imgList[index]
                    var pixeBuffer : CVPixelBuffer?
                    if let cgImg = img.cgImage {
                        pixeBuffer =   UIImage.sp_pixelBuffer(fromImage: cgImg, pixelBufferPool: nil, pixelFormatType: sp_getCVPixelFormatType(), pixelSize: size)
                    }
                    
                    if let newPixBuffer = pixeBuffer {
                        for _ in 0..<picCount {
                            videoWriterPixelbufferInput.append(newPixBuffer, withPresentationTime: CMTimeMake(value: Int64(frame), timescale: Int32(filmStruct.timescale)))
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
                                }
                                if let newPixeBuffer = pixeBuffer {
                                    videoWriterPixelbufferInput.append(newPixeBuffer, withPresentationTime: CMTimeMake(value: Int64(frame), timescale: Int32(filmStruct.timescale)))
                                    frame = frame + 1
                                }
                            }
                        }
                    }
                    index = index + 1
                }
            }
        }catch {
        
        }
        
    }
    fileprivate class func sp_getCVPixelFormatType()->OSType{
        return kCVPixelFormatType_32BGRA
    }
    fileprivate class func sp_animation(imgs currImg : UIImage,nextImg : UIImage, filmStruct : SPFilmStruct,index : Int)->[UIImage]{
        var list = [UIImage]()
        let width = filmStruct.videoWidth
        let size = CGSize(width: width, height: width / filmStruct.ratio)
        let animationCount =  Int(Double(filmStruct.timescale) * filmStruct.animationDuratione)
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
            case .fadeOut:
                newImg = sp_fadout(image: currImg, nextImg: nextImg, size: size, index: i, space: size.width / CGFloat(animationCount))
            default:
                sp_log(message: "")
            }
        }
        return list
    }
    fileprivate class func sp_fadout(image currImg : UIImage,nextImg : UIImage,size : CGSize,index : Int,space : CGFloat) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        currImg.draw(in: CGRect(x: CGFloat(index) * space, y: 0, width: currImg.size.width, height: currImg.size.height))
        nextImg.draw(in: CGRect(x: nextImg.size.width - CGFloat(index) * space, y: 0, width: nextImg.size.width, height: nextImg.size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImg
    }
    
}
