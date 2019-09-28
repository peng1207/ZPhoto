//
//  SPNetWorkManager.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/7/16.
//  Copyright © 2019 Peng. All rights reserved.
// 网络监听

import Foundation
import Alamofire
import CoreTelephony
//import Reachability
/// 网络发生状态通知
public let SP_NETWORK_NOTIFICATION = "SP_NETWORK_NOTIFICATION"
public class SPNetWorkManager : NSObject {
    
    private static let netManager = SPNetWorkManager()
    private var netWorkStatus :  NetworkReachabilityManager.NetworkReachabilityStatus = .reachable(NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType.ethernetOrWiFi)
    private var netWorkOldStatus : NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    private var wwanStatus : CTCellularDataRestrictedState = CTCellularDataRestrictedState.restrictedStateUnknown
    private var reachManager : NetworkReachabilityManager!
    class func instance() -> SPNetWorkManager{
        return netManager
    }
    /// 开启网络监听
    private func sp_start(){
        
        let manager = NetworkReachabilityManager(host: "www.apple.com")
      
        manager?.startListening(onUpdatePerforming: { [weak self](status) in
            if let s = self?.netWorkStatus{
                self?.netWorkOldStatus = s
            }
            self?.netWorkStatus = status
            self?.sp_sendNetWorckChange()
        })
      
        // 开始监听网络状态变化
      
        self.reachManager = manager
    }
    /// 开启移动网络监听
    private  func sp_startWWan(){
        if #available(iOS 9.0, *) {
            let cellularData = CTCellularData()
            cellularData.cellularDataRestrictionDidUpdateNotifier = { [weak self](state) in
                self?.wwanStatus = state
            }
        } else {
            // Fallback on earlier versions
        }
    }
    /// 发送网络变化的通知
    private func sp_sendNetWorckChange(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SP_NETWORK_NOTIFICATION), object: nil)
    }
    /// 开启网络监听和移动网络监听
    public class func sp_start(){
        SPNetWorkManager.instance().sp_start()
        SPNetWorkManager.instance().sp_startWWan()
    }
    /// 判断是否没有网络
    ///
    /// - Returns: true 没有网络 false 有网络
    public class func sp_notReachable()->Bool{
        if instance().reachManager.isReachable {
            return false
        }
        return true
    }
    /// 是否无网络变成有网络
    ///
    /// - Returns: true 是从无网络变成有网络 false 不是
    public class func sp_isNotChangehave()->Bool {
        if instance().netWorkOldStatus == .notReachable {
            if !sp_notReachable() {
                return true
            }
        }
        return false
    }
    /// 是否是wifi网络
    ///
    /// - Returns: true wifi 网络 false 不是wifi网络
    public class func sp_isWifi() -> Bool{
        return instance().reachManager.isReachableOnEthernetOrWiFi
    }
    /// 是否移动网络
    ///
    /// - Returns: true 移动网 false 不是移动网络
    public class func sp_isWwan() -> Bool{
        return instance().reachManager.isReachableOnCellular
    }
    /// 判断移动网络是否开启
    ///
    /// - Returns: true 开启移动网络 false 关闭移动网络
    public class func sp_isOpenWwan() -> Bool {
        return instance().wwanStatus == .restricted ? false : true
    }
}

