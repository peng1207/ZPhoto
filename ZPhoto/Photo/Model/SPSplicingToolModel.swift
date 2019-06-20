//
//  SPSplicingToolModel.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/5/5.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

enum SPSplicingToolType {
    case layout
    case background
}

class SPSplicingToolModel {
    
    var title : String?
    var img : UIImage?
    var type : SPSplicingToolType = .layout
    
    fileprivate func sp_setupData(){
        switch type {
        case .layout:
            self.title = "布局"
            self.img = UIImage(named: "public_layout")
        case .background:
            self.title = "背景"
            self.img = UIImage(named: "public_background")
            //        default:
            //            self.title = ""
        }
        
    }
    class func sp_init(type:SPSplicingToolType)->SPSplicingToolModel{
        let model = SPSplicingToolModel()
        model.type = type
        model.sp_setupData()
        return model
    }
}
