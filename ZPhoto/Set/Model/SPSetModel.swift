//
//  SPSetModel.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/11.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SPCommonLibrary
enum SPSetType {
    case share
    case score
    case watermark
}

class SPSetModel {
    
    var title : String?
    var type : SPSetType = .share
    
    
    class func sp_init(type : SPSetType)->SPSetModel{
        let model = SPSetModel()
        model.type = type
        switch type {
        case .share:
            model.title = SPLanguageChange.sp_getString(key: "SHARE_APP")
        case .score:
            model.title = SPLanguageChange.sp_getString(key: "TO_SCORE")
        case .watermark:
            model.title = SPLanguageChange.sp_getString(key: "WATERMARK")
        }
        return model
    }
    
}


