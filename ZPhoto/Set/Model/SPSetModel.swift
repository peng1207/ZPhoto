//
//  SPSetModel.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/11.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation

enum SPSetType {
    case share
    case score
}

class SPSetModel {
    
    var title : String?
    var type : SPSetType = .share
    
    
    class func sp_init(type : SPSetType)->SPSetModel{
        let model = SPSetModel()
        model.type = type
        switch type {
        case .share:
            model.title = "分享APP"
        case .score:
            model.title = "去评分"
        }
        return model
    }
    
}


