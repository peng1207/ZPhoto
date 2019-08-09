//
//  SPArray.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/6/29.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
public extension Array where Element: Equatable {
    /// 删除objec对象
    ///
    /// - Parameter object: 对象
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
    /// 删除数组数据
    ///
    /// - Parameter array: 数据
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
