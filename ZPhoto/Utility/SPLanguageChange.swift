//
//  SPLanguageChange.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/2.
//  Copyright © 2018年 huangshupeng. All rights reserved.
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
    class func getString(key:String) -> String{
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
            if string.hasPrefix("zh-TW") || string.hasPrefix("zh-HK") || string.hasPrefix("zh-Hant") {
                 path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj")
            }else {
                 path = Bundle.main.path(forResource:"en" , ofType: "lproj")
            }
        }
        bundle = Bundle(path: path!)
    }
    
    
    
    
}
