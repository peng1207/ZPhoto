//
//  SPCameraHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/12.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
class SPCameraHelp {

    /// 放大
    ///
    /// - Parameters:
    ///   - device: 当前摄像头设备
    ///   - scale:  放大的倍数
    class func sp_zoomIn(device : AVCaptureDevice?,scale : CGFloat = 1.0){
        guard let currentDevice = device else {
            return
        }
        var zoomFactor = currentDevice.videoZoomFactor
        if zoomFactor < 5.0 {
            zoomFactor = min(zoomFactor + scale, 5.0)
            sp_changeDeviceProperty(device: currentDevice) {
                currentDevice.videoZoomFactor = zoomFactor
            }
        }
    }
    /// 缩小
    ///
    /// - Parameters:
    ///   - device: 当前摄像头设备
    ///   - scale:缩放的倍数
    class func sp_zoomOut(device : AVCaptureDevice?,scale : CGFloat = 1.0){
        guard let currentDevice = device else {
            return
        }
        var zoomFactor = currentDevice.videoZoomFactor
        if zoomFactor > 1.0{
            zoomFactor = max(zoomFactor - scale, 1.0)
            sp_changeDeviceProperty(device: currentDevice) {
                currentDevice.videoZoomFactor = zoomFactor
            }
        }
    }
    ///   闪光灯设置
    ///
    /// - Parameter device: 当前摄像头设备
    /// - Returns: 闪光灯 打开或失败 true 打开 false 关闭
    class func sp_flash(device : AVCaptureDevice?)->Bool{
        guard let currentDevice = device else {
            return false
        }
        if currentDevice.position == AVCaptureDevice.Position.front {
            return false
        }
        if currentDevice.torchMode == AVCaptureDevice.TorchMode.off {
          return sp_flashOn(device: currentDevice)
        }else{
           return sp_flashOff(device: currentDevice)
        }
    }
    ///   打开闪光灯
    ///
    /// - Parameter device: 当前摄像头设备
    /// - Returns: 打开闪光灯
    class func sp_flashOn(device : AVCaptureDevice?)->Bool{
        guard let currentDevice = device else {
            return false
        }
        if !currentDevice.hasTorch {
            return false
        }
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.off {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.on
            }
        }
        return true
    }
    /// 关闭闪关灯
    ///  @discardableResult 返回参数没有接收不会有警告
    /// - Parameter device: 当前摄像头
    /// - Returns: false 关闭闪关灯
    @discardableResult class func sp_flashOff(device : AVCaptureDevice?)->Bool{
        guard let currentDevice = device else {
            return false
        }
 
        if !currentDevice.hasTorch {
            return false
        }
        
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.on {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.off
            }
 
        }
        return false
    }
    private class func sp_changeDeviceProperty(device : AVCaptureDevice,complete : SPBtnComplete){
        do{
            try device.lockForConfiguration()
            complete()
            device.unlockForConfiguration()
        }catch _ {
            
        }
    }
    /// 处理从摄像头获取到的图片进行处理
    ///
    /// - Parameters:
    ///   - ciImg: 摄像头获取到图片
    ///   - filter: 滤镜
    ///   - faceCoverImg: 人像遮盖图片
    ///   - videoLayoutType: 图片布局类型
    /// - Returns: 图片
    class func sp_deal(videoImg ciImg : CIImage? , filter : CIFilter?,faceCoverImg : UIImage?, videoLayoutType : SPVideoLayoutType = .none)->CIImage?{
        var newOutputImg : CIImage? = ciImg
        if let f = filter, let newCIImg = newOutputImg{
            f.setValue(newCIImg, forKey: kCIInputImageKey)
            newOutputImg = f.outputImage
        }
        if let newCIImg = newOutputImg {
            newOutputImg = CIFilter.photoautoAdjust(inputImage: newCIImg)
        }
        //执行判断人脸 然后增加头像上去
        newOutputImg = UIImage.sp_detectFace(inputImg: newOutputImg, coverImg: faceCoverImg)
        // 视频帧布局
        newOutputImg = UIImage.sp_video(layoutType: videoLayoutType, outputImg: newOutputImg)
        // 旋转图片
        newOutputImg = UIImage.sp_picRotating(imgae: newOutputImg)
        return newOutputImg
    }
    /// 处理视频流获取CIImage
    /// - Parameter sampleBuffer: 视频流
    /// - Parameter context: context
    class func sp_deal(sampleBuffer: CMSampleBuffer, context: CIContext)->(CIImage?,CIImage?){
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return (nil,nil)
        }
        var outputImage : CIImage? = nil
        outputImage = CIImage(cvImageBuffer: imageBuffer)
        var noFilterOutputImage = outputImage
        noFilterOutputImage = UIImage.sp_picRotating(imgae: noFilterOutputImage)
        if let noFilterImg = noFilterOutputImage ,let cgImg =  context.createCGImage(noFilterImg, from: noFilterImg.extent) {
            // 不是滤镜
            noFilterOutputImage = CIImage(cgImage:cgImg)
        }
        return (noFilterOutputImage,outputImage)
    }
}

