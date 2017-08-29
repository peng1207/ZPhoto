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



/**
 获取字体对象
 
 - parameter fontSize: 字体大小
 
 - returns: font
 */
func fontSize(fontSize: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: fontSize)
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
        print("\(NSDate())---\(fileName):\(line)---\(function) | \(message)")
    #endif

}


