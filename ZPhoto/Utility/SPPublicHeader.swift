//
//  SPPublicHeader.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/4/9.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

/// 获取Documents目录路径
let kDocumentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
/// 获取Cache目录路径
let kCachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
/// 获取Tmp目录路径
let kTmpPath = NSTemporaryDirectory()
/* 帧数
 */
let framesPerSecond : Int32 = 60

/**
 获取字体对象
 
 - parameter fontSize: 字体大小
 
 - returns: font
 */
func fontSize(fontSize: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}
func getStatusBarHeight() -> CGFloat{
    return UIApplication.shared.statusBarFrame.height
}
/**
 主线程
 */
func dispatchMainQueue(complete:@escaping ()->Void){
    DispatchQueue.main.async(execute: {
         complete()
    })
}
/**
 多线程
 */
func dispatchAsync(complete:@escaping ()->Void){
    DispatchQueue.global().async {
        complete()
    }
}
/**
 延时操作
 - parameter time:     延时时间
 */
func  dispatchAfter(time:UInt64,complete:@escaping ()->Void){
    let queue = DispatchQueue(label: "com.hsp.queue")
    queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: time)) { 
      complete()
    }
}
func SPLog<T>(_ message:T,file:String = #file,function:String = #function,line:Int=#line){
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
//        NSLog("--\(fileName) ---\(line)--\(function) --- \(message)")
        print("\(NSDate().timeIntervalSince1970)---\(fileName):\(line)---\(function) | \(message)")
    #endif
}
/**
 对视频图片进行处理 防止旋转不对
 */
func picRotating(imgae:CIImage?) -> CIImage? {
    guard let outputImage = imgae else {
        return nil
    }
    let orientation = UIDevice.current.orientation
    var t: CGAffineTransform!
    if orientation == UIDeviceOrientation.portrait {
        t = CGAffineTransform(rotationAngle: CGFloat(-M_PI / 2.0))
    } else if orientation == UIDeviceOrientation.portraitUpsideDown {
        t = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2.0))
    } else if (orientation == UIDeviceOrientation.landscapeRight) {
        t = CGAffineTransform(rotationAngle: CGFloat(M_PI))
    } else {
        t = CGAffineTransform(rotationAngle: 0)
    }
    return  outputImage.applying(t)
}
/**
 倒计时
 */
func  countdown(timeOut:TimeInterval,run:((_ time: TimeInterval)-> Void)?,finish:(()->Void)?) -> DispatchSourceTimer{
    var timeCount = timeOut
   return timer {
        timeCount = timeCount - 1
        if timeCount <= 0 {
            if let finishComplete = finish {
                finishComplete()
            }
        }else{
            if let runComplete = run {
                runComplete(timeCount)
            }
        }
    }
}
/**
 计时器
 */
func timer(_ complete:(() -> Void)?) -> DispatchSourceTimer {
    let codeTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    let timeInterval: Double = 1.0
    codeTimer.scheduleRepeating(deadline: .now(), interval: timeInterval)
    codeTimer.setEventHandler {
        if let com = complete {
            dispatchMainQueue {
                 com()
            }
        }
    }
    
    codeTimer.resume()
    return codeTimer
}
// 获取屏幕分辨率
func screenPixels() -> CGSize {
    return (UIScreen.main.currentMode?.size)!
}

/**
 把秒数转换成时分秒（00:00:00）格式
 */
func transToHourMinSec(time: Float) -> String
{
    let allTime: Int = Int(time)
    var hours = 0
    var minutes = 0
    var seconds = 0
    var hoursText = ""
    var minutesText = ""
    var secondsText = ""
    
    hours = allTime / 3600
    hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
    
    minutes = allTime % 3600 / 60
    minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
    
    seconds = allTime % 3600 % 60
    secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
    
    return "\(hoursText):\(minutesText):\(secondsText)"
}
/*
 将秒转成分：秒格式
 */
func formatForMin(seconds:Float64) -> String{
    let Min = Int(seconds / 60)
    let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
    return String(format: "%02d:%02d", Min, Sec)
}
