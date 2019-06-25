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
        
        return CGRect.zero
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
    
    class func sp_getDefaultColor()->[UIColor]{
        
        return [ sp_getMianColor(),
                 SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue),
                 SPColorForHexString(hex: SP_HexColor.color_ff3300.rawValue)]
        
    }
    
}
