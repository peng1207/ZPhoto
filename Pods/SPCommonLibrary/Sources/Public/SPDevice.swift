//
//  SPDevice.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit
/// 获取设备类型
public let SP_DEVICE_TYPE :  String = UIDevice.current.model
/// 获取系统版本号
public let SP_IOS_VERSION = UIDevice.current.systemVersion
/// 设备udid
public let SP_IDENTIFIERNUMBER = UIDevice.current.identifierForVendor?.uuidString
/// 设备名称
public let SP_SYSTEMNAME = UIDevice.current.systemName
/// 设备型号
public let SP_MODEL = UIDevice.current.model
/// 设备区域化型号如A1533
public let SP_LOCALIZEDMODEL = UIDevice.current.localizedModel
/// 设备的比例
public let SP_DEVICE_SCALE = UIScreen.main.scale
/// 是否IPAD设备
public let SP_IS_IPAD = { () -> Bool in
    if SP_DEVICE_TYPE == "iPad" {
        return true
    }else{
        return false
    }
}()
/// 是否iphone设备
public let SP_IS_IPHONE = { ( ) -> Bool in
    if SP_DEVICE_TYPE == "iPhone" {
        return true
    }else{
        return false
    }
}()
///  是否ipod设备
public let SP_IS_IPODTOUCH = { () -> Bool in
    if SP_DEVICE_TYPE == "iPod touch" {
        return true
    }else{
        return false
    }
} ()  
/// 9.0系统以上
public let SP_VERSION_9_UP = { () -> Bool in
    if #available(iOS 9.0, *){
        return true
    }else{
        return false
    }
    
}()
/// 10.0系统以上
public let SP_VERSION_10_UP = { () -> Bool in
    if #available(iOS 10.0, *){
        return true
    }else{
        return false
    }
    
}()
/// 11.0系统以上
public let SP_VERSION_11_UP = { () -> Bool in
    if #available(iOS 11.0, *){
        return true
    }else{
        return false
    }
    
}()
/// 12.0系统以上
public let SP_VERSION_12_UP = { () -> Bool in
    if #available(iOS 12.0, *){
        return true
    }else{
        return false
    }
    
}()
/// 13.0系统以上
public let SP_VERSION_13_UP = { () -> Bool in
    if #available(iOS 13.0, *){
        return true
    }else{
        return false
    }
    
}()
/// 判断当前是否设置深色模式
public func sp_isDark()->Bool{
    var isDark = false
    // 获取当前模式
    if #available(iOS 13.0, *) {
        let currentMode = UITraitCollection.current.userInterfaceStyle
        if (currentMode == .dark) {
            print("深色模式")
            isDark = true
        } else if (currentMode == .light) {
            print("浅色模式")
        } else {
            print("未知模式")
        }
    } else {
        // Fallback on earlier versions
    }
    return isDark
}
