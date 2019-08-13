
//
//  SPPhotoSplicingSix.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingSix {
    class func sp_frameAndSpace(type:SPSPlicingType.SixType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.SixType,value : SPPhotoSplicingStruct)->CGRect{
        var x : CGFloat = 0
        var y :  CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding ) / 2.0
            if index == 1 || index == 4 {
                x = w + value.margin
                w = w + value.padding * 2.0
            }else{
                w = w + value.margin
                if index == 2 || index == 5 {
                    x = width - w
                }
            }
            if index < 3 {
                h = h + value.margin
            }else{
                h = h + value.margin + value.padding
                y = height - h
            }
        case .two:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding) / 3.0
            if index == 0 || index == 5 {
                w = w + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding
                if index == 5 {
                    x = width - w
                    y = height - h
                }
            }else{
                x = w + value.margin + value.padding
                 w = (w - value.padding) / 2.0
                 h = h + value.margin
                if index == 1 {
                    w = w + value.padding
                }else if index == 2 {
                    w = w + value.margin
                    x = width - w
                }else {
                    y = height - h
                    if index == 3 {
                        x = 0
                        w = w + value.margin
                    }else{
                        x = w + value.margin
                        w = w + value.padding
                    }
                }
                
            }
            
        case .three:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h * 2.0 + value.margin + value.padding * 2.0
            }else {
                if index == 4 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else {
                    w = w + value.margin
                    if index != 3 {
                        x = width - w
                    }
                }
                if index == 2 {
                    y = h + value.margin
                    h = h + value.padding  * 2.0
                }else {
                    h = h + value.margin
                    if index != 1 {
                        y = height - h
                    }
                }
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index % 2 == 0 {
                w = w + value.margin + value.padding
            }else{
                w = w + value.padding
                x = width - w
            }
            if index / 2 == 1 {
                y = h + value.margin
                h = h + value.padding * 2.0
            }else{
                h = h + value.margin
                if index / 2 == 2 {
                    y = height - h
                }
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index < 3 {
                h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
                w = w + value.margin + value.padding
                if index == 1 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    if index == 2 {
                        y = height - h
                    }
                }
            }else{
                h = height * 0.5
                if index == 3 {
                    w = w * 2.0 + value.margin + value.padding
                    x = width - w
                }else{
                    y = height - h
                    if index == 4 {
                        x = w + value.margin + value.padding
                        w = w + value.padding
                    }else{
                        w = w + value.margin
                        x = width - w
                    }
                }
            }
        case .six:
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index / 2 == 1 {
                y = h + value.margin
                w = (width - value.margin * 2.0 - value.padding ) / 2.0
                h = h + value.padding * 2.0
                if index % 2 != 0 {
                    w = w + value.margin + value.padding
                }else{
                    w = w + value.margin
                }
            }else{
                w = (width - value.margin * 2.0 - value.padding) / 3.0
                if index == 0 || index == 5 {
                    w = w + value.margin + value.padding
                }else {
                    w = w * 2.0 + value.margin
                }
                h = h + value.margin
                if index / 2 == 2 {
                    y = height - h
                }
                
            }
            if index % 2 != 0 {
                x = width - w
            }
        case .seven:
             h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 2{
                h = h + value.margin
                w = (width - value.margin * 2.0 - value.padding) / 2.0
                w = w + value.margin
                if index == 0 {
                    w = w + value.padding
                }else{
                    x = width - w
                }
            }else if index == 5 {
                h = h + value.margin
                y = height - h
                w = width
            }else{
                y = h + value.margin
                h = h + value.padding * 2.0
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
                if index % 2 == 0 {
                    w = w + value.margin
                    if index == 4 {
                        x = width - w
                    }
                }else{
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }
        case .eight:
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            w = (width - value.margin * 2.0 - value.padding) / 3.0
            if index % 2 == 0 {
                w = w + value.margin + value.padding
            }else{
                w = w * 2.0 + value.padding
                x = width - w
            }
            if index / 2 == 1 {
                y = h + value.margin
                h = h + value.padding * 2.0
            }else{
                h = h + value.margin
                if index / 2 == 2 {
                    y = height - h
                }
            }
        case .nine:
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 3 {
                h = h + value.margin + value.padding
                if index == 1 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 2{
                        x = width - w
                    }
                }
            }else if index == 3 {
                w = w + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding
                 y = height - h
            }else {
                w = w * 2.0 + value.margin + value.padding
                x = width - w
                if index == 4 {
                    y = h + value.margin + value.padding
                    h = h + value.padding
                }else{
                    h = h + value.margin
                     y = height - h
                }
               
            }
        case .ten :
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 || index == 3 || index == 4 {
                w = w * 2.0 + value.margin + value.padding * 2.0
            }else {
                w = w + value.margin
            }
            if index % 2 != 0 {
                x = width - w
            }
            if index / 2 == 1 {
                y = h + value.margin
                h = h + value.padding * 2.0
            }else {
                h = h + value.margin
                if index / 2 == 2 {
                    y = height - h
                }
            }
        case .eleven:
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            if index == 0 || index == 5 {
                h = h + value.margin
                if index == 5 {
                    h = h + value.padding
                    y = height - h
                }
                w = width
            }else{
                w = (width - value.margin * 2.0 - value.padding) / 2.0
                if index % 2 == 0 {
                    w = w + value.margin + value.padding
                    x = width - w
                }else {
                    w = w + value.margin
                }
                y = h + value.margin
                h = h + value.padding
                y = y + h *  (CGFloat(index / 3))
            }
        case .twelve:
             h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
             w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
             if index < 4 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                if index == 0 {
                    h = h + value.margin
                }else if index == 3 {
                    h = h + value.margin + value.padding
                    y = height - h
                }else{
                    y = h + value.margin
                    h = h + value.padding
                    y = y + h * CGFloat(index - 1)
                }
             }else{
                w = w + value.margin
                x = width - w
                if index == 4 {
                     h = h * 3.0 + value.padding * 2.0 + value.margin
                }else{
                    h = h + value.margin + value.padding
                    y = height - h
                }
             }
        default:
            
            sp_log(message: "没有其他")
        }
        
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.SixType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
            if index < 3 {
                top = margin
            }else{
                top = padding
                bottom = margin
            }
            if index == 1 || index == 4 {
                left = padding
                right = padding
            }else if index == 2 || index == 5 {
                right = margin
            }else{
                left = margin
            }
        case .two :
            if index == 0 {
                left = margin
                right = padding
                bottom = padding
                top = margin
            }else if index == 5 {
                left = padding
                right = margin
                top = padding
                bottom = margin
            }else if index == 1 || index == 2{
                top = margin
                if index == 1 {
                    right = padding
                }else{
                    right = margin
                }
            }else {
                bottom = margin
                if index == 3 {
                    left = margin
                }else{
                    left = padding
                }
            }
        case .three:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                right = padding
            }else{
                if index == 2 {
                    top = padding
                    bottom = padding
                    right = margin
                }else if index == 4 {
                    left = padding
                    right = padding
                    bottom = margin
                }else if index == 1 {
                    top = margin
                    right = margin
                }else{
                    bottom = margin
                    if index == 3 {
                        left = margin
                    }else{
                        right = margin
                    }
                }
            }
        case .four:
            if index % 2 == 0 {
                left = margin
                right = padding
            }else {
                right = margin
            }
            if index / 2 == 1 {
                top = padding
                bottom = padding
            }else if index / 2 == 2 {
                bottom = margin
            }else{
                top = margin
            }
        case .five:
            if index < 3 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else if index == 1 {
                    top = padding
                    bottom = padding
                }else{
                    bottom = margin
                }
            }else{
                if index == 3 {
                    top = margin
                    right = margin
                }else{
                    top = padding
                    bottom = margin
                    if index == 4 {
                        right = padding
                    }else{
                        right = margin
                    }
                }
            }
        case .six:
            if index / 2 == 1 {
                top = padding
                bottom = padding
            }else if index / 2 == 2 {
                bottom = margin
            }else{
                top = margin
            }
            if index % 2 == 0 {
                left = margin
            }else{
                left = padding
                right = margin
            }
        case .seven:
            if index < 2 {
                top = margin
                if index == 0 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }else if index == 5 {
                left = margin
                right = margin
                bottom = margin
            }else{
                top = padding
                bottom = padding
                if index % 2 == 0 {
                    if index == 2 {
                        left = margin
                    }else{
                        right = margin
                    }
                }else{
                    left = padding
                    right = padding
                }
            }
        case .eight:
            if index % 2 == 0 {
                left = margin
                right = padding
            }else{
                right = padding
            }
            if index / 2 == 1 {
                top = padding
                bottom = padding
            }else if index / 2 == 2 {
                bottom = margin
            }else{
                top = margin
            }
        case .nine:
            if index < 3 {
                top = margin
                bottom = padding
                if index == 1 {
                    left = padding
                    right = padding
                }else if index == 0 {
                    left = margin
                }else{
                    right = margin
                }
            }else if index == 3 {
                left = margin
                bottom = margin
                right = padding
            }else {
                right = margin
                if index == 4 {
                    bottom = padding
                }else{
                    bottom = margin
                }
            }
        case .ten:
            if index % 2 == 0 {
                left = margin
            }else {
                right = margin
            }
            if index  / 2 == 1 {
                top = padding
                bottom = padding
            }else if index / 2 == 2 {
                bottom = margin
            }else{
                top = margin
            }
            if index == 0 ||  index == 4{
                right = padding
            }else if index == 3 {
                left = padding
            }
        case .eleven:
            if index == 0 || index == 5 {
                left = margin
                right = margin
                if index == 0 {
                    top = margin
                }else{
                    top = padding
                    bottom = margin
                }
            }else{
                if index % 2 == 0 {
                    right = margin
                    left = padding
                }else {
                    left = margin
                }
                top = padding
            }
        case .twelve:
            if index < 4 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else if index == 3 {
                    bottom = margin
                    top = padding
                }else{
                    top = padding
                }
            }else{
                right = margin
                if index == 5 {
                    bottom = margin
                    top = padding
                }else{
                    top = margin
                }
            }
        default:
            sp_log(message: "没有其他")
        }
        
        return  (left,right,top,bottom)
    }
}
