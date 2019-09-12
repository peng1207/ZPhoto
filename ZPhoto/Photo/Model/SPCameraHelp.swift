//
//  SPCameraHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/12.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation

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
    /// 点击或关闭闪光灯
    ///
    /// - Parameter device: 当前摄像头设备
    class func sp_flash(device : AVCaptureDevice?){
        guard let currentDevice = device else {
            return
        }
        if currentDevice.position == AVCaptureDevice.Position.front {
            return
        }
        if currentDevice.torchMode == AVCaptureDevice.TorchMode.off {
            sp_flashOn(device: currentDevice)
        }else{
            sp_flashOff(device: currentDevice)
        }
    }
    /// 打开闪光灯
    ///
    /// - Parameter device: 当前摄像头设备
    class func sp_flashOn(device : AVCaptureDevice?){
        guard let currentDevice = device else {
            return
        }
        if !currentDevice.hasFlash {
            return
        }
        if !currentDevice.hasTorch {
            return
        }
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.off {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.on
            }
            if currentDevice.flashMode == AVCaptureDevice.FlashMode.off {
                currentDevice.flashMode = AVCaptureDevice.FlashMode.on
            }
        }
        
    }
    /// 关闭闪光灯
    ///
    /// - Parameter device: 当前摄像头设备
    class func sp_flashOff(device : AVCaptureDevice?){
        guard let currentDevice = device else {
            return
        }
        if !currentDevice.hasFlash {
            return
        }
        if !currentDevice.hasTorch {
            return
        }
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.on {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.off
            }
            if currentDevice.flashMode == AVCaptureDevice.FlashMode.on {
                currentDevice.flashMode = AVCaptureDevice.FlashMode.off
            }
        }
    }
    private class func sp_changeDeviceProperty(device : AVCaptureDevice,complete : SPBtnComplete){
        do{
            try device.lockForConfiguration()
            complete()
            device.unlockForConfiguration()
        }catch _ {
            
        }
    }
}
