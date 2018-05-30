//
//  SPDevice.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/28.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit


let SP_DEVICE_TYPE :  String = UIDevice.current.model  // 获取设备类型
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


