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
    case EffectInstant ,EffectNoir,EffectTonal,EffectTransfer,EffectMono,EffectFade,EffectProcess,EffectChrome,HueAdjust,VignetteEffect,SRGBToneCurveToLinear
    
    func introduced() -> String {
        switch self {
        case .EffectChrome: return "铬黄"
        case .EffectNoir: return "黑白"
        case .EffectTonal: return "色调"
        case .EffectTransfer: return "岁月"
        case .EffectMono: return "单色"
        case .EffectFade: return "褪色"
        case .EffectProcess:return "冲印"
        case .HueAdjust:return "美颜"
        case .VignetteEffect: return "VignetteEffect"
        case .SRGBToneCurveToLinear: return "SRGBToneCurveToLinear"
        case .EffectInstant:return "怀旧"
        }
        
    }
    
}
protocol EnumeratableEnumType {
    static var allValues: [Self] {get}
}

extension SPFilterPhoto : EnumeratableEnumType{
    static var allValues :[SPFilterPhoto] {
        return [.EffectInstant ,.EffectNoir,.EffectTonal,.EffectTransfer,.EffectMono,.EffectFade,.EffectProcess,.EffectChrome,.HueAdjust]
    }
}
