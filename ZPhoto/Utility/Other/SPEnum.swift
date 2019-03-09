//
//  SPEnum.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//
// 枚举类
import Foundation

enum SP_TimeFormat: String {
    case default_time   = "yyyy-MM-dd HH:mm:ss"
    case yyMdHm         = "yy-MM-dd HH:mm"
    case yyyyMdHm       = "yyyy-MM-dd HH:mm"
    case yMd            = "yyyy-MM-dd"
    case MdHms          = "MM-dd HH:mm:ss"
    case Hms            = "HH:mm:ss"
    case Hm             = "HH:mm"
    case Md             = "MM:dd"
    case yyMd           = "yy-MM-dd"
}

enum SP_HexColor : String {
    case color_333333   = "#333333"
    case color_000000   = "#000000"
    case color_c11f2f   = "#c11f2f"
    case color_b31f3f   = "#B31F3F"
    case color_ffffff   = "#ffffff"
    case color_8e8e8e   = "#8e8e8e"
    case color_666666   = "#666666"
    case color_999999   = "#999999"
    case color_eeeeee   = "#eeeeee"
    case color_97a959   = "#97A959"
    case color_ff9600   = "#FF9600"
    case color_dddddd   = "#DDDDDD"
    case color_1981fa   = "#1981fa"
    case color_0c95f5   = "#0c95f5"
    case color_ce6a00   = "#ce6a00"
    case color_e57d00   = "#e57d00"
    case color_e74540   = "#e74540"
    case color_f7f7f7   = "#f7f7f7"
    case color_eee000   = "#eee000"
    case color_189cdd   = "#189cdd"
    case color_1599da   = "#1599da"
    case color_00a1fe   = "#00a1fe"
    case color_01b5da   = "#01b5da"
    case color_2a96fd   = "#2a96fd"
}
// 按钮点击事件
public enum ButtonClickType : Int {
    case done                // 点击完成
    case cance               // 点击取消\返回
    case flash               // 点击闪光灯
    case change              // 点击切换镜头
    case filter              // 点击滤镜
}
