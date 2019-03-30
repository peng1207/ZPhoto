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
/// 按钮点击回调
typealias SPBtnComplete = ()->Void
/**
 获取字体对象
 
 - parameter fontSize: 字体大小
 
 - returns: font
 */
func sp_fontSize(fontSize: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}
/// 获取状态栏高度
///
/// - Returns: 高度
func sp_getStatusBarHeight() -> CGFloat{
    return UIApplication.shared.statusBarFrame.height
}
/// 判断是否为数组
///
/// - Parameter array: 数据源
/// - Returns: 返回数组类型
func sp_isArray(array:Any) -> Array<Any>{
    let list : Array<Any>? = array as? Array<Any>
    if let a = list {
        return a
    }
    return []
}
/// 获取数组的数量
///
/// - Parameter array: 数组
/// - Returns: 数量
func sp_getArrayCount(array:Array<Any>?) -> Int{
    if let listArray = array {
        return listArray.count
    }else{
        return 0
    }
}
/// 是否为数组
///
/// - Parameter array: 数据
/// - Returns: 是否
func sp_isArray(array:Any?) -> Bool {
    if let _ : [Any] = array as? [Any]  {
        return true
    }else{
        return false
    }
}
/// 是否为字典
///
/// - Parameter dic: 数据
/// - Returns: 是否
func sp_isDic(dic : Any?) -> Bool{
    if let _ : [String : Any] = dic as? [String : Any] {
        return true
    }else{
        return false
    }
}
/// 获取字符串
///
/// - Parameter string: 字符串
/// - Returns: 字符串
func sp_getString(string:Any?) ->  String{
    if string == nil{
        return ""
    }
    if string is NSNull {
        return ""
    }
    let str : String? = string as? String
    
    if let s = str {
        return s
    }
    if string is NSNumber {
        let s : NSNumber = string as! NSNumber
        return s.description
    }
    return "\(string ?? "")"
    
}
/**
 主线程
 */
func sp_dispatchMainQueue(complete:@escaping ()->Void){
    DispatchQueue.main.async(execute: {
         complete()
    })
}
/**
 多线程
 */
func sp_dispatchAsync(complete:@escaping ()->Void){
    DispatchQueue.global().async {
        complete()
    }
}
///  延迟
///
/// - Parameters:
///   - time: 延迟时间
///   - complete: 回调
func sp_after(time:TimeInterval,complete:@escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
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
            sp_dispatchMainQueue {
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

func setUncaughtExceptionHandler() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler())
}

func UncaughtExceptionHandler() -> @convention(c) (NSException) -> Void {
    return { (exception) -> Void in
        let arr:NSArray = exception.callStackSymbols as NSArray//得到当前调用栈信息
        let reason = exception.reason//非常重要，就是崩溃的原因
        let name = exception.name//异常类型
        
        let content =  String("===异常错误报告===:name:\(name)===\n==reson:\(reason)==\n==ncallStackSymbols:\n\(arr.componentsJoined(by: "\n"))")
        SPLog("exception type : \(name) \n crash reason : \(reason) \n call stack info : \(arr)====content-->\(content)");
        do {
             try content?.write(to: URL(fileURLWithPath: "\(kCachesPath)/ZPhoteCash/\(Date()).txt"), atomically: false, encoding: String.Encoding.utf8)
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
///  获取字体
///
/// - Parameter size: 大小
/// - Returns: 字体
func sp_getFontSize(size : CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
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
