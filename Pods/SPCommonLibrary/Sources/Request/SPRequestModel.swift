//
//  SPRequestModel.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/7/15.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation

/// 请求的 方法
///
/// - get: get请求
/// - post: post 请求
/// - head: head 请求
/// - put: put 请求
public enum SPHttpMethod {
    case get
    case post
    case head
    case put
}
/// 返回数据的格式
///
/// - json: 返回为json
/// - data: 返回为data
/// - string: 返回为string
public enum SPReponseFormat {
    case json
    case data
    case string
}

public class SPRequestModel {
    /// 请求链接
    public var url : String?
    /// 请求参数
    public var parm : [String: Any]?
    /// 是否在请求中
    public var isRequest : Bool = false
    /// 请求类型
    public var methond : SPHttpMethod = .post
    /// 请求返回值类型
    public var reponseFormat : SPReponseFormat = .json
    /// 超时时间
    public var timeOut : Int = 30
}
