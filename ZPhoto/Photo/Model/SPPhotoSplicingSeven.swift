//
//  SPPhotoSplicingSeven.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingSeven {
    class func sp_frameAndSpace(type:SPSPlicingType.SevenType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.SevenType,value : SPPhotoSplicingStruct)->CGRect{
        var x : CGFloat = 0
        var y :  CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        var height = value.height
        let index = value.index
        switch type {
        case .one:
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 || index == 3 || index == 4 {
                w = w + value.margin + value.padding
                if index == 0 || index == 4 {
                    h = h + value.margin
                    if index == 4 {
                        y = height - h
                    }
                }else{
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }
            }else{
                w = w * 2.0
                h = (height - value.margin * 2.0 - value.padding) * 0.5
                if index == 1 {
                    x = width - w - value.padding - value.margin
                    h = h + value.margin + value.padding
                    w = w * 2.0 / 3.0
                }else if index == 6 {
                    h = h + value.margin
                    y = height - h
                    w = w * 2.0 / 3.0 + value.margin + value.padding
                    x = width - w
                }else if index == 2 {
                    h = h + value.margin + value.padding
                    w = w / 3.0 + value.padding + value.margin
                    x = width - w
                }else if index == 5 {
                    x = width - w - value.padding - value.margin
                    h = h + value.margin
                    y = height - h
                    w = w / 3.0
                }
                
            }
        case .two:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w + value.margin
                h = h + value.margin
            }else if index == 1 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h + value.margin
                x = width - w
            }else if index < 5 {
               
                y = h + value.margin
                h = h + value.padding + value.padding
                if  index == 2 || index == 4 {
                     w = w + value.margin
                    if index == 4 {
                        x = width - w
                    }
                }else if index == 3 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }else {
                if index == 5 {
                     w = w * 2.0 + value.margin + value.padding * 2.0
                }else{
                    w = w + value.margin
                    x = width  - w
                }
               
                h = h + value.margin
                y = height - h
            }
        case .three:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 6 {
                if index == 1 || index == 4 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 2 || index == 5 {
                        x = width - w
                    }
                }
                if index / 3 == 1 {
                    y = h + value.margin
                    h = h + value.padding
                }else{
                    h = h + value.margin
                }
                
            }else{
                w = width
                h = h + value.margin + value.padding
                y = height - h
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 || index == 2 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                if index == 2 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else {
                    h = h + value.margin
                }
            }else if index == 5 {
                x = w + value.margin
                w = w + value.padding * 2.0
                h = h + value.margin
                y = height - h
            }else{
                w = w + value.margin
                if index != 4 {
                    x = width - w
                }
                if index > 3 {
                    h = h + value.margin
                    y = height - h
                }else if index == 3 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                }
            }
        case .five :
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 0 || index == 1 {
                w = (width - value.margin * 2.0 - value.padding) / 3.0
                h = h + value.margin
                if index == 0 {
                    w = w + value.margin + value.padding
                }else{
                    w = w * 2.0 + value.margin
                    x = width - w
                }
            }else if index == 2 || index == 3 {
                w = (width - value.margin * 2.0 - value.padding) / 2.0
                y = h + value.margin
                h = h + value.padding * 2.0
                w = w + value.margin
                if index == 2 {
                    w = w + value.padding
                }else{
                    x = width - w
                }
            }else{
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
                if  index % 2 != 0 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else {
                    w = w + value.margin
                    if index == 6 {
                        x = width - w
                    }
                }
                h = h + value.margin
                y = height - h
            }
        case .six:
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            w = (width - value.margin * 2.0 -  value.padding * 3.0) / 4.0
            if index == 0 {
                h = height
                w = w + value.margin + value.padding
            }else{
                if index % 3 == 0 {
                    w = w + value.margin
                    x = width - w
                }else {
                    x = w + value.margin + value.padding
                    w = w + value.padding
                    if index == 1 || index == 5 {
                        x = x + w
                    }
                }
                h = h + value.margin
                if index >= 4 {
                   h = h + value.padding
                    y = height - h
                }
            }
        case .seven:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 3 {
                h = h + value.margin
                if index == 1 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else {
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                }
            }else if index == 3 {
                w = width
                y = h + value.margin
                h = h + value.padding * 2.0
            }else {
                h = h + value.margin
                y = height - h
                if index == 5 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else {
                    w = w + value.margin
                    if index == 6 {
                        x = width - w
                    }
                }
            }
        case .eight:
            w = (width - value.margin * 2.0 - value.padding) /  3.0
            
            if  index < 3 {
                h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
                w = w * 2.0 + value.margin + value.padding
                
                if index == 1 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    if index == 2 {
                        y = height - h
                    }
                }
            } else {
                h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
                w = w + value.margin
                x = width - w
                if index % 3 == 0 {
                    h = h + value.margin
                    if index / 3 == 2 {
                        h = h + value.padding
                        y = height - h
                    }
                }else{
                    y = h + value.margin
                    h = h + value.padding
                    y = y + h * CGFloat(index - 4)
                }
                
            }
        default:
            sp_log(message: "没有其他")
        }
        
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.SevenType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
            if index == 0 || index == 3 || index == 4 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else if index == 4 {
                    bottom = margin
                }else{
                    top = padding
                    bottom = padding
                }
            }else {
                if index == 1 || index == 2 {
                    top = margin
                    bottom = padding
                    
                }else if index == 5 || index == 6 {
                    bottom = margin
                }
                if index == 6 || index == 2 {
                    left = padding
                    right = margin
                }
            }
        case .two:
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                top = margin
                right = margin
            }else if index < 5 {
                top = padding
                bottom = padding
                if index == 2 {
                    left = margin
                }else if index == 3 {
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
            }else{
                bottom = margin
                if index == 5 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }
        case .three:
            if index < 6 {
                
                if index == 1 || index == 4 {
                    left = padding
                    right = padding
                }else if index == 2 || index == 5 {
                    right = margin
                }else{
                    left = margin
                }
                
                if index / 3 == 1 {
                    top =  padding
                }else {
                    top = margin
                }
            }else{
                left = margin
                right = margin
                bottom = margin
                top = padding
            }
        case .four:
            if index == 0 || index == 2 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else{
                    top = padding
                    bottom = padding
                }
            }else if index == 5 {
                left = padding
                right = padding
                bottom = margin
            }else{
                if index > 3 {
                    bottom = margin
                    if index == 4 {
                        left = margin
                    }else{
                        right = margin
                    }
                }else {
                    right = margin
                    if index == 1 {
                        top = margin
                    }else {
                        top = padding
                        bottom = padding
                    }
                }
            }
        case .five:
            if index == 0 || index == 1 {
                top = margin
                if index == 0 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }else if index == 2 || index == 3 {
                top = padding
                bottom = padding
                if index == 2 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }else{
                bottom = margin
                if index == 4 {
                    left = margin
                }else if index == 5 {
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
            }
        case .six :
            if index == 0 {
                left = margin
                top = margin
                bottom = margin
                right = padding
            }else{
                if index % 3 == 0 {
                    right = margin
                }else {
                    right = padding
                }
                if index > 3 {
                    bottom = margin
                    top = padding
                }else{
                    top = margin
                }
            }
        case .seven:
            if index < 3 {
                top = margin
                if index == 0 {
                    left = margin
                }else if index == 1 {
                    left = padding
                    right = padding
                }else{
                    right = padding
                }
            }else if index == 3 {
                left = margin
                right = margin
                top = padding
                bottom = padding
            }else{
                bottom = margin
                if index == 4 {
                    left = margin
                }else if index == 5 {
                    left = padding
                    right = padding
                }else{
                    right = padding
                }
            }
        case .eight:
            if index < 3 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else if index == 1 {
                    top = padding
                    bottom = padding
                }else{
                    bottom = padding
                }
            }else {
                right = margin
                if index % 3 == 0 {
                    if index / 3 == 2 {
                        bottom = margin
                        top = padding
                    }else{
                        top = margin
                    }
                }else{
                    top = padding
                }
            }
        default:
            sp_log(message: "没有其他")
        }
        return  (left,right,top,bottom)
    }
}
