//
//  AppDelegate.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/3/28.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import UIKit
import SPCommonLibrary
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        UINavigationController.sp_initialize()
        let recordVideoVC = SPMainVC()
        window?.rootViewController = recordVideoVC
        createCachePath()
        setUncaughtExceptionHandler()
      
//        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
//        for fileterName : String in properties {
//            let filter = CIFilter(name: fileterName)
//            // 滤镜的参数
//            sp_log(message: "滤镜名称----\(fileterName)")
//            sp_log(message: filter?.attributes)
//        }
//        for _ in 0...4 {
//             sp_log(message: sp_getOneGroupValue())
//        }
//        for _ in 0...4 {
//            sp_log(message: sp_getShuangSeQiu())
//        }
        
        // Override point for customization after application launch.
        return true
    }
    
    fileprivate func sp_getOneGroupValue()->String{
        var dataValue = ""
        var frontList = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35"]
        var afterList = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        dataValue.append("前区: ")
        var resultValue = [String]()
        for _ in 0..<5 {
            frontList = sp_upset(list: frontList)
            let index = arc4random() % UInt32(frontList.count)
            let value = frontList[Int(index)]
            frontList.remove(at: Int(index))
            resultValue.append(value)
        }
        resultValue = resultValue.sorted()
        dataValue.append(resultValue.joined(separator: "  "))
        dataValue.append("  后区: ")
        resultValue.removeAll()
        for _ in 0..<2 {
            afterList = sp_upset(list: afterList)
            let index = arc4random() % UInt32(afterList.count)
            let value = afterList[Int(index)]
            afterList.remove(at: Int(index))
            resultValue.append(value)
        }
        resultValue = resultValue.sorted()
        dataValue.append(resultValue.joined(separator: "  "))
        return dataValue
    }
    
    fileprivate func sp_getShuangSeQiu()->String{
        var dataValue = ""
        var frontList = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33"]
        var afterList = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16"]
        dataValue.append("红区: ")
        
        var resultValue = [String]()
        for _ in 0...5 {
            frontList = sp_upset(list: frontList)
            let index = arc4random() % UInt32(frontList.count)
            let value = frontList[Int(index)]
            frontList.remove(at: Int(index))
            resultValue.append(value)
        }
        resultValue = resultValue.sorted()
        dataValue.append(resultValue.joined(separator: "  "))
        dataValue.append("  蓝区: ")
        resultValue.removeAll()
        for _ in 0..<1 {
            afterList = sp_upset(list: afterList)
            let index = arc4random() % UInt32(afterList.count)
            let value = afterList[Int(index)]
            afterList.remove(at: Int(index))
            resultValue.append(value)
        }
        resultValue = resultValue.sorted()
        dataValue.append(resultValue.joined(separator: "  "))
        return dataValue
    }
    
    fileprivate func sp_upset(list : [String])->[String]{
        var data = list
        for _ in 0..<7 {
            //arc4random() 随机数
            let count = arc4random() % UInt32(data.count) + 1
            for _ in 0..<count{
                let index = arc4random() % UInt32(data.count)
                let value = data[Int(index)]
                data.remove(at: Int(index))
                data.insert(value, at: 0)
            }
        }
        return data
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        sp_log(message: "app is kill")
        
    }


}

