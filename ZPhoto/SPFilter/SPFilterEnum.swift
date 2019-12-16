//
//  SPFilterEnum.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/9/11.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation

// MARK: -- 滤镜枚举
enum  SPFilterPhoto{
    case effectInstant ,effectNoir,effectTonal,effectTransfer,effectMono,effectFade,effectProcess,effectChrome,hueAdjust,vignetteEffect,sRGBToneCurveToLinear,sepiaTone,vortexDistortion,bumpDistortion,bumpDistortionLinear,cameraCalibrationLensCorrection,circleSplashDistortion,gaussianGradient,colorMap,circularWrap,perspectiveTransform,straightenFilter,edges,lineOverlay,gaussianBlur,oldMovies
    
    func introduced() -> String {
        switch self {
        case .effectChrome: return "铬黄"
        case .effectNoir: return "黑白"
        case .effectTonal: return "色调"
        case .effectTransfer: return "岁月"
        case .effectMono: return "单色"
        case .effectFade: return "褪色"
        case .effectProcess:return "冲印"
        case .hueAdjust:return "美颜"
        case .vignetteEffect: return "VignetteEffect"
        case .sRGBToneCurveToLinear: return "SRGBToneCurveToLinear"
        case .effectInstant:return "怀旧"
        case .sepiaTone: return "棕色"
        case .vortexDistortion: return "漩涡扭曲"
        case .bumpDistortion: return "凹凸扭曲"
        case .bumpDistortionLinear: return "凹凸扭曲线性"
        case .cameraCalibrationLensCorrection: return "AVC 镜头校正"
        case .circleSplashDistortion: return "环形飞溅扭曲"
        case .gaussianGradient: return "高斯渐变"
        case .colorMap: return "颜色映射"
        case .circularWrap: return "圆形折回扭曲"
        case .perspectiveTransform: return "透视转换"
        case .straightenFilter: return "校正"
        case .edges: return "边缘"
        case .lineOverlay: return "线覆盖图"
        case .gaussianBlur: return "高斯模糊"
        case .oldMovies: return "老电影"
        }
        
    }
    
}
protocol EnumeratableEnumType {
    static var allValues: [Self] {get}
}

extension SPFilterPhoto : EnumeratableEnumType{
    static var allValues :[SPFilterPhoto] {
        return [
            .effectInstant
            ,.effectNoir
            ,.effectTonal
            ,.effectTransfer
            ,.effectMono
            ,.effectFade
            ,.effectProcess
            ,.effectChrome
            ,.hueAdjust
            ,.sepiaTone
            ,.straightenFilter
            ,.bumpDistortionLinear
//            ,.gaussianBlur
//            ,.circularWrap
//            ,.perspectiveTransform
        ]
    }
}
