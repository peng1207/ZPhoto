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
let SP_DEVICE_TYPE :  String = UIDevice.current.model
/// 获取系统版本号
let SP_IOS_VERSION = UIDevice.current.systemVersion
/// 设备udid
let SP_IDENTIFIERNUMBER = UIDevice.current.identifierForVendor?.uuidString
/// 设备名称
let SP_SYSTEMNAME = UIDevice.current.systemName
/// 设备型号
let SP_MODEL = UIDevice.current.model
/// 设备区域化型号如A1533
let SP_LOCALIZEDMODEL = UIDevice.current.localizedModel
let SP_IS_IPAD = { () -> Bool in
    if SP_DEVICE_TYPE == "iPad" {
        return true
    }else{
        return false
    }
}()  // 是否IPAD设备

let SP_IS_IPHONE = { ( ) -> Bool in
    if SP_DEVICE_TYPE == "iPhone" {
        return true
    }else{
        return false
    }
}()   // 是否iphone设备

let SP_IS_IPODTOUCH = { () -> Bool in
    if SP_DEVICE_TYPE == "iPod touch" {
        return true
    }else{
        return false
    }
} () // 是否ipod设备
