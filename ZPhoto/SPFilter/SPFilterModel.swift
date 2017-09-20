//
//  SPFilterModel.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/9/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import CoreImage

class SPFilterModel : NSObject {
    var filter : CIFilter?
    var outputImage : CIImage?
    var inputImage : CIImage? {
        didSet{
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            outputImage = filter?.outputImage
        }
    }
    
}
