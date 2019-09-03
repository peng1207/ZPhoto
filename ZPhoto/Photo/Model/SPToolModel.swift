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
    /// 编辑
    case edit
    /// 字体颜色
    case textColor
    /// 字体大小
    case fontSize
    /// 字体名称
    case fontName
}

class SPToolModel {
    
    var title : String?
    var img : UIImage?
    var selectImg : UIImage?
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
        case .edit:
            self.title = SPLanguageChange.sp_getString(key: "EDIT")
            self.img = UIImage(named: "public_edit")
            self.selectImg = UIImage(named: "public_edit_select")
        case .textColor:
            self.title = SPLanguageChange.sp_getString(key: "TEXT_COLOR")
            self.img = UIImage(named: "public_color")
            self.selectImg = UIImage(named: "public_color_select")
        case .fontName:
            self.title = SPLanguageChange.sp_getString(key: "FONT_NAME")
            self.img = UIImage(named: "public_fontname")
            self.selectImg = UIImage(named: "public_fontname_select")
        case .fontSize:
            self.title = SPLanguageChange.sp_getString(key: "FONT_SIZE")
            self.img = UIImage(named: "public_fontsize")
            self.selectImg = UIImage(named: "public_fontsize_select")
        default:
            sp_log(message: "")
        }
        
    }
    class func sp_init(type:SPSplicingToolType)->SPToolModel{
        let model = SPToolModel()
        model.type = type
        model.sp_setupData()
        return model
    }
}
