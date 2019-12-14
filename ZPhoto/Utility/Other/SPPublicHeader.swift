//
//  SPPublicHeader.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/4/9.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
/// 获取Documents目录路径
let kDocumentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
/// 获取Cache目录路径
let kCachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
/// 获取Tmp目录路径
let kTmpPath = NSTemporaryDirectory()

/// 保存视频的位置目录
let kVideoDirectory = "\(kDocumentsPath)/video"
/// 保存视频的临时位置目录
let kVideoTempDirectory = "\(kTmpPath)video"
/// 有新图片的通知
let K_NEWIMAGE_NOTIFICATION = "NEWIMAGE_NOTIFICATION"

/* 帧数
 */
let framesPerSecond : Int32 = 15
/// 按钮点击回调
typealias SPBtnComplete = ()->Void
typealias SPBtnTypeComplete = (_ type : SPButtonClickType)->Void
/// 点击回调 回传位置
typealias SPIndexComplete = (_ index : Int)->Void
 
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
    codeTimer.schedule(deadline: .now(), repeating: timeInterval)
    codeTimer.setEventHandler {
        if let com = complete {
            sp_mainQueue {
                com()
            }
        }
    }
    
    codeTimer.resume()
    return codeTimer
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

func setUncaughtExceptionHandler() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler())
}

func UncaughtExceptionHandler() -> @convention(c) (NSException) -> Void {
    return { (exception) -> Void in
        let arr:NSArray = exception.callStackSymbols as NSArray//得到当前调用栈信息
        let reason = exception.reason//非常重要，就是崩溃的原因
        let name = exception.name//异常类型
        
        let content =  String("===异常错误报告===:name:\(name)===\n==reson:\(reason)==\n==ncallStackSymbols:\n\(arr.componentsJoined(by: "\n"))")
        sp_log(message: "exception type : \(name) \n crash reason : \(reason) \n call stack info : \(arr)====content-->\(content)");
        do {
            try content.write(to: URL(fileURLWithPath: "\(kCachesPath)/ZPhoteCash/\(Date()).txt"), atomically: false, encoding: String.Encoding.utf8)
        }catch{
            
        }
      
    }
}
/*
 创建崩溃日志的目录
 */
func createCachePath (){
    FileManager.sp_directory(createPath: "\(kCachesPath)/ZPhoteCash")
}

/// 根据目录获取该目录下所有的文件 并排序
///
/// - Parameter forDirectory: 文件夹
/// - Returns: 该文件下所有的文件
func sp_getfile(forDirectory:String) -> [String]?{
    FileManager.sp_directory(createPath: forDirectory)
    let fileArray = try! FileManager.default.contentsOfDirectory(atPath: forDirectory)
    let fileSorted = fileArray.sorted { (file1 : String, file2 : String) -> Bool in
        if file1.compare(file2) == ComparisonResult.orderedAscending {
            return false
        }
        return  true
    }
    return fileSorted
}

/// 获取主颜色值
///
/// - Returns: 颜色
func sp_getMianColor()->UIColor{
    return SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
}
