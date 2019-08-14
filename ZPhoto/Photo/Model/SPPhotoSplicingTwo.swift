//
//  SPPhotoSplicingTwo.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingTwo {
    class func sp_frameAndSpace(type:SPSPlicingType.TwoType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.TwoType,value : SPPhotoSplicingStruct)->CGRect{
        var x : CGFloat = 0
        var y :  CGFloat = 0
        var w : CGFloat = 0
        var h : CGFloat = 0
        let width = value.width
        let height = value.height
        let index = value.index
        switch type {
        case .one:
            w = (width - value.margin * 2.0 - value.padding ) / 2.0
            h = height
            if index == 0 {
                w = w + value.margin
            }else{
                w = w + value.margin + value.padding
                x = width - w
            }
        case .two :
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            w = width
            if index == 0 {
                h = h + value.margin
            }else{
                h = h + value.margin + value.padding
                y = height - h
            }
        case .three:
            if index == 0 {
                w = width
                h = height
            }else {
                w = width / 4.0
                h = height / 4.0
                y = height - h - value.margin - 4
                x = width - w - value.margin - 4
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = height
            if index == 0 {
                w = w + value.margin
            }else{
                w = w * 2.0 + value.margin + value.padding * 2.0
                x = width - w
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding * 2.0) / 3.0
            h = height
            if index == 1 {
                w = w + value.margin
                x = width - w
            }else{
                w = w * 2.0 + value.margin + value.padding * 2.0
            }
        case .six:
            w = width
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                h = h + value.margin
            }else{
                h = h * 2.0 + value.margin + value.padding * 2.0
                y = height - h
            }
        case .seven:
            w = width
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                h = h * 2.0 + value.margin + value.padding * 2.0
            }else{
                h = h + value.margin
                y = height - h
            }
        default:
            sp_log(message: "")
        }
        
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.TwoType,value : SPPhotoSplicingStruct)->SPSpace{
        var left : CGFloat = 0
        var top : CGFloat = 0
        var right : CGFloat = 0
        var bottom : CGFloat = 0
        let index = value.index
        let margin = value.margin
        let padding = value.padding
        switch type {
        case .one:
            top = margin
            bottom = margin
            if index == 0 {
                left = margin
            }else{
                left = padding
                right = margin
            }
        case .two:
            left = margin
            right = margin
            if index == 0 {
                top = margin
            }else{
                top = padding
                bottom = margin
            }
        case .three:
            if index == 0 {
                left = margin
                right = margin
                bottom = margin
                top = margin
            }else{
                left = margin
                right = margin
                bottom = margin
                top = margin
            }
        case .four:
            top = margin
            bottom = margin
            if index == 0 {
                left = margin
            }else{
                right = margin
                left = padding
            }
        case .five:
            top = margin
            bottom = margin
            if index == 0 {
                left = margin
                right = padding
            }else{
                right = margin
            }
        case .six:
            left = margin
            right = margin
            if index == 0 {
                top = margin
            }else{
                top = padding
                bottom = margin
            }
        case .seven:
            left = margin
            right = margin
            if index == 0 {
                top = margin
                bottom = padding
            }else{
                bottom = margin
            }
        default:
            sp_log(message: "")
        }
        return  (left,right,top,bottom)
    }
}
