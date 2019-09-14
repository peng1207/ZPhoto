//
//  SPPhotoSplicingEight.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class SPPhotoSplicingEight {
    class func sp_frameAndSpace(type:SPPhotoSPlicingType.EightType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPPhotoSPlicingType.EightType,value : SPPhotoSplicingStruct)->CGRect{
        var frame = CGRect.zero
        var x : CGFloat = 0
        var y : CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 || index == 3 || index == 6 {
                w = w + value.margin
                if index == 0 || index == 6 {
                    h = h + value.margin
                    if index == 6 {
                      y = height - h
                    }
                }else {
                    y = h + value.margin
                    h = h + value.padding * 2
                }
                
            }else if index == 2 || index == 5 || index == 7 {
                x = width - w - value.margin
                w = w + value.margin
                if index == 2 || index == 7 {
                    h = h + value.margin
                    if index == 7 {
                        y = height - h
                    }
                }else {
                    y = h + value.margin
                    h = h + value.padding * 2
                }
            }else if index == 1 || index == 4 {
                x = w + value.margin
                w = w + value.padding * 2.0
                h = (height - value.margin * 2.0 - value.padding) / 2.0
                h = h + value.margin
                if index == 4 {
                    y = h
                    h = h + value.padding
                }
                
            }
        case .two:
            if index == 2 || index == 5 || index == 7{
                h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
                w = w + value.margin + value.padding
                x = width - w
                if index == 2 || index == 7 {
                    h = h + value.margin
                    if index == 7 {
                        y = height - h
                    }
                }else {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }
            }else if index == 6 {
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0 * 2.0
                w = w + value.padding + value.margin
                h = height * 0.5
                y = height - h
            }else {
                h = (height * 0.5 - value.margin - value.padding) / 2.0
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
                if index == 0 || index == 3 {
                    w = w + value.margin
                }else  {
                    x = w + value.margin
                    w = w + value.padding
                }
                if index == 0 || index == 1 {
                    h = h + value.margin
                }else {
                    y = h + value.margin
                    h = h + value.padding
                }
            }
        case .three:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 3 {
                if index == 0 || index == 2 {
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                    
                }else {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
                h = h + value.margin
            }else if index == 3 {
                y = h + value.margin
                h = h + value.padding * 2.0
                w = w * 2.0 + value.padding * 2.0 + value.margin
            }else if index == 4 {
                y = h + value.margin
                h = h + value.padding * 2.0
                w = w + value.margin
                x = width - w
            }else {
                if index == 5 || index == 7 {
                    w = w + value.margin
                    if index == 7 {
                         x = width - w
                    }
                }else {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
                h = h + value.margin
                y = height - h
            }
        case .four:
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 3 || index == 4 {
                w = (width - value.margin * 2.0 - value.padding) / 2.0
                w = w + value.margin
                if index == 4 {
                    w = w + value.padding
                    x = width - w
                }
                y = h + value.margin
                h = h + value.padding * 2.0
            }else{
                w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
                h = h + value.margin
                if index == 0  || index == 5{
                    w = w + value.margin
                }else if index == 1 || index == 6{
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else if index == 2 || index == 7{
                     w = w + value.margin
                    x = width - w
                }
                if index > 4 {
                    y = height - h
                }
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index < 2 {
                h = height * 0.5
                
                if index == 0 {
                    w = w * 2.0 + value.padding * 2.0 + value.margin
                }else {
                    w = w + value.margin
                    x = width - w
                }
            }else{
                h = (height * 0.5 - value.margin - value.padding) / 2.0
                if index < 5 {
                    y = height * 0.5
                    h = h + value.padding
                }else{
                    h = h + value.margin
                    y = height - h
                }
                if index == 3 || index == 6 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 4 || index == 7 {
                        x = width - w
                    }
                }
            }
        case .six:
            w = (width - value.margin * 2.0  - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 2.0
            if index == 0 || index == 7 {
                w = w + value.margin
                h = h / 2.0 + value.margin
                if index == 7 {
                    w = w + value.padding
                    x = width - w
                    y = height - h
                }
            }else if index == 3 || index == 4 {
                w = w + value.margin
                if index == 4 {
                    w = w + value.padding
                    x = width - w
                }
                y = h / 2.0 + value.margin
                h = h + value.padding * 2.0
            }else if index == 1 || index == 2 {
                x = w + value.margin
                w = (w - value.padding) / 2.0
                h = h / 2.0 + value.margin
                if index == 1 {
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    x = width - w
                }
            }else {
                w = (w - value.padding) / 2.0
                h = h / 2.0 + value.margin
                if index == 5 {
                    w = w + value.margin
                }else {
                    x = w + value.margin
                    w = w + value.padding
                }
                y = height - h
            }
            
        case .seven:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            w = w + value.margin
            if index % 2 != 0{
                w = w + value.padding
                x = width - w
            }
            let index_y = index / 2
            if index_y == 0 {
                h = h + value.margin
            }else if index_y == 1 {
                y = h + value.margin
                h = h + value.padding
            }else if index_y == 2 {
                y = h * 2.0 + value.margin + value.padding
                h = h + value.padding * 2.0
            }else if index_y == 3 {
                h = h + value.margin
                y = height - h
            }
        case .eight:
            w = (width - value.margin * 2.0 - value.padding * 3.0 ) / 4.0
            h = (height - value.margin * 2.0 - value.padding) / 3.0
            if index == 0 || index == 3 || index == 4 || index == 7 {
                w = w + value.margin
                if index == 3 || index == 7 {
                    x = width - w
                }
            }else  if index == 1 || index == 5 {
                x = w + value.margin
                w = w + value.padding
            }else  if index == 2 || index == 6 {
                let w1 = w + value.padding * 2.0
                x = width - w1 - w - value.margin
                w = w1
            }
            if index == 0 || index == 2 || index == 5  || index == 7 {
                h = h * 2.0 + value.margin + value.padding
            }else {
                h = h + value.margin
            }
            if index > 3 {
                y = height - h
            }
        case .nine:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            if index == 0 || index == 2 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = (h * 3.0 + value.padding ) / 2.0
                if  index == 0 {
                    h = h + value.margin
                }else{
                    y = h + value.margin
                    h = h + value.padding
                }
            }else if index == 1 || index == 3 || index == 4 {
                w = w + value.margin
                x = width - w
                if index == 1 {
                    h = h + value.margin
                }else{
                    y = h + value.margin
                    h = h + value.padding
                    y = y + h * CGFloat(index - 3)
                }
            }else {
                h = h + value.margin + value.padding
                y = height - h
                if index == 5 || index == 7 {
                    w = w + value.margin
                    if index == 7 {
                        x = width - w
                    }
                }else{
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }
        case .ten:
            w = (width - value.margin * 2.0 - value.padding * 3.0) / 4.0
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            if index == 0 || index == 1 {
                h = h * 2.0 + value.margin + value.padding
                if index == 0 {
                    w = w + value.margin
                }else {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }else if index == 2 || index == 3 {
                w = w * 2.0 + value.margin + value.padding
                x = width - w
                if index == 2 {
                    h = h + value.margin
                }else{
                    y = h + value.margin
                    h = h + value.padding
                }
            }else if index == 4 || index == 5 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                if index == 4 {
                    y = h * 2.0 + value.margin + value.padding
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    y = height - h
                }
            }else {
                h = h * 2.0 + value.margin + value.padding * 2.0
                if index == 6 {
                    x = width - (w + value.margin)
                    w = w + value.padding
                    x = x - w
                }else{
                    w = w + value.margin
                    x = width - w
                }
                y = height - h
            }
        case .eleven:
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index < 3 {
                h = h + value.margin + value.padding
                if index % 2 != 0 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else {
                    w = w + value.margin
                    if index / 2 == 1 {
                        x = width - w
                    }
                }
            }else if index == 3 || index == 4 {
                w = width
                y = h + value.padding + value.margin
                h = h + value.padding
                y = y + h * CGFloat(index - 3)
                
            }else {
                h = h + value.margin
                y = height - h
                if index % 2 != 0 {
                     w = w + value.margin
                    if index == 7 {
                        x = width - w
                    }
                }else {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }
        case .twelve:
            h = (height - value.margin * 2.0 - value.padding * 3.0 ) / 4.0
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 1 || index == 2 || index == 5 || index == 6 {
                w = w * 2.0 + value.margin + value.padding * 2.0
            }else{
                w = w + value.margin
            }
            if index % 2 != 0 {
                x = width - w
            }
            if index == 0 || index == 1 {
                h = value.margin + h
            }else if index == 2 || index == 3 {
                y = h + value.margin
                h = h + value.padding
            }else if index == 4 || index == 5 {
                y = h + value.margin
                h = h + value.padding
                y = y + h
            }else{
                h = h + value.margin + value.padding
                y = height - h
            }
            
        default:
            sp_log(message: "没有其他类型")
        }
 
        frame = CGRect(x: x, y: y, width: w, height: h)
        return  frame
    }
    //MARK: - space
    private class func sp_space(type : SPPhotoSPlicingType.EightType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
             if index == 0 || index == 3 || index == 6 {
                left = margin
                if index == 0 {
                    top = margin
                }else if index == 3 {
                    top = padding
                    bottom = padding
                }else {
                    bottom = margin
                }
             }else if index == 2 || index == 5 || index == 7 {
                right = margin
                if index == 2 {
                    top = margin
                }else if index == 5 {
                    top = padding
                    bottom = padding
                }else {
                    bottom = margin
                }
             }else if index == 1 || index == 4 {
                left = padding
                right = padding
                if index == 1 {
                    top = margin
                }else {
                    top = padding
                    bottom = margin
                }
            }
        case .two:
            if index == 2 || index == 5 || index == 7{
                left = margin
                right = margin
                if index == 2 {
                    top = margin
                }else if index == 7 {
                    bottom = margin
                }else {
                    top = padding
                    bottom = padding
                }
            }else if index == 6 {
                left = margin
                bottom = margin
                top = padding
            }else {
                if index == 0 {
                    left = margin
                    top = margin
                }else if index == 1 {
                    left = padding
                    top = margin
                }else if index == 3 {
                    left = margin
                    top = padding
                }else {
                    top = padding
                    left = padding
                }
            }
        case .three:
            if index < 3 {
                top = value.margin
                if index == 0 {
                    left = margin
                }else if index == 2 {
                    right = margin
                }else{
                    left = padding
                    right = padding
                }
            }else if index == 3 {
                left = margin
                right = padding
                top = padding
                bottom = padding
            }else if index == 4 {
                right = margin
                top = padding
                bottom = padding
            }else {
                bottom = margin
                if index == 5 {
                    left = margin
                }else if index == 7{
                    right = margin
                }else {
                    left = padding
                    right = padding
                }
            }
        case .four:
            if index == 3 || index == 4 {
                top = padding
                bottom = padding
                if index == 3 {
                    left = margin
                }else {
                    left = padding
                    right = margin
                }
            }else {
                if index == 0  || index == 5{
                    left = margin
                }else if index == 1 || index == 6{
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
                if index < 3 {
                    top = margin
                }else{
                    bottom = margin
                }
            }
        case .five:
            if index < 2 {
                top = margin
                bottom = padding
                if index == 0 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }else{
                if index < 5 {
                    bottom = padding
                }else{
                    bottom = margin
                }
                if index == 3 || index == 6 {
                    left = padding
                    right = padding
                }else if index == 2 || index == 5 {
                    left = margin
                }else{
                    right = margin
                }
            }
        case .six :
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                top = margin
                right = padding
            }else if index == 2 {
                top = margin
                right = margin
            }else if index == 3 {
                left = margin
                top = padding
                bottom = padding
            }else if index == 4 {
                left = padding
                right = margin
                top = padding
                bottom = padding
            }else{
                 bottom = margin
                if index ==  5 {
                    left = margin
                }else if index == 6 {
                    left = padding
                }else{
                    left = padding
                    right = margin
                }
            }
        case .seven:
            if index % 2 != 0 {
                left = padding
                right = margin
            }else{
                left = margin
            }
            let index_y = index / 2
            if  index_y == 0 {
                top = margin
            }else if index_y == 1 {
                top = padding
            }else if index_y == 2 {
                top = padding
                bottom = padding
            }else if index_y == 3 {
                bottom = margin
            }
        case .eight:
            if index < 4 {
                top = margin
            }else{
                bottom = margin
            }
            if index == 0 || index == 4 {
                left = margin
                if index == 0 {
                    bottom = padding
                }
            }else if index == 1 || index == 5 {
                left = padding
                if index == 5 {
                    top = padding
                }
            }else if index == 2 || index == 6 {
                left = padding
                right = padding
                if index == 2 {
                    bottom = padding
                }
            }else {
                right = margin
                if  index == 7 {
                    top = padding
                }
            }
        case .nine:
            if index == 0 || index == 2 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                }else{
                    top = padding
                }
            }else if index == 1 || index == 3 || index == 4 {
                right = margin
                if index == 1 {
                    top = margin
                }else {
                    top = padding
                }
            }else{
                bottom = margin
                top = padding
                if index == 5 {
                    left = margin
                }else if index == 6 {
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
            }
        case .ten:
            if index == 0 || index == 1 {
                top = margin
                if index == 0 {
                    left = margin
                }else{
                    left = padding
                    right = padding
                }
            }else if index == 2 || index == 3 {
                right = margin
                if index == 2 {
                    top = margin
                }else{
                    top = padding
                }
            }else if index == 4 || index == 5 {
                left = margin
                right = padding
                if index == 4 {
                    top = padding
                    bottom = padding
                }else{
                    bottom = margin
                }
            }else {
                bottom = margin
                top = padding
                if index == 6 {
                    right = padding
                }else{
                    right = margin
                }
            }
        case .eleven:
            if index < 3 {
                top = margin
                bottom = padding
                if index % 2 != 0 {
                    left = padding
                    right = padding
                }else if index / 2 == 1 {
                    right = margin
                }else{
                    left = margin
                }
            }else if index == 3 || index == 4 {
                bottom = padding
                left = margin
                right = margin
            }else{
                bottom = margin
                if index == 5 {
                     left = margin
                }else if index == 7 {
                     right = margin
                }else{
                    left = padding
                    right = padding
                }
            }
        case .twelve:
            if index % 2 != 0 {
                right = margin
            }else{
                left = margin
            }
            
            if index == 0 || index == 1 {
                top = margin
                
            }else if index == 2 || index == 3 {
                top = padding
               
            }else if index == 4 || index == 5 {
                top = padding
            }else{
                top = padding
                bottom = margin
                
            }
            if index == 1 || index == 5 {
                left = padding
            }else if index == 2 || index == 6 {
                right = padding
            }
        default:
            sp_log(message: "没有其他类型")
        }
        return  (left,right,top,bottom)
    }
}
