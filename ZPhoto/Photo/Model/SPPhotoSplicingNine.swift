//
//  SPPhotoSplicingNine.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/13.
//  Copyright © 2019 huangshupeng. All rights reserved.
//
// 获取九张图片的布局

import Foundation
import UIKit
import SPCommonLibrary

class SPPhotoSplicingNine {
    
    class func sp_frameAndSpace(type:SPSPlicingType.NineType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    
    private class func sp_frame(type : SPSPlicingType.NineType,value : SPPhotoSplicingStruct)->CGRect{
        var frame = CGRect.zero
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one , .two:
            var w = (width - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            var h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index / 3 == 1 {
                y = h + value.margin
                h = h + value.padding * 2.0
            }else {
                h = h + value.margin
                if index / 3 != 0 {
                    y = height - h
                }
            }
            if index % 3 == 1 {
                 x = w + value.margin
                w = w + value.padding * 2.0
            }else{
                w = w + value.margin
                if index % 3 != 0 {
                    x = width - w
                }
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
            
        case .three:
            let w : CGFloat = width / 5.0
            var h : CGFloat = height / 2.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index == 0 {
                x = 0
                y = 0
                h = height
            }else if index < 5{
                x = CGFloat(index) * w
            }else if index < 9 {
                x = CGFloat(index - 4) * w
                y = h
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .four :
            var w : CGFloat = width / 3.0
            var h :  CGFloat = height / 4.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index == 0 {
                w = w * 2
                h = h * 2
            }else if index == 1 {
                x = w  * 2
            }else if index == 2 {
                x = w * 2
                y = h
            }else if index < 6{
                x = w *  CGFloat(index - 3)
                y = h * 2.0
            }else if index < 9 {
                x = w *  CGFloat(index - 6)
                y = h * 3.0
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .five:
            var w : CGFloat = width / 4.0
            var h : CGFloat = height / 3.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index == 0 {
                h = h * 2.0
            }else if index < 4 {
                x = w * CGFloat(index)
            }else if index < 7 {
                x = w * CGFloat(index - 3)
                y = h
            }else if index < 9 {
                y = h * 2.0
                if index == 8 {
                    x = w + 10.0
                    w = width - w - 10.0
                }else{
                    w = w + 10.0
                }
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .six:
            var w : CGFloat = width / 4.0
            var h : CGFloat = height / 4.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index == 0 {
                w = w + w * 0.5
            }else if index == 1 {
                x = w + w * 0.5
                w = w + w * 0.5
            }else if index == 2 {
                x = width - w
                h = h + h * 0.5
            }else if index == 3 {
                y = h
                h = h + h * 0.5
            }else if index == 4 {
                x = w
                y = h
                w = width - 2 * w
                h = height - 2 * h
            }else if index == 5 {
                x = width - w
                y = h + h * 0.5
                h = h + h * 0.5
            }else if index == 6 {
                h = h + h * 0.5
                y = height - h
            }else if index == 7 {
                x = w
                w = w + w * 0.5
                y = height - h
            }else if index == 8 {
                w = w + w * 0.5
                x = width - w
                y = height - h
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .seven:
            var w : CGFloat = width / 5.0
            var h : CGFloat = height / 5.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index == 1 {
                x = w
                w = w * 3.0
            }else if index == 2 {
                x = width - w
            }else if index == 3 {
                y = h
                h = h * 3.0
            }else if index == 4 {
                x = w
                y = h
                w = w * 3.0
                h = h * 3.0
            }else if index == 5 {
                x = width - w
                y = h
                h = h * 3.0
            }else if index == 6 {
                y = height - h
            }else if index == 7 {
                y = height - h
                x = w
                w = w * 3.0
            }else if index == 8{
                x = width - w
                y = height - h
            }
            
            frame = CGRect(x: x, y: y, width: w, height: h)
            
        case .eight:
            var w : CGFloat = width / 3.0
            let h : CGFloat = height / 3.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index < 3 {
                x = w * CGFloat(index)
            }else if index < 5{
                w = width / 2.0
                x = w * CGFloat(index - 3)
                y = h
            }else if index < 9 {
                w = width / 4.0
                x = w * CGFloat(index - 5)
                y = height - h
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .nine:
            var w : CGFloat = width / 3.0
            let h : CGFloat = height / 4.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index < 3 {
                x = CGFloat(index) * w
            }else {
                w = width / 2.0
                x = w * CGFloat((index - 1) % 2 )
                y = h * CGFloat((index - 1) / 2)
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .ten:
            var w : CGFloat = width / 2.0
            var h : CGFloat = height / 4.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index < 2 {
                x = w * CGFloat(index)
            }else if index == 2 {
                y = h
                w = width * 2.0 / 3.0
                h = height / 2.0
            }else if index < 6{
                y = h
                h = height / 2.0 / 3.0
                y = y + h * CGFloat(index - 3)
                w = width / 3.0
                x = width * 2.0 / 3.0
            }else if index < 9 {
                w = width / 3.0
                x = w * CGFloat(index - 6)
                y = height - h
            }
            frame = CGRect(x: x, y: y, width: w, height: h)
        case .eleven:
            var w : CGFloat = width / 3.0
            var h : CGFloat = height / 4.0
            var x : CGFloat = 0
            var y : CGFloat = 0
            if index < 3 {
                x = w * CGFloat(index)
            }else if index < 5 {
                y = h
                if index == 3 {
                    h = height / 3.0
                }else if index == 4 {
                    y = h + height / 3.0
                    h = height / 2.0 / 3.0
                }
            }else if index < 7 {
                y = h
                x = w
                w = w * 2.0
                if index == 5 {
                    h = height / 2.0 / 3.0
                }else {
                    y = h + height / 2.0 / 3.0
                    h = height / 3.0
                }
            }else if index < 9 {
                w = width / 2.0
                x = w * CGFloat(index - 7)
                y = height - h
            }
            
            frame = CGRect(x: x, y: y, width: w, height: h)
        default:
            sp_log(message: "没有其他")
        }
        return frame
    }
    private class func sp_space(type : SPSPlicingType.NineType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one , .two:
            // 余数
            let remainder = index % 3
            // 除数
            let divisor = index / 3
            if divisor == 0 {
                left = margin
                top = margin
            }else if divisor == 1 {
                left = margin
                top = padding
                bottom = padding
            }else if divisor == 2 {
                left = margin
                bottom = margin
            }
            
            if remainder == 0 {
                
            }else if remainder == 1 {
                if divisor == 0 {
                    left = padding
                    right = padding
                }else if divisor == 1 {
                    left = padding
                    right = padding
                    top = padding
                    bottom = padding
                }else if divisor == 2 {
                    left = padding
                    right = padding
                }
                
            }else if remainder == 2 {
                if divisor == 0 {
                    left = 0
                    right = margin
                }else if divisor == 1 {
                    left = 0
                    right = margin
                    top = padding
                    bottom = padding
                }else if divisor == 2 {
                    left = 0
                    right = margin
                }
            }
        case .three:
            if index == 0 {
                left = margin
                top = margin
                bottom = margin
                
            }else if index < 5 {
                left = padding
                top = margin
                if index == 4 {
                    right = margin
                }
            }else if index < 9{
                left = padding
                bottom = margin
                top = padding
                if index == 8 {
                    right = margin
                }
            }
        case .four :
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                right = 0
            }else if index == 1 {
                top = margin
                right = margin
                bottom = padding
                left = padding
            }else if index == 2 {
                right = margin
                bottom = padding
                left = padding
            }else if index < 6 {
                if index == 3 {
                    left = margin
                }else {
                    left = padding
                }
                if index == 5 {
                    right = margin
                }
                bottom = padding
                
            }else if index < 9 {
                if index == 6 {
                    left = margin
                }else{
                    left = padding
                }
                if index == 8 {
                    right = margin
                }
                bottom = margin
            }
        case .five:
            if index == 0 {
                left = margin
                top = margin
                bottom = padding
                
            }else if index < 4 {
                top = margin
                left = padding
                if index == 3 {
                    right = margin
                }
            }else if index < 7{
                top = padding
                left = padding
                bottom = padding
                if index == 6 {
                    right = margin
                }
            }else if index < 9 {
                bottom = margin
                if index == 7 {
                    left = margin
                }else {
                    left = padding
                    right = margin
                }
            }
        case .six:
            if index == 0 {
                left = margin
                top = margin
                
            }else if index == 1 {
                top = margin
                left = padding
            }else if index == 2 {
                left = padding
                top = margin
                right = margin
            }else if index == 3 {
                left = margin
                top = padding
                right = padding
            }else if index == 4 {
                top = padding
                bottom = padding
            }else if index == 5 {
                top = padding
                left = padding
                right = margin
                bottom = padding
            }else if index == 6 {
                top = padding
                left = margin
                bottom = margin
                right = padding
            }else if index == 7 {
                bottom = margin
                right = padding
            }else if index == 8 {
                right = margin
                bottom = margin
            }
        case .seven:
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                right = padding
                top = margin
            }else if index == 2 {
                right = margin
                top = margin
            }else if index == 3 {
                left = margin
                top = padding
                bottom = padding
            }else if index == 4 {
                left = padding
                right = padding
                top = padding
                bottom = padding
            }else if index == 5 {
                top = padding
                right = padding
                bottom = padding
            }else if index == 6 {
                left = margin
                bottom = margin
            }else if index == 7 {
                left = padding
                right = padding
                bottom = margin
            }else if index == 8 {
                right = margin
                bottom = margin
            }
        case .eight:
            if index == 0 {
                left = margin
                top = margin
            }else if index == 1 {
                left = padding
                top = margin
            }else if index == 2 {
                left = padding
                right = margin
                top = margin
            }else if index == 3 {
                left = margin
                top = padding
                bottom = padding
            }else if index == 4 {
                left = padding
                top = padding
                bottom = padding
                right = margin
            }else if index == 5 {
                left = margin
                bottom = margin
            }else if index == 6 {
                left = padding
                bottom = margin
            }else if index == 7 {
                left = padding
                bottom = margin
            }else if index == 8 {
                left = padding
                right = margin
                bottom = margin
            }
        case .nine:
            if index < 3 {
                top = margin
                if index == 0 {
                    left = margin
                }else if index == 1 {
                    left = padding
                    right = padding
                }else if index == 2 {
                    right = margin
                }
            }else {
                if (index - 1) % 2 == 0 {
                    left = margin
                }else {
                    left = padding
                    right = margin
                }
                top = padding
                if index == 7 || index == 8{
                    bottom = margin
                }
            }
        case .ten:
            if index == 0 {
                left = margin
                top = margin
                right = padding
            }else if index == 1 {
                top = margin
                right = margin
            }else if index == 2 {
                left = margin
                top = padding
                right = padding
                bottom = padding
            }else if index == 3 {
                top = padding
                right = margin
            }else if index == 4 {
                top = padding
                right = margin
            }else if index == 5 {
                top = padding
                right = margin
                bottom = padding
            }else if index == 6 {
                left = margin
                bottom = margin
                right = padding
            }else if index == 7 {
                bottom = margin
                right = padding
            }else if index == 8 {
                bottom = margin
                right = margin
            }
        case .eleven:
            if index == 0 {
                left = margin
                top = margin
                right = padding
            }else if index == 1 {
                top = margin
                right = padding
            }else if index == 2 {
                top = margin
                right = margin
            }else if index == 3 || index == 4 {
                left = margin
                top = padding
                right = padding
            }else if index == 5 || index == 6{
                top = padding
                right = margin
            }else if index < 9 {
                bottom = margin
                top = padding
                if index == 7 {
                    left = margin
                    right = padding
                }else {
                    right = margin
                }
            }
        default:
            sp_log(message: "没有其他")
        }
        
        return (left,right,top,bottom)
    }
}
