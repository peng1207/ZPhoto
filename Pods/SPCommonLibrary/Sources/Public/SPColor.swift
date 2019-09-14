//
//  SPColor.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit
public extension UIColor{
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
public func SPColorForHexString(hex: String,alpha: CGFloat = 1) -> UIColor{
    return UIColor.colorWithHexString(hex: hex,alpha: alpha)
}
