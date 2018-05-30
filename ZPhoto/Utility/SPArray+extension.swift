//
//  SPArray+extension.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/8.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
