//
//  SPPhotoSplicingHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/24.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

class SPPhotoSplicingHelp {
    
    /// 获取view的frame
    ///
    /// - Parameters:
    ///   - index: 位置
    ///   - count: 总数量
    ///   - type: 展示布局类型
    ///   - width: 父类的宽度
    ///   - height: 父类的高度
    /// - Returns: 坐标
    class func sp_getFrame(index : Int,
                           count : Int ,
                           type:SPSPlicingType,
                           width:CGFloat = sp_getScreenWidth(),
                           height:CGFloat = sp_getScreenWidth())-> CGRect{
        var frame = CGRect.zero
        switch type {
        case .nine(let t):
           frame = sp_getNineFrame(index: index, type: t, width: width, height: height)
        default:
            SPLog("没有其他")
        }
        
        return frame
    }
    private class func sp_getNineFrame(index : Int,
                                       type:SPSPlicingType.NineType,
                                       width:CGFloat,
                                       height:CGFloat)->CGRect{
        var frame = CGRect.zero
        switch type {
        case .one:
            let w = width / 3.0
            let h = height / 3.0
            frame = CGRect(x: CGFloat(index % 3) * w, y:  CGFloat(index / 3) * h, width: w, height: h)
            
        default:
            SPLog("没有其他")
        }
        return frame
    }
    
    /// 获取view的边距
    ///
    /// - Parameters:
    ///   - index: 位置
    ///   - count: 总数量
    ///   - type: 展示布局类型
    ///   - margin: 外边距（四周边距）
    ///   - padding: 内边距 (view与view之间的间距)
    /// - Returns: 间距
    class func sp_borderSpacing(index : Int,
                                count : Int,
                                type:SPSPlicingType,
                                margin : CGFloat = 4,
                                padding : CGFloat = 2)->(left : CGFloat , right : CGFloat , top : CGFloat , bottom : CGFloat){
        
        return (0,0,0,0)
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
            return [.nine(nineType: .one),.nine(nineType: .two),.nine(nineType: .three),.nine(nineType: .four),.nine(nineType: .five),.nine(nineType: .six),.nine(nineType: .seven),.nine(nineType: .eight),.nine(nineType: .nine),.nine(nineType: .ten),.nine(nineType: .eleven)]
        }else if count == 8 {
            
        }
        return []
    }
    class func sp_getLayoutType(index : Int,
                                count : Int,
                                type:SPSPlicingType) -> SPPictureLayoutType{
        return .rectangle
    }
}
