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
    /// 怀旧
    class func photoEffectInstant() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectInstant")
    }
    /// 黑白
    class func photoEffectNoir() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectNoir")
    }
    /// 色调
    class func photoEffectTonal() -> CIFilter?{
        return  CIFilter(name: "CIPhotoEffectTonal")
    }
    /// 岁月
    class func photoEffectTransfer() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectTransfer")
    }
    /// 单色
    class func photoEffectMono() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectMono")
    }
    /// 褪色
    class func photoEffectFade() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectFade")
    }
    /// 冲印
    class func photoEffectProcess() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectProcess")
    }
    /// 铬黄
    class func photoEffectChrome() -> CIFilter?{
        return CIFilter(name: "CIPhotoEffectChrome")
    }
   /// 美颜
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
    /// 棕色滤镜
    class func photoCISepiaTone()->CIFilter?{
        let f = CIFilter(name: "CISepiaTone")
        f?.setValue(0.9, forKey: kCIInputIntensityKey)
        return f
    }
    /// 漩涡扭曲
    class func vortexDistortion()->CIFilter?{
        let f = CIFilter(name: "CIVortexDistortion")
        return f
    }
    /// 凹凸扭曲
    class func bumpDistortion()->CIFilter?{
        return CIFilter(name: "CIBumpDistortion")
    }
    /// 凹凸扭曲线性
    class func bumpDistortionLinear()->CIFilter?{
        let f = CIFilter(name: "CIBumpDistortionLinear")
        f?.setValue(1, forKey: kCIInputAngleKey)
        f?.setValue(200, forKey: kCIInputRadiusKey)
        return f
    }
    /// AVC 镜头校正
    class func cameraCalibrationLensCorrection()->CIFilter?{
        return CIFilter(name: "CICameraCalibrationLensCorrection")
    }
    /// 环形飞溅扭曲
    class func circleSplashDistortion()->CIFilter?{
        return CIFilter(name: "CICircleSplashDistortion")
    }
    /// 高斯渐变
    class func gaussianGradient()->CIFilter?{
        let f = CIFilter(name: "CIGaussianGradient")
        // inputRadius   type NSNumber
        return f
    }
    /// 颜色映射
    class func colorMap()->CIFilter?{
        let f = CIFilter(name: "CIColorMap")
        return f
    }
    /// 圆形折回扭曲
    class func circularWrap()->CIFilter?{
        let f = CIFilter(name: "CICircularWrap")
        return f
    }
    /// 透视转换 旋转
    class func perspectiveTransform()->CIFilter?{
        let f = CIFilter(name: "CIPerspectiveTransform")
        return f
    }
    /// 校正 颠倒
    class func straightenFilter()->CIFilter?{
        if  let f = CIFilter(name: "CIStraightenFilter") {
            // 3.141592653589793 -3.141592653589793
            f.setValue(-3.141592653589793, forKey: kCIInputAngleKey)
            return f
        }
        return nil
    }
    /// 边缘
    class func edges()->CIFilter?{
        if let f = CIFilter(name: "CIEdges") {
            f.setValue(10, forKey: kCIInputIntensityKey)
            return f
        }
        return nil
    }
    /// 线覆盖图
    class func lineOverlay()->CIFilter?{
        let f = CIFilter(name: "CILineOverlay")
        return f
    }
    /// 自动改善
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
