//
//  CIFilter+extension.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/8/22.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import CoreImage

extension CIFilter{
    // MARK: -- 怀旧
    class func photoEffectInstant() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectInstant")
    }
    // MARK: -- 黑白
    class func photoEffectNoir() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectNoir")
    }
    // MARK: -- 色调
    class func photoEffectTonal() -> CIFilter?{
        return  CIFilter(name: "CIPhotoEffectTonal")
    }
    // MARK: -- 岁月
    class func photoEffectTransfer() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectTransfer")
    }
    // MARK: -- 单色
    class func photoEffectMono() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectMono")
    }
    // MARK: -- 褪色
    class func photoEffectFade() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectFade")
    }
    // MARK: -- 冲印
    class func photoEffectProcess() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectProcess")
    }
    // MARK: -- 铬黄
    class func photoEffectChrome() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectChrome")
    }
    // MARK: -- 美颜
    class func photoHueAdjust() -> CIFilter?{
        let filter = CIFilter(name: "CIHueAdjust")
        filter?.setValue(1.0, forKey: kCIInputAngleKey)
        return filter!
    }
    class func photoVignetteEffect() ->  CIFilter?{
        return CIFilter(name: "CIVignetteEffect")!
    }
    class func photoSRGBToneCurveToLinear() -> CIFilter?{
        return CIFilter(name: "CISRGBToneCurveToLinear")
    }
    // 棕色滤镜
    class func photoCISepiaTone()->CIFilter?{
        let f = CIFilter(name: "CISepiaTone")
        f?.setValue(0.9, forKey: kCIInputIntensityKey)
        return f
    }
    // MARK: -- 自动改善
    class func photoautoAdjust(inputImage:CIImage) -> CIImage {
        let filters = inputImage.autoAdjustmentFilters() as [CIFilter]
        var outputImage : CIImage = inputImage
        for filter : CIFilter in filters{
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            outputImage = filter.outputImage!
            
        }
        return outputImage
    }
}
