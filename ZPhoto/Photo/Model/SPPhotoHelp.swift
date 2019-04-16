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
    
    /// 获取保存的本地图片的数据
    ///
    /// - Returns: 图片数据
    class func sp_getPhototList()->[SPPhotoModel]{
        var list = [SPPhotoModel]()
        let fileArray = sp_getfile(forDirectory: SPPhotoDirectory)
        for file in fileArray! {
            let path = "\(SPPhotoDirectory)/\(file)"
            let model = SPPhotoModel()
            model.filePath = path
            list.append(model)
        }
        return list
    }
    
    
    
    
}
