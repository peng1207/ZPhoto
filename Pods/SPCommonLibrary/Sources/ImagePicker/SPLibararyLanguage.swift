//
//  SPLibararyLanguage.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/9/26.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
/// 框架中的国际化
class SPLibararyLanguage {
    public static let shareInstance = SPLibararyLanguage()
    fileprivate var libraryBundle : Bundle?
    fileprivate var isChinese : Bool = false
    /// 获取国际化的文字
    /// - Parameter key: 文字对应key
    class func sp_library(key : String) -> String{
        var bundle = SPLibararyLanguage.shareInstance.libraryBundle
        if let b = bundle {
            let str = b.localizedString(forKey: key, value: nil, table: nil)
            return Bundle.main.localizedString(forKey: key, value: str, table: nil)
        }else{
            SPLibararyLanguage.shareInstance.sp_initLanguage()
            bundle = SPLibararyLanguage.shareInstance.libraryBundle
            let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
            if let s = str{
                return Bundle.main.localizedString(forKey: key, value: s, table: nil)
            }
        }
        return key
    }
    /// 初始化语言
    public func sp_initLanguage(){
        var string : String = ""
        if let s = Locale.preferredLanguages.first{
            string = s
        }else{
            string = "en"
        }
        
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
            // 没有获取到对应的国际化
            // 判断当前的语言为台湾或相关或繁体字 则更改为中文
            if string.hasPrefix("zh-TW") || string.hasPrefix("zh-HK") || string.hasPrefix("zh-Hant") {
                path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj")
                string = "zh-Hans"
                isChinese = true
            }else { // 否则更改为英文显示
                path = Bundle.main.path(forResource:"en" , ofType: "lproj")
                string = "en"
                isChinese = false
            }
        }else{
            
            if string.hasPrefix("en") {
                isChinese = false
            }else{
                isChinese = true
            }
        }
        let library = Bundle.libraryBundle
        self.libraryBundle = Bundle(path: library.path(forResource: string, ofType: "lproj")!)
    }
    
}
