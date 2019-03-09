//
//  SPPhotoHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation

class SPPhotoHelp {
    static let SPPhotoDirectory = "\(kDocumentsPath)/photo"
 
    /// 获取文件名称
    ///
    /// - Returns: 文件名称
    class func sp_getFileName()->String {
        let date = NSDate()
        return "\(Int(date.timeIntervalSince1970))"
    }
    
    
    
    
}
