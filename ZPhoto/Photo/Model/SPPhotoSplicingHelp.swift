//
//  SPPhotoSplicingHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/24.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

/// 数据源
struct SPPhotoSplicingStruct {
    /// 当前的位置
    var index : Int = 0
    /// 总数量
    var count : Int = 0
    /// 父类的宽度
    var width:CGFloat = sp_getScreenWidth()
    /// 父类的高度
    var height:CGFloat = sp_getScreenWidth()
    /// 外边距
    var  margin : CGFloat = 4
    /// 内边距
   var padding : CGFloat = 4
}

typealias SPSpace = (left : CGFloat , right : CGFloat , top : CGFloat , bottom : CGFloat)
/// 返回的结构布局
typealias SPPhotoSplicingLayout = (frame : CGRect, space :SPSpace)


class SPPhotoSplicingHelp {
    
    /// 获取某个位置上view的大小和view上子view的间距
    ///
    /// - Parameters:
    ///   - tyep: 类型
    ///   - value: 参数
    /// - Returns: 大小和间距
    class func sp_frameAndSpace(tyep : SPSPlicingType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        var retureValue : SPPhotoSplicingLayout = (CGRect.zero,(0,0,0,0))
        switch tyep {
        case .nine(let t):
           retureValue = SPPhotoSplicingNine.sp_frameAndSpace(type: t, value: value)
        default:
            SPLog("没有其他的布局")
        }
        return retureValue
    }
    /// 获取背景颜色
    ///
    /// - Returns: 背景颜色数组
    class func sp_getDefaultColor()->[UIColor]{
        return [ sp_getMianColor(),
                 SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue),
                 SPColorForHexString(hex: SP_HexColor.color_ff3300.rawValue)]
        
    }
    /// 根据数量展示布局
    ///
    /// - Parameter count: 数量
    /// - Returns: 布局
    class func sp_getSplicingLayout(count : Int) ->[SPSPlicingType]{
        if count == 9 {
            return [.nine(nineType: .eight),.nine(nineType: .two),.nine(nineType: .three),.nine(nineType: .four),.nine(nineType: .five),.nine(nineType: .six),.nine(nineType: .seven),.nine(nineType: .eight),.nine(nineType: .nine),.nine(nineType: .ten),.nine(nineType: .eleven)]
        }else if count == 8 {
            
        }
        return []
    }
    class func sp_getLayoutType(index : Int,
                                count : Int,
                                type:SPSPlicingType) -> SPPictureLayoutType{
        var layoutType : SPPictureLayoutType = .rectangle
        switch type {
        case .nine(let t):
            layoutType = sp_nineLayoutType(index: index, count: count, type: t)
        default:
            SPLog("没有其他")
        }
        return layoutType
    }
    private class func sp_nineLayoutType(index : Int,
                                         count : Int,
                                         type:SPSPlicingType.NineType) -> SPPictureLayoutType{
        var layoutType : SPPictureLayoutType = .rectangle
        switch type {
        case .one:
            layoutType = .rectangle
        case .two:
            layoutType = .heart
        default:
            SPLog("没有其他")
        }
        
        return layoutType
    }
    
}
