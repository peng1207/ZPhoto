//
//  SPSysSet.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/7.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//
// 跳到系统设置
import Foundation
import UIKit

class SPSysSet {
    
    class func  openSetting (){
        //打开设置界面
    
        if let url = URL(string: UIApplication.openSettingsURLString){
            if (UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
}
