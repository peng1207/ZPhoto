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
import SPCommonLibrary
class SPFilterModel : NSObject {
    var filter : CIFilter?
   
    var outputImage : CIImage? {
        didSet{
            if let o = outputImage {
                 showImage = UIImage(ciImage:o)
            }
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
                if let _ = f.outputImage{
                      outputImage = f.outputImage
                }else{
                    outputImage = inputImage
                }
            }else{
                outputImage = inputImage
            }
        }
    }

    /**
     创建滤镜类
     */
    fileprivate func setupFilter(){
       
        switch filteEnum {
        case  .effectInstant?:
            filter = CIFilter.photoEffectInstant()
        case .effectNoir?:
            filter = CIFilter.photoEffectNoir()
        case .effectTonal?:
            filter = CIFilter.photoEffectTonal()
        case .effectTransfer?:
            filter = CIFilter.photoEffectTransfer()
        case .effectMono?:
            filter = CIFilter.photoEffectMono()
        case .effectFade?:
            filter = CIFilter.photoEffectFade()
        case .effectProcess?:
            filter = CIFilter.photoEffectProcess()
        case .effectChrome?:
            filter = CIFilter.photoEffectChrome()
        case .hueAdjust?:
            filter = CIFilter.photoHueAdjust()
        case .vignetteEffect?:
            filter = CIFilter.photoVignetteEffect()
        case .sRGBToneCurveToLinear?:
            filter = CIFilter.photoSRGBToneCurveToLinear()
        case .sepiaTone?:
            filter = CIFilter.photoCISepiaTone()
        case .vortexDistortion?:
            filter = CIFilter.vortexDistortion()
        case .bumpDistortion?:
            filter = CIFilter.bumpDistortion()
        case .bumpDistortionLinear?:
            filter = CIFilter.bumpDistortionLinear()
        case .cameraCalibrationLensCorrection?:
            filter = CIFilter.cameraCalibrationLensCorrection()
        case .circleSplashDistortion?:
            filter = CIFilter.circleSplashDistortion()
        case .gaussianGradient?:
            filter = CIFilter.gaussianGradient()
        case .colorMap?:
            filter = CIFilter.colorMap()
        case .circularWrap?:
            filter = CIFilter.circularWrap()
        case .perspectiveTransform?:
            filter = CIFilter.perspectiveTransform()
        case .straightenFilter?:
            filter = CIFilter.straightenFilter()
        case .lineOverlay?:
            filter = CIFilter.lineOverlay()
        case .edges?:
            filter = CIFilter.edges()
        case .none:
            filter = nil
        case .some(_):
            filter = nil
        }
    
    }
    
}
