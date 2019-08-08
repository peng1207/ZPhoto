//
//  SPLanguages.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
let AppleLanguages = "AppleLanguages"

class SPLanguageChange {
    
    static let shareInstance = SPLanguageChange()
    fileprivate var bundle : Bundle?
    let def = UserDefaults.standard
    /*
     获取国际化对应的文字
     */
    class func sp_getString(key:String) -> String{
        let bundle = SPLanguageChange.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return str!
    }
    /*
     初始化语言
     */
    func initLanguage(){
        var string : String = ""
        let languages = def.object(forKey: AppleLanguages) as? NSArray
        if languages?.count != 0 {
            let current = languages?.object(at: 0) as? String
            if current != nil {
                string = current!
            }
        }
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
            // 没有获取到对应的国际化
            // 判断当前的语言为台湾或相关或繁体字 则更改为中文
            if string.hasPrefix("zh-TW") || string.hasPrefix("zh-HK") || string.hasPrefix("zh-Hant") {
                path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj")
            }else { // 否则更改为英文显示
                path = Bundle.main.path(forResource:"en" , ofType: "lproj")
            }
        }
        bundle = Bundle(path: path!)
    }
    
    
    
    
}
