//
//  SPUploadImageModel.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/7/16.
//  Copyright © 2019 Peng. All rights reserved.
//  上传图片的mode

import Foundation
public class SPUploadFileModel {
    /// 上传的路径
    public var url : String?
    /// 参数
    public var parm : [String : Any]?
    /// 请求返回值类型
    public var reponseFormat : SPReponseFormat = .json
    /// 文件数组
    public var dataList : [SPUploadFileStruct]?
    public var isRequest : Bool = false
}

public struct SPUploadFileStruct {
    /// 上传的文件
    public var data : Data?
    /// 后台检图片类型的，主要是后缀名
    public var fileName : String?
    /// 传输的文件类型
    public var mimeType : String?
    /// 后台通过字段来获取图片
    public var name : String
    
}
