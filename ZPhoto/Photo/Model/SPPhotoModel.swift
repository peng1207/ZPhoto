//
//  SPPhotoModel.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/16.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
class SPPhotoModel : NSObject {
    var filePath : String?{
        didSet{
            sp_getImg()
        }
    }
    var img : UIImage?

    private func sp_getImg(){
        self.img = UIImage(contentsOfFile: sp_getString(string: filePath))
    }
    
}
