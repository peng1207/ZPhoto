//
//  FileManager+extension.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/8/19.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import SPCommonLibrary

extension FileManager{
    
    /**< 创建文件夹  */
    class func sp_directory(createPath:String){
        do{
            try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
            addSkipBackupAttributeToItem(AtURL: URL(fileURLWithPath: createPath))
        }catch{
            sp_log(message: "creat directory is  \(error)")
        }
    }
    class private func addSkipBackupAttributeToItem(AtURL url:URL) {
        
        assert(FileManager.default.fileExists(atPath: url.path),"\(url.path)文件为创建成功")
        
        let urlNs:NSURL = url as NSURL
        
        do{
            
            try urlNs.setResourceValue(true, forKey:URLResourceKey.isExcludedFromBackupKey)
            
        }catch{
            
            assert(false,"设置不同步云端失败：\(error)")
            
        }
    }
 
    /// 删除文件
    ///
    /// - Parameter path: 文件路径
    class func remove(path: String){
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                }catch {
                    sp_log(message: "delete file is  \(error)")
                }
            }
        }
    }
    /// 删除多个文件
    ///
    /// - Parameter paths: 文件路径数组
    class func sp_remove(paths : [String]?){
        if let list = paths {
            for path in list {
                remove(path: path)
            }
        }
    }
    
    
    
}
