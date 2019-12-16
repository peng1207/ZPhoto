//
//  SPBundle.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/9/25.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

extension Bundle{
    
    /// 获取bundle
    static var libraryBundle : Bundle {
        let library = Bundle(path:Bundle(for: SPImagePickerVC.self).path(forResource: "SPCommonLibrary", ofType: "bundle")!)
        return library!
    }
    /// 获取bundle里的图片
    class func sp_getImg(name : String)->UIImage?{
        
        if  let path = self.libraryBundle.path(forResource: name, ofType: "png") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
}
