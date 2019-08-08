//
//  SPBase.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/6/29.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit
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
func sp_statusBarHeight() -> CGFloat{
    return UIApplication.shared.statusBarFrame.height
}
/// 获取屏幕的宽度
///
/// - Returns: 宽度
func sp_screenWidth()->CGFloat{
    return UIScreen.main.bounds.size.width
}
/// 获取屏幕的高度
///
/// - Returns: 高度
func sp_screenHeight()->CGFloat{
    return UIScreen.main.bounds.size.height
}
/// 打印
///
/// - Parameters:
///   - message: 打印的内容
///   - file: 文件
///   - methodName: 方法名（函数）
///   - lineNumber: 行数
func sp_log<T>(message : T,file : String = #file,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName).\(methodName)[\(lineNumber)]\(Date().timeIntervalSince1970):\(message)")
    #endif
}
/// 多线程
///
/// - Parameters:
///   - queueName:  线程名字
///   - complete: 回调
func sp_sync(queueName : String? = "com.queue.defauleQueue" ,complete : ()->Void){
    let queue = DispatchQueue(label: queueName!)
    queue.sync {
        complete()
    }
}
/// 主线程
///
/// - Parameter comlete: 回调
func sp_mainQueue(comlete:@escaping ()->Void){
    DispatchQueue.main.async {
        comlete()
    }
    
}
/// 执行延迟操作
///
/// - Parameters:
///   - time: 延迟时间
///   - complete: 回调
func sp_asyncAfter(time : TimeInterval,complete:@escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
        complete()
    }
}
/// 获取数组的数量
///
/// - Parameter array: 数组
/// - Returns: 数量
func sp_count(array:Array<Any>?) -> Int{
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
        return s.stringValue
    }
    return "\(string)"
}

/// 隐藏键盘
func sp_hideKeyboard(){
    UIApplication.shared.keyWindow?.endEditing(true)
}
/// 字典转json字符串
///
/// - Parameter dic: 字典
/// - Returns: json字符串
func sp_dicValueString(_ dic:[String : Any]) -> String?{
    
    if !JSONSerialization.isValidJSONObject(dic) {
        sp_log(message: "无法解析")
        return ""
    }
    
    let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}
/// json字符串转字典
///
/// - Parameter str: json字符串
/// - Returns: 字典
func  sp_stringValueDic(_ str: String) -> [String : Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let d = data {
        if let dict = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
    }
    return nil
}
/// json字符串转数组
///
/// - Parameter str: json字符串
/// - Returns: 数组
func sp_stringValueArr(_ str : String) -> [Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let d = data{
        if let array = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [Any]{
            return array
        }
    }
    
    return nil
}
/// 将数组转为字符串
///
/// - Parameter array: 数组
/// - Returns: 字符串
func sp_arrayValueString(_ array : [Any]) -> String?{
    if !JSONSerialization.isValidJSONObject(array) {
        sp_log(message: "无法解析")
        return ""
    }
    let data = try? JSONSerialization.data(withJSONObject: array, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}

/// 获取键盘高度
///
/// - Parameter notification: 键盘弹起通知
/// - Returns: 高度
func sp_getKeyBoardheight(notification:Notification)->CGFloat{
    let userinfo: NSDictionary = notification.userInfo! as NSDictionary
    
    let nsValue = userinfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
    
    let keyboardRec = nsValue.cgRectValue
    
    let height = keyboardRec.size.height
    return height
}
