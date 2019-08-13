//
//  SPPhotoSplicingFour.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingFour {
    class func sp_frameAndSpace(type:SPSPlicingType.FourType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.FourType,value : SPPhotoSplicingStruct)->CGRect{
        var x : CGFloat = 0
        var y :  CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index % 2 == 0 {
                w = w + value.margin + value.padding
            }else{
                w = w + value.padding
                x = width - w
            }
            if index < 2 {
                h = h + value.margin + value.padding
            }else{
                h = h + value.margin
                y = height - h
            }
        case .two:
            w = (width - value.margin * 2.0 - value.padding * 3.0) / 4.0
            h = height
            if index == 0 {
                w = w + value.margin + value.padding
            }else if index == 3 {
                w = w + value.margin
                x = width - w
            }else{
                x = w + value.margin + value.padding
                w = w + value.padding
                x = x + w * CGFloat(index - 1)
            }
        case .three:
            w = (width - value.margin * 2.0 - value.padding) / 3.0
            h = (height - value.margin * 2.0 - value.padding) / 3.0
            if index == 0 {
                w = w  + value.margin + value.padding
                h = h * 2.0  + value.margin + value.padding
            }else if index == 1 {
                w = w * 2.0  + value.margin
                h = h  + value.margin
                x = width - w
            }else if index == 2 {
                w = w + value.margin
                h = h + value.margin
                y = height - h
            }else{
                w = w * 2.0 + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding
                x = width - w
                y = height - h
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding) / 5.0
            h = (height - value.margin * 2.0 - value.padding) / 5.0
            if index == 0 {
                w = w * 3.0 + value.margin + value.padding
                h = h * 3.0 + value.margin + value.padding
            }else if index == 1 {
                w = w * 2.0 + value.margin
                 h = h * 3.0 + value.margin + value.padding
                x = width - w
            }else if index == 2 {
                w = w * 2.0 + value.margin
                h = h * 2.0 + value.margin
                y = height - h
            }else {
                w = w * 3.0 + value.margin + value.padding
                h = h * 2.0 + value.margin
                y = height - h
                x = width - w
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 3 {
                w = width
                h = h + value.margin + value.padding
                y = height - h
            }else {
                h = h * 2.0 + value.margin + value.padding
                if index == 0 || index == 2 {
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                }else{
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }
        case .six:
            w = (width - value.margin * 2.0 - value.padding ) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 0 || index == 3 {
                w = w + value.margin
                h = h + value.margin
                if index == 3 {
                    x = width - w
                    y = height - h
                }
            }else {
                w = w  + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding * 2.0
                if index == 1 {
                    x = width - w
                }else{
                    y = height - h
                }
            }
        case .seven:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 0 {
                w = w + value.margin + value.padding
                h = height
            }else if index == 3 {
                w = w * 2.0 + value.margin + value.padding
                x = width - w
                h = h + value.margin + value.padding
                y = height - h
            }else{
                h = h * 2.0 + value.margin + value.padding
                if index == 1 {
                    x = w + value.margin + value.padding
                    w = w + value.padding
                }else {
                    w = w + value.margin
                    x = width - w
                }
            }
        case .eight:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index < 2 {
                h = height
                if index == 0 {
                    w = w + value.margin
                }else{
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }
            }else{
                w = w + value.margin
                x = width - w
                h = (height - value.margin * 2.0 - value.padding) / 2.0
                h = h + value.margin
                if index == 3 {
                    h = h + value.padding
                    y = height - h
                }
            }
        case .nine:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding) / 3.0
            if index == 3 {
                h  = h * 2.0 + value.margin + value.padding
                y = height - h
                w = width
            }else {
                h = h + value.margin
                if index == 1 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                }
            }
        case .ten:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding) / 3.0
            if index == 0 {
                h  = h * 2.0 + value.margin + value.padding
                w = width
            }else {
                h = h + value.margin
                if index == 2 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 3 {
                        x = width - w
                    }
                }
                y = height - h
            }
        case .eleven:
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            if index < 3 {
                w = w + value.margin
                if index == 1 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    if index == 2 {
                        y = height - h
                    }
                }
            }else {
                w = w + value.margin + value.padding
                x = width - w
                h = height
            }
        case .twelve:
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            if index == 0 {
                w = w + value.margin + value.padding
                
                h = height
            }else {
                w = w + value.margin
                x = width - w
                if index == 2 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    if index == 3 {
                        y = height - h
                    }
                }
            }
        case .thirteen:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w + value.margin
                h = h + value.margin
            }else if index == 1 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                x = width - w
                h = h + value.margin
            }else if index == 2 {
                w = w + value.margin
                h = h * 2.0 + value.margin + value.padding * 2.0
                y = height - h
            }else{
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h * 2.0 + value.margin + value.padding * 2.0
                x = width - w
                y = height - h
            }
        case .fourteen:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 3 {
                w = w + value.margin
                h = h + value.margin
                x = width - w
                y = height - h
            }else if index == 2 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h + value.margin
                y = height - h
            }else if index == 1 {
                w = w + value.margin
                h = h * 2.0 + value.margin + value.padding * 2.0
                x = width - w
            }else{
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h * 2.0 + value.margin + value.padding * 2.0
            }
        default:
            sp_log(message: "没有")
        }
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.FourType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
            if index % 2 == 0 {
                left = margin
                right = padding
            }else{
                right = margin
            }
            if index < 2 {
                top = margin
                bottom = padding
            }else{
                bottom = margin
            }
        case .two:
            if index == 0 {
                left = margin
                right = padding
            }else if index == 3 {
                right = margin
            }else{
                right = padding
            }
            top = margin
            bottom = margin
        case .three:
            if index == 0{
                left = margin
                top = margin
                bottom = padding
                right = padding
            }else if index == 1 {
                top = margin
                right = margin
            }else if index == 2 {
                left = margin
                bottom = margin
            }else{
                left = padding
                top = padding
                right = margin
                bottom = margin
            }
        case .four:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                right = padding
            }else if index == 1 {
                top = margin
                right = margin
                bottom = padding
            }else if index == 2 {
                left = margin
                bottom = margin
            }else{
                left = padding
                right = margin
                bottom = margin
            }
        case .five:
            if index == 3 {
                left = margin
                right = margin
                bottom = margin
                top = padding
            }else {
                top = margin
                if index == 0 {
                    left = margin
                }else if index == 2 {
                    right = margin
                }else{
                    left = padding
                    right = padding
                }
            }
        case .six:
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                top = margin
                right = margin
                bottom = padding
            }else if index == 2 {
                left = margin
                right = padding
                top = padding
                bottom = margin
            }else{
                right = margin
                bottom = margin
            }
        case .seven:
            if index == 0 {
                left = margin
                top = margin
                bottom = margin
                right = padding
            }else if index == 3 {
                right = margin
                bottom = margin
                top = padding
            }else{
                top = margin
                if index == 1 {
                    right = padding
                }else{
                    right = margin
                }
            }
        case .eight:
            if index < 2 {
                if index == 0 {
                     left = margin
                }else{
                    left = padding
                    right = padding
                }
                top = margin
                bottom = margin
            }else{
                right = margin
                if index == 3 {
                    bottom = margin
                    top = padding
                }else{
                    top = margin
                }
            }
        case .nine:
            if index == 3 {
                left = margin
                right = margin
                bottom = margin
                top = padding
            }else{
                top = margin
                if index == 0 {
                    left = margin
                }else if index == 1 {
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
            }
        case .ten:
            if index == 0 {
                left = margin
                right = margin
                top = margin
                bottom = padding
            }else {
                bottom = margin
                if index == 1 {
                    left = margin
                }else if index == 2 {
                    left = padding
                    right = padding
                }else{
                    right = margin
                }
            }
        case .eleven:
            if index == 3 {
                left = padding
                top = margin
                right = margin
                bottom = margin
            }else{
                left = margin
                if index == 0 {
                    top = margin
                }else if index == 1 {
                    top = padding
                    bottom = padding
                }else{
                    bottom = margin
                }
            }
        case .twelve:
            if index == 0 {
                left = margin
                top = margin
                right = padding
                bottom = margin
            }else{
                right = margin
                if index == 1 {
                    top = margin
                }else if index == 2 {
                    top = padding
                    bottom = padding
                }else{
                    bottom = margin
                }
            }
        case .thirteen:
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                top = margin
                right = margin
            }else if index == 2 {
                left = margin
                top = padding
                bottom = margin
            }else{
                left = padding
                top = padding
                right = margin
                bottom = margin
            }
        case .fourteen:
            if index == 0 {
                left = margin
                top = margin
                right = padding
                bottom = padding
            }else if index == 1 {
                top = margin
                right = margin
                bottom = padding
            }else if index == 2 {
                left = margin
                right = padding
                bottom = margin
            }else{
                right = margin
                bottom = margin
            }
        default:
            sp_log(message: "没有")
        }
        return  (left,right,top,bottom)
    }
}
