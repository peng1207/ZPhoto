//
//  SPFilterModel.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/9/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class SPFilterModel : NSObject {
    var filter : CIFilter?
    var outputImage : CIImage? {
        didSet{
            showImage = UIImage(ciImage: outputImage!)
        }
    }
    var showImage : UIImage?
    var filteEnum : SPFilterPhoto!{
        didSet{
            setupFilter()
        }
    }
    var inputImage : CIImage? {
        didSet{
            if let f = filter {
                f.setValue(inputImage, forKey: kCIInputImageKey)
                outputImage = f.outputImage
            }else{
                outputImage = inputImage
            }
        }
    }
    lazy var ciContext: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    /**
     创建滤镜类
     */
    fileprivate func setupFilter(){
       
        switch filteEnum {
        case  .EffectInstant:
            filter = CIFilter.photoEffectInstant()
        case .EffectNoir:
            filter = CIFilter.photoEffectNoir()
        case .EffectTonal:
            filter = CIFilter.photoEffectTonal()
        case .EffectTransfer:
            filter = CIFilter.photoEffectTransfer()
        case .EffectMono:
            filter = CIFilter.photoEffectMono()
        case .EffectFade:
            filter = CIFilter.photoEffectFade()
        case .EffectProcess:
            filter = CIFilter.photoEffectProcess()
        case .EffectChrome:
            filter = CIFilter.photoEffectChrome()
        case .HueAdjust:
            filter = CIFilter.photoHueAdjust()
        case .VignetteEffect:
            filter = CIFilter.photoVignetteEffect()
        case .SRGBToneCurveToLinear:
            filter = CIFilter.photoSRGBToneCurveToLinear()
        case .none:
            filter = nil
        case .some(_):
            filter = nil
        }
    }
    
}
