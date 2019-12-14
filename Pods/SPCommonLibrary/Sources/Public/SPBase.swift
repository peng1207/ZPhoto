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
public func  sp_fontSize(fontSize: CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}
/// 获取状态栏高度
///
/// - Returns: 高度
public func sp_statusBarHeight() -> CGFloat{
    return UIApplication.shared.statusBarFrame.height
}
/// 获取屏幕的宽度
///
/// - Returns: 宽度
public func sp_screenWidth()->CGFloat{
    return UIScreen.main.bounds.size.width
}
/// 获取屏幕的高度
///
/// - Returns: 高度
public func sp_screenHeight()->CGFloat{
    return UIScreen.main.bounds.size.height
}
/// 获取根据屏幕比获取对应的数值
///
/// - Parameter value:需要转换的
/// - Returns: 转换后的值
public func sp_scale(value : CGFloat) -> CGFloat{
    return value / UIScreen.main.scale
}
/// 获取屏幕分辨率
public func sp_screenPixels() -> CGSize {
    if let size = UIScreen.main.currentMode?.size {
        return CGSize(width: size.width , height: size.height)
    }else{
         return CGSize.zero
    }
}
/// 打印
///
/// - Parameters:
///   - message: 打印的内容
///   - file: 文件
///   - methodName: 方法名（函数）
///   - lineNumber: 行数
public func sp_log<T>(message : T,file : String = #file,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName).\(methodName)[\(lineNumber)]\(Date().timeIntervalSince1970):\(message)")
    #endif
}
/// 异步多线程
///
/// - Parameters:
///   - queueName:  线程名字
///   - complete: 回调
public func sp_sync(queueName : String? = "com.queue.defauleQueue" ,complete : @escaping()->Void){
    let queue = DispatchQueue(label: queueName!)
//    let queue = DispatchQueue(label: sp_getString(string: queueName), qos: DispatchQoS.utility, attributes: .concurrent)
    // 异步
    queue.async {
         complete()
    }
}
/// 同步多线程
/// - Parameters:
///   - queueName: 线程名字
///   - complete: 回调
public func sp_synchro(queueName : String? = "com.queue.synchroQueue" ,complete : @escaping()->Void){
    let queue = DispatchQueue(label: queueName!)
     // 同步
    queue.sync {
        complete()
    }
}
/// 主线程
///
/// - Parameter comlete: 回调
public func sp_mainQueue (comlete:@escaping ()->Void){
    DispatchQueue.main.async {
        comlete()
    }
}
/// 执行延迟操作
///
/// - Parameters:
///   - time: 延迟时间
///   - complete: 回调
public func sp_asyncAfter(time : TimeInterval,complete:@escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
        complete()
    }
}
/// 获取数组的数量
///
/// - Parameter array: 数组
/// - Returns: 数量
public func sp_count(array:Array<Any>?) -> Int{
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
public func sp_isArray(array:Any?) -> Bool {
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
public func sp_isDic(dic : Any?) -> Bool{
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
public func sp_getString(string:Any?) ->  String{
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
    return "\(string ?? "")"
}

/// 隐藏键盘
public func sp_hideKeyboard(){
    UIApplication.shared.keyWindow?.endEditing(true)
}
/// 字典转json字符串
///
/// - Parameter dic: 字典
/// - Returns: json字符串
public func sp_dicValueString(_ dic:[String : Any]) -> String?{
    
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
public func  sp_stringValueDic(_ str: String) -> [String : Any]?{
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
public func sp_stringValueArr(_ str : String) -> [Any]?{
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
public func sp_arrayValueString(_ array : [Any]) -> String?{
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
public func sp_getKeyBoardheight(notification:Notification)->CGFloat{
    let userinfo: NSDictionary = notification.userInfo! as NSDictionary
    
    let nsValue = userinfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
    
    let keyboardRec = nsValue.cgRectValue
    
    let height = keyboardRec.size.height
    return height
}
/// 打开设置界面
public func sp_sysOpen() {
    if let url = URL(string: UIApplication.openSettingsURLString){
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
/// 获取app中LaunchImage
///
/// - Returns: 图片
public func sp_appLaunchImg()->UIImage?{
    if let delgate = UIApplication.shared.delegate {
        if let window = delgate.window {
            if let w = window {
                 let viewSize = w.bounds.size
                let viewOrientation = "Portrait"
                var launchImageName = ""
                if let infoDic = Bundle.main.infoDictionary {
                    if let imgList = infoDic["UILaunchImages"] as? [[String : Any]]{
                        for dic in imgList {
                            
                            let imgSize = NSCoder.cgSize(for: sp_getString(string: dic["UILaunchImageSize"]))
                            let orient = sp_getString(string: dic["UILaunchImageOrientation"])
                            if viewOrientation == orient , __CGSizeEqualToSize(imgSize, viewSize){
                                launchImageName = sp_getString(string: dic["UILaunchImageName"])
                            }
                            
                            
                        }
                        if sp_getString(string: launchImageName).count == 0 {
                            if let dict = imgList.last {
                                launchImageName = sp_getString(string: dict["UILaunchImageName"])
                                
                            }
                        }
                        let bundle = Bundle.main
                        let resourcePath = sp_getString(string: bundle.resourcePath)
                        let filePath = resourcePath + "/" + launchImageName
                        return UIImage(contentsOfFile: filePath)
                    }
                    
                    
                }
                
            }
        }
    }
 
    return nil
    
}
/// 获取applogo图片
///
/// - Returns: 图片
public func sp_appLogoImg()->UIImage?{
    if let infoDic = Bundle.main.infoDictionary {
        if  let iconsDic = infoDic["CFBundleIcons"] as? [String : Any] {
            if let iconDic = iconsDic["CFBundlePrimaryIcon"] as? [String : Any]{
                if let filesList = iconDic["CFBundleIconFiles"] as? [String]{
                    let bundle = Bundle.main
                    if  let resourcePath = bundle.resourcePath {
                        let filePath = resourcePath + "/" + sp_getString(string: filesList.last)
                        return UIImage(contentsOfFile: filePath)
                    }
                }
            }
           
        }
    }
    
   
    return nil
}
/// 获取最顶层的控制器ViewController
public func sp_topVC()->UIViewController?{
    var resultVC : UIViewController?
    resultVC = sp_nextTopVC(vc: UIApplication.shared.keyWindow?.rootViewController)
    while ((resultVC?.presentedViewController) != nil) {
        resultVC = sp_nextTopVC(vc: resultVC?.presentedViewController)
    }
    
    return resultVC
}
/// 获取下个顶层的VC
private func sp_nextTopVC(vc : UIViewController?)->UIViewController?{
    guard let viewController = vc else {
        return nil
    }
    if let navVC : UINavigationController = viewController as? UINavigationController {
        return sp_nextTopVC(vc: navVC.topViewController)
    }else if let tabVC : UITabBarController = viewController as? UITabBarController {
       return sp_nextTopVC(vc: tabVC.selectedViewController)
    }
      return viewController
}
