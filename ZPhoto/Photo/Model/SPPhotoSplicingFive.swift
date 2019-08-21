//
//  SPPhotoSplicingFife.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingFive {
    class func sp_frameAndSpace(type:SPSPlicingType.FiveType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.FiveType,value : SPPhotoSplicingStruct)->CGRect{
        var x : CGFloat = 0
        var y :  CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one:
            h = height * 0.5
            if index < 2 {
                w = (width - value.margin * 2.0 - value.padding) / 2.0
                if index == 0 {
                    w = w + value.margin
                }else{
                    w = w + value.padding + value.margin
                    x = width - w
                }
            }else {
                y = height - h
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
        case .two:
            w = (width - value.margin * 2.0  - value.padding) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w * 2.0 + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding * 2.0
            }else if index < 3 {
                w = w + value.margin
                x = width - w
                if index == 1 {
                    h = h + value.margin
                }else {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }
            }else{
                h = h + value.margin
                y = height - h
                
                if index == 3 {
                    w = w + value.padding + value.margin
                }else{
                    w = w * 2.0 + value.margin
                    x = width - w
                }
            }
        case .three:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            if index < 2 {
                h = (height - value.margin * 2.0 - value.padding) / 2.0
                w = w + value.margin + value.padding
                if index == 0 {
                    h = h + value.margin + value.padding
                }else{
                    h = h + value.margin
                    y = height - h
                }
            }else {
                h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
                w = w  + value.margin
                x = width - w
                if index % 2 != 0 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else{
                    h = h + value.margin
                    if index == 4 {
                        y = height - h
                    }
                }
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding ) / 3.0
            if index == 0 {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h * 2.0 + value.margin + value.padding
            }else if index == 1 {
                w = w + value.margin
                x = width - w
                h = h * 2.0 + value.margin + value.padding
            }else {
                h = h + value.margin
                y = height - h
                if index % 2 != 0 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 4 {
                        x = width - w
                    }
                }
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index < 4 {
                h  = (height - value.margin * 2.0 - value.padding) / 3.0
                if index == 0 || index == 3 {
                    h = h * 2.0 + value.margin + value.padding
                }else{
                    h = h + value.margin
                }
                w = w + value.padding
                if index == 0 || index == 1 {
                    w = w + value.margin
                }else{
                    x = w + value.margin
                }
                if index == 1 || index == 3 {
                    y = height - h
                }
                
            }else {
                w = w + value.margin
                h = height
                x = width - w
            }
        case .six:
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index < 3 {
                w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
                h = h + value.margin
                if index % 2 != 0 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                }
                
            }else{
                h = h + value.margin + value.padding
                y = height - h
                w = (width - value.margin * 2.0 - value.padding ) / 2.0
                w = w + value.margin
                if index == 4 {
                    w = w + value.padding
                    x = width - w
                }
            }
        case .seven:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index < 4 {
                if index == 1 {
                    x = w + value.margin
                    w = w + value.padding * 2.0
                }else{
                    w = w + value.margin
                    if index == 2 {
                        x = width - w
                    }
                }
                if index == 3 {
                    h = h + value.margin + value.padding
                    y = height - h
                }else{
                    h = h + value.margin
                }
                
            }else{
                h = h + value.margin + value.padding
                y = height - h
                w = w * 2.0 + value.margin + value.padding * 2.0
                x = width - w
            }
        case .eight:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding * 2.0
            }else if index == 1 || index == 2 || index == 4 {
                if index != 4 {
                    w = w + value.margin
                }else{
                    w = w * 0.75 + value.margin
                }
                x = width - w
                if index == 2 {
                    y = h + value.margin
                    h = h + value.padding * 2.0
                }else {
                    h = h + value.margin
                    if index == 4 {
                        y = height - h
                    }
                }
            }else{
                h = h + value.margin
                y = height - h
                w = w + w * 0.25 + value.margin + value.padding
            }
        case .nine:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding * 2.0
            }else if index < 4 {
                h = h + value.margin
                if index == 3 {
                    y = height - h
                }
                if index == 1 {
                    x = w + value.margin + value.padding
                    w = w + value.padding
                }else{
                    w = value.margin + w
                    if index == 2 {
                        x = width - w
                    }else{
                        w = w + value.padding
                    }
                }
            }else{
                w = w * 2.0 + value.margin + value.padding
                h = h * 2.0 + value.margin + value.padding * 2.0
                x = width - w
                y = height - h
            }
        case .ten:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index == 0 {
                h = height
                w = w + value.margin + value.padding
            }else {
                if index % 2 != 0 {
                    x = w + value.margin + value.padding
                    w = w + value.padding
                }else {
                    w = w + value.margin
                    x = width - w
                }
                if index < 3 {
                    h = h + value.margin
                }else{
                    h = h + value.margin + value.padding
                    y = height - h
                }
            }
        case .eleven:
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            if index == 4 {
                w = width
                h = h + value.margin + value.padding
                y = height - h
            }else{
                if index % 2 == 0 {
                    w = w + value.margin + value.padding
                }else{
                    w = w + value.margin
                    x = width - w
                }
                if index < 2 {
                    h = h + value.margin
                }else{
                    y = h + value.margin
                    h = h + value.padding
                }
            }
        case .twelve:
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            if index == 0 {
                w = width
                h = h + value.margin + value.padding
            }else{
                if index % 2 != 0 {
                    w = w + value.margin + value.padding
                }else{
                    w = w + value.margin
                    x = width - w
                }
                if index < 3 {
                    y = h + value.margin + value.padding
                    h = h + value.padding
                }else{
                    h = h + value.margin
                    y = height - h
                }
            }
        case .thirteen:
            w = (width - value.margin * 2.0 - value.padding * 3.0) / 4.0
            h = (height - value.margin * 2.0 - value.padding * 3.0) / 4.0
            if index == 0 {
                w = w * 3.0 + value.padding * 3.0 + value.margin
                h = height
            }else{
                w = w + value.margin
                x = width - w
                if index == 1 {
                    h = h + value.margin
                }else if index < 4 {
                    y = h + value.margin
                    h = h + value.padding
                    y = y + h * CGFloat(index - 2)
                }else{
                    h = h + value.margin + value.padding
                    y = height - h
                }
            }
        case .fourteen:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 2 {
                y = h + value.margin
                h = h + value.padding * 2
                w = width
            }else{
                if index == 0 || index == 3 {
                    w = w + value.margin + value.padding
                }else{
                    w = w + value.margin
                    x = width - w
                }
                h = h + value.margin
                if index == 3 || index == 4 {
                    y = height - h
                }
            }
        case .fifteen:
            w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 4 {
                x = w + value.margin + value.padding
                y = h + value.margin + value.padding
            }else{
                if index == 0 {
                    w = w * 2.0 + value.margin + value.padding
                    h = h + value.margin + value.padding
                }else if index == 1 {
                    w = w + value.margin + value.padding
                    x = width - w
                    h = h * 2.0 + value.margin + value.padding
                }else if index == 2 {
                    w = w + value.margin + value.padding
                    h = h * 2.0 + value.margin + value.padding
                    y = height - h
                }else{
                    w = w * 2.0 + value.margin + value.padding
                    h = h + value.margin + value.padding
                    y = height - h
                    x = width - w
                }
            }
        case .sixteen:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 || index == 4 {
                w = w + value.margin
                h = h + value.margin
                if index == 4 {
                    x = width - w
                    y = height - h
                }
            }else if index == 2 {
                w = width
                y = h + value.margin
                h = h + value.padding * 2.0
            }else {
                w = w * 2.0 + value.margin + value.padding * 2.0
                h = h + value.margin
                if index == 3 {
                    y = height - h
                }else {
                    x = width - w
                }
            }
        case .seventeen:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = width
                h = h + value.margin + value.padding
            }else {
                if index == 1 || index == 4 {
                    w = w + value.margin
                    if index == 4 {
                        h = h + value.margin
                        y = height - h
                        x = width - w
                    }else{
                        y = h + value.margin + value.padding
                        h = h + value.padding
                    }
                }else {
                    w = w * 2.0 + value.margin + value.padding * 2.0
                    if index == 2 {
                        y = h + value.margin + value.padding
                        x = width - w
                        h = h + value.padding
                    }else{
                        h = h + value.margin
                        y = height - h
                    }
                }
            }
        default:
            sp_log(message: "没有")
        }
          return CGRect(x: x, y: y, width: w, height: h)
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.FiveType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
            if index < 2 {
                top = margin
                if index == 0 {
                    left = margin
                }else{
                    right = margin
                    left = padding
                }
            }else{
                bottom = margin
                top = padding
                if index % 2 != 0 {
                    left = padding
                    right = padding
                }else if index == 4 {
                    right = margin
                }else{
                    left = margin
                }
            }
        case .two:
            if index == 0 {
                left = margin
                top = margin
                right = padding
                bottom = padding
            }else if index < 3 {
                right = margin
                if index == 1 {
                    top = margin
                }else{
                    top = padding
                    bottom = padding
                }
            }else{
                bottom = margin
                if index == 3 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }
        case .three:
            if index < 2 {
                left = margin
                right = padding
                if index == 0 {
                    top = margin
                    bottom = padding
                }else{
                    bottom = padding
                }
            }else{
                right = margin
                if index % 2 != 0 {
                    top = padding
                    bottom = padding
                }else if index == 4 {
                    bottom = margin
                }else{
                    top = margin
                }
            }
        case .four:
            if index == 0 || index == 1 {
                top = margin
                bottom = padding
                if index == 0 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }else{
                bottom = margin
                if index % 2 != 0 {
                    left = padding
                    right = padding
                }else if index == 4 {
                    right = margin
                }else{
                    left = margin
                }
            }
        case .five:
            if index == 4 {
                top = margin
                bottom = margin
                right = margin
            }else{
                right = padding
                if index == 0 || index == 1 {
                    left = margin
                }
                if index == 0 || index == 2 {
                    top = margin
                }else{
                    bottom = margin
                }
                if index == 0 {
                    bottom = padding
                }else if index == 3 {
                    top = padding
                }
            }
        case .six :
            if index < 3 {
                top = margin
                if index % 2 != 0 {
                    left = padding
                    right = padding
                }else if index == 2 {
                    right = margin
                }else{
                    left = margin
                }
            }else{
                bottom = margin
                top = padding
                if index == 3 {
                    left = margin
                }else{
                    right = margin
                    left = padding
                }
            }
        case .seven:
            if index < 3 {
                top = margin
                if index == 0 {
                    left = margin
                }else if index == 1{
                    left = padding
                    right = padding
                }else{
                    right = padding
                }
            }else{
                top = padding
                bottom = margin
                if index == 3 {
                    left = margin
                }else{
                    left = padding
                    right = margin
                }
            }
        case .eight:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                right = padding
            }else if index == 1 || index == 2 || index == 4 {
                right = margin
                if index == 1 {
                    top = margin
                }else if index == 2{
                    top = padding
                    bottom = padding
                }else{
                    bottom = margin
                }
            }else{
                left = margin
                bottom = margin
                right = padding
            }
        case .nine:
            if index == 0 {
                left = margin
                top = margin
                right = padding
                bottom = padding
            }else if index < 3 {
                top = margin
                if index == 1 {
                    right = padding
                }else{
                    right = margin
                }
                
            }else if index == 3 {
                left = margin
                bottom = margin
                right = padding
            }else {
                right = margin
                bottom = margin
                top = padding
            }
        case .ten:
            if index == 0 {
                left = margin
                top = margin
                bottom = margin
                right = padding
            }else {
                if index % 2 != 0 {
                    right = padding
                }else{
                    right = margin
                }
                if index < 3 {
                    top = margin
                }else{
                    top = padding
                    bottom = margin
                }
            }
        case .eleven:
            if index == 4 {
                left = margin
                right = margin
                bottom = margin
                top = padding
            }else {
                if index % 2 == 0 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
                if index < 2 {
                    top = margin
                }else{
                    top = padding
                }
            }
        case .twelve:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                right = margin
            }else{
                if index % 2 != 0 {
                    left = margin
                    right = padding
                }else {
                    right = margin
                }
                if index < 3 {
                    bottom = padding
                }else{
                    bottom = margin
                }
            }
        case .thirteen:
            if index == 0 {
                left = margin
                right = padding
                top = margin
                bottom = margin
            }else{
                right = margin
                if index == 0 {
                    top = margin
                }else if index < 4 {
                    top = padding
                }else{
                    top = padding
                    bottom = margin
                }
            }
        case .fourteen:
            if index == 2 {
                left = margin
                right = margin
                top = padding
                bottom = padding
            }else{
                if index == 0 || index == 3 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
                if index < 2 {
                    top = margin
                }else{
                    bottom = margin
                }
            }
        case .fifteen:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
            }else if index == 1 {
                top = margin
                right = margin
                left = padding
            }else if index == 2 {
                left = margin
                bottom = margin
                right = padding
            }else if index == 3 {
                top = padding
                right = margin
                bottom = margin
            }
        case .sixteen:
            if index == 2 {
                left = margin
                right = margin
                top = padding
                bottom = padding
            }else if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                right = margin
                top = margin
                left = padding
            }else if index == 3 {
                left = margin
                bottom = margin
                right = padding
            }else{
                right = margin
                bottom = margin
            }
        case .seventeen:
            if index == 0 {
                left = margin
                right = margin
                top = margin
                bottom = padding
            }else if index < 3 {
                bottom = padding
                if index == 1 {
                    left = margin
                }else {
                    right = margin
                    left = padding
                }
            }else{
                bottom = margin
                if index == 3 {
                    left = margin
                    right = padding
                }else{
                    right = margin
                }
            }
        default:
            sp_log(message: "没有")
        }
        return  (left,right,top,bottom)
    }
}
