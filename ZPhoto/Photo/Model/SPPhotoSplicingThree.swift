//
//  SPPhotoSplicingThree.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary

class  SPPhotoSplicingThree {
    class func sp_frameAndSpace(type:SPSPlicingType.ThreeType,value : SPPhotoSplicingStruct)->SPPhotoSplicingLayout{
        let frame = sp_frame(type: type, value: value)
        let space = sp_space(type: type, value: value)
        return (frame,space)
    }
    private class func sp_frame(type : SPSPlicingType.ThreeType,value : SPPhotoSplicingStruct)->CGRect{
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
            h = height
            if index == 1 {
                x = w + value.margin
                w = w + value.padding * 2.0
            }else{
                w = w + value.margin
                if index == 2 {
                    x = width - w
                }
            }
        case .two:
            w = width
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 1 {
                y = h + value.margin
                h = h + value.padding * 2.0
            }else{
                h = h + value.margin
                if index == 2 {
                    y = height - h
                }
            }
        case .three:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index == 2 {
                h = height
                w = value.margin + value.padding + w
                x = width - w
            }else{
                w = w + value.margin
                h = h + value.margin
                if index == 1 {
                    h = h + value.padding
                    y = height - h
                }
            }
        case .four:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0 ) / 3.0
            if index == 2 {
                w = width
                h = h + value.margin + value.padding
                y = height - h
            }else{
                h = h * 2.0 + value.padding + value.margin
                w = w + value.margin
                if index == 1 {
                    w = w + value.padding
                    x = width - w
                }
            }
        case .five:
            w = (width - value.margin * 2.0 - value.padding ) / 2.0
            h = (height - value.margin * 2.0 - value.padding * 2.0) / 3.0
            if index == 0 {
                w = w + value.margin + value.padding
                h = height
            }else{
                w = w + value.margin
                x = width - w
                if index == 1 {
                    h = h + value.margin
                }else{
                    h = h * 2.0 + value.margin + value.padding * 2.0
                    y = height - h
                }
            }
        case .six:
            w = (width - value.margin * 2.0 - value.padding) / 2.0
            h = (height - value.margin * 2.0 - value.padding) / 2.0
            if index == 0 {
                w = width
                h = h + value.margin + value.padding
            }else{
                h = h + value.margin
                y = height - h
                w = w + value.margin
                if index == 2 {
                    w = w + value.padding
                    x = width - w
                }
            }
            
        default:
            sp_log(message: "")
        }
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //MARK: - space
    private class func sp_space(type : SPSPlicingType.ThreeType,value : SPPhotoSplicingStruct)->SPSpace{
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
            }else if index == 2 {
                right = margin
            }else{
                left = padding
                right = padding
            }
        case .two:
            left = margin
            right = margin
            if index == 0 {
                top = margin
            }else if index == 2 {
               bottom = margin
            }else{
                top = padding
                bottom = padding
            }
        case .three:
            if index == 2 {
                left = padding
                top = margin
                right = margin
                bottom = margin
            }else {
                left = margin
                if index == 0 {
                    top = margin
                }else{
                    top = padding
                    bottom = margin
                }
            }
        case.four:
            if index == 2 {
                left = margin
                right = margin
                bottom = margin
                top = padding
            }else{
                top = margin
                if index == 0 {
                    left = margin
                }else{
                    left = padding
                    right = margin
                }
            }
        case .five:
            if index == 0 {
                left = margin
                right = padding
                bottom = margin
                top = margin
            }else{
                right = margin
                if index == 1 {
                    top = margin
                }else{
                    top = padding
                    bottom = margin
                }
            }
        case .six:
            if index == 0 {
                left = margin
                right = margin
                top = margin
                bottom = padding
            }else{
                bottom = margin
                if index == 1 {
                    left = margin
                }else{
                    left = padding
                    right = margin
                }
            }
        default:
            sp_log(message: "")
        }
        return  (left,right,top,bottom)
    }
}
