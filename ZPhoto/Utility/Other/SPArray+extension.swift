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
    
    /// 获取一个元素存在的次数
    ///
    /// - Parameter object: 某个元素
    /// - Returns: 次数
    func sp_number(of object:Element)->Int{
        var count = 0
        for item in self {
            if item == object {
                count = count + 1
            }
        }
        return count
    }
    mutating func remove(of array : [Element]){
        for model in array {
            remove(object: model)
        }
    }
    /// 删除某个位置的数据
    ///
    /// - Parameter index: 删除的位置
    mutating func sp_remove(of index:Int){
        if index < self.count {
            self.remove(at: index)
        }
    }
    
}
