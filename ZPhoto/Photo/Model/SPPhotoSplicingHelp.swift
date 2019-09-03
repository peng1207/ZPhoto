//
//  SPPhotoSplicingHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/24.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
/// 数据源
struct SPPhotoSplicingStruct {
    /// 当前的位置
    var index : Int = 0
    /// 总数量
    var count : Int = 0
    /// 父类的宽度
    var width:CGFloat = sp_screenWidth()
    /// 父类的高度
    var height:CGFloat = sp_screenWidth()
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
        case .eight(let t):
            retureValue = SPPhotoSplicingEight.sp_frameAndSpace(type: t, value: value)
        case .seven(let t):
            retureValue = SPPhotoSplicingSeven.sp_frameAndSpace(type: t, value: value)
        case .six(let t):
            retureValue = SPPhotoSplicingSix.sp_frameAndSpace(type: t, value: value)
        case .five(let t):
            retureValue = SPPhotoSplicingFive.sp_frameAndSpace(type: t, value: value)
        case .four(let t):
            retureValue = SPPhotoSplicingFour.sp_frameAndSpace(type: t, value: value)
        case .three(let t):
            retureValue = SPPhotoSplicingThree.sp_frameAndSpace(type: t, value: value)
        case .two(let t):
            retureValue = SPPhotoSplicingTwo.sp_frameAndSpace(type: t, value: value)
        case .one(_):
            retureValue = (CGRect(x: 0, y: 0, width: value.width, height: value.height),(value.margin,value.margin,value.margin,value.margin))
        default:
            sp_log(message: "没有其他的布局")
        }
        return retureValue
    }
    /// 获取背景颜色
    ///
    /// - Returns: 背景颜色数组
    class func sp_getDefaultColor()->[UIColor]{
        return [ sp_getMianColor(),
                 SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue),
                 SPColorForHexString(hex: SPHexColor.color_ff3300.rawValue)]
        
    }
    /// 根据数量展示布局
    ///
    /// - Parameter count: 数量
    /// - Returns: 布局
    class func sp_getSplicingLayout(count : Int) ->[SPSPlicingType]{
        if count == 9 {
            return [.nine(nineType: .one),.nine(nineType: .two),.nine(nineType: .three),.nine(nineType: .four),.nine(nineType: .five),.nine(nineType: .six),.nine(nineType: .seven),.nine(nineType: .eight),.nine(nineType: .nine),.nine(nineType: .ten),.nine(nineType: .eleven)]
        }else if count == 8 {
            return [.eight(type: .one),.eight(type: .two),.eight(type: .three),.eight(type: .four),.eight(type: .five),.eight(type: .six),.eight(type: .seven),.eight(type: .eight),.eight(type: .nine),.eight(type: .ten),.eight(type: .eleven),.eight(type: .twelve)]
        }else if count == 7{
            return [.seven(tyep: .one),.seven(tyep: .two),.seven(tyep: .three),.seven(tyep: .four),.seven(tyep: .five),.seven(tyep: .six),.seven(tyep: .seven),.seven(tyep: .eight)]
        }else if count == 6 {
            return [.six(type: .one),.six(type: .two),.six(type: .three),.six(type: .four),.six(type: .five),.six(type: .six),.six(type: .seven),.six(type: .eight),.six(type: .nine),.six(type: .ten),.six(type: .eleven),.six(type: .twelve)]
        }else if count == 5 {
            return [.five(type: .one),.five(type: .two),.five(type: .three),.five(type: .four),.five(type: .five),.five(type: .six),.five(type: .seven),.five(type: .eight),.five(type: .nine),.five(type: .ten),.five(type: .eleven),.five(type: .twelve),.five(type: .thirteen),.five(type: .fourteen),.five(type: .fifteen),.five(type: .sixteen),.five(type: .seventeen)]
        }else if count == 4 {
             return [.four(type: .one),.four(type: .two),.four(type: .three),.four(type: .four),.four(type: .five),.four(type: .six),.four(type: .seven),.four(type: .eight),.four(type: .nine),.four(type: .ten),.four(type: .eleven),.four(type: .twelve),.four(type: .thirteen),.four(type: .fourteen),.four(type: .fifteen),.four(type: .sixteen),.four(type: .seventeen),.four(type: .eighteen)]
        }else if count == 3 {
            return [.three(type: .one),.three(type: .two),.three(type: .three),.three(type: .four),.three(type: .five),.three(type: .six)]
        }else if count == 2 {
            return [.two(type: .one),.two(type: .two),.two(type: .three),.two(type: .four),.two(type: .five),.two(type: .six),.two(type: .seven)]
        }else if count == 1 {
            return [.one(tyep: .circular),.one(tyep: .rectangle),.one(tyep: .heart),.one(tyep: .waterDrop),.one(tyep: .diamond),.one(tyep: .polygon(polygon: .six)),.one(tyep: .polygon(polygon: .eight))]
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
        case .one(let t):
            layoutType = t
        default:
            sp_log(message: "")
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
            layoutType = .waterDrop
        default:
            sp_log(message: "没有其他")
        }
        
        return layoutType
    }
    
}
