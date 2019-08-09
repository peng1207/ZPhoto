//
//  UIImageManager.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

extension  UIImage {
  
  
    
    // MARK:- convert the CIImageToCGImage
    /// convertCIImageToCGImage
    ///
    /// - Parameter ciImage: input ciImage
    /// - Returns: output CGImage
   class func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
        
        
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }

    
}
