//
//  SPSplicingToolModel.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/5/5.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

enum SPSplicingToolType {
    /// 布局
    case layout
    /// 背景
    case background
    /// 比例
    case zoom
    /// 边框
    case frame
    /// 文字
    case text
    /// 滤镜
    case filter
    /// 裁剪
    case shear
}

class SPToolModel {
    
    var title : String?
    var img : UIImage?
    var type : SPSplicingToolType = .layout
    
    fileprivate func sp_setupData(){
        switch type {
        case .layout:
            self.title = SPLanguageChange.sp_getString(key: "LAYOUT")
            self.img = UIImage(named: "public_layout")
        case .background:
            self.title = SPLanguageChange.sp_getString(key: "BACKGROUND")
            self.img = UIImage(named: "public_background")
        case .zoom:
            self.title = SPLanguageChange.sp_getString(key: "ZOOM")
            self.img = UIImage(named: "public_zoom")
        case .frame:
            self.title = SPLanguageChange.sp_getString(key: "FRAME")
            self.img = UIImage(named: "public_frame")
        case .text:
            self.title = SPLanguageChange.sp_getString(key: "TEXT")
            self.img = UIImage(named: "public_text")
        case .filter:
            self.title = SPLanguageChange.sp_getString(key: "FILTER")
            self.img = UIImage(named: "filter")
        case .shear:
            self.title = SPLanguageChange.sp_getString(key: "SHEAR")
            self.img = UIImage(named: "public_shear")
            
        }
        
    }
    class func sp_init(type:SPSplicingToolType)->SPToolModel{
        let model = SPToolModel()
        model.type = type
        model.sp_setupData()
        return model
    }
}
