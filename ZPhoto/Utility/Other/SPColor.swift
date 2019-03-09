//
//  SPColor.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    ///  十六进制转颜色
    ///
    /// - Parameter hex: 十六进制字符串
    /// - Returns: 颜色
    class func colorWithHexString (hex: String,alpha: CGFloat = 1) -> UIColor {
      
        var cString: String = hex.uppercased().trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines)
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        
    }
}

///  颜色
///
/// - Parameter hex: 十六进制
/// - Returns: 颜色
func SPColorForHexString(hex: String,alpha: CGFloat = 1) -> UIColor{
    return UIColor.colorWithHexString(hex: hex,alpha: alpha)
}

/// 获取主颜色值
///
/// - Returns: 颜色
func sp_getMianColor()->UIColor{
    return SPColorForHexString(hex: SP_HexColor.color_2a96fd.rawValue)
}
