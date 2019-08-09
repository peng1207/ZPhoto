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
//        sp_log(message: sp_limitUp(current: 10, count: 10))
        
        // Override point for customization after application launch.
        return true
    }

    func sp_limitUp(current:Double,count : Int)->Double{
        var totalPrice = current
        
        for i in 1...count {
            totalPrice = totalPrice + totalPrice * 0.1
            sp_log(message: "第\(i)涨停的价格 \(totalPrice)")
        }
        return totalPrice
    }
    func sp_total(current : Double,num : Int)->Double{
          var totalPrice = current
        for i in 1...num {
            totalPrice = totalPrice + totalPrice * 0.3
            sp_log(message: "第\(i * 3)天总额 \(totalPrice)")
        }
        return totalPrice
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

