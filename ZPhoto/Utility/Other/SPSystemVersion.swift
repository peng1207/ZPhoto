//
//  SPSystemVersion.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/27.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit


let SP_SYSTEM_VERSION : String = UIDevice.current.systemVersion
let SP_SYSTEM_VERSION_FLOAT : Float = Float(SP_SYSTEM_VERSION)!

let SP_VERSION_9_UP = { () -> Bool in
    if #available(iOS 9.0, *){
        return true
    }else{
        return false
    }
    
}()
let SP_VERSION_10_UP = { () -> Bool in
    if #available(iOS 10.0, *){
        return true
    }else{
        return false
    }
    
}()
let SP_VERSION_11_UP = { () -> Bool in
    if #available(iOS 11.0, *){
        return true
    }else{
        return false
    }
    
}()
let SP_VERSION_12_UP = { () -> Bool in
    if #available(iOS 12.0, *){
        return true
    }else{
        return false
    }
    
}()
