//
//  FileManager+extension.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/8/19.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation


extension FileManager{
    
    /**< 创建文件夹  */
    class func directory(createPath:String){
        do{
            try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
        }catch{
            SPLog("creat directory is  \(error)")
        }
    }
    /**< 删除文件 */
    class func remove(path: String){
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                }catch {
                     SPLog("delete file is  \(error)")
                }
            }
        }
    }
    
    
}
