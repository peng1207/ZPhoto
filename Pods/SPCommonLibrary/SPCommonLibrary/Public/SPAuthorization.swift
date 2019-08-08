//
//  SPAuthorization.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

/// 是否有权限回调 auth true 有权限  false 没有权限
typealias AuthorizedBlock = (_ auth : Bool) -> Void

// 权限表
class SPAuthorizatio{
    
    /// 相机权限
    ///
    /// - Parameter authoriedBlock: 回调
    class func isRightCamera(authoriedBlock : AuthorizedBlock?) -> Void {
        guard let authoriedComplete = authoriedBlock  else {
            return
        }
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .notDetermined {
            // 第一次授权
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (grant) in
                authoriedComplete(grant)
            }
        }else if authStatus == .authorized{
            authoriedComplete(true)
        }else{
            authoriedComplete(false)
        }
    }
    /// 相册权限
    ///
    /// - Parameter authoriedBlock: 回调
    class func isRightPhoto(authoriedBlock :  AuthorizedBlock?) -> Void {
        guard let authoriedComplete = authoriedBlock  else {
            return
        }
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) in
                if status == .authorized{
                    authoriedComplete(true)
                }else{
                    authoriedComplete(false)
                }
            }
        }else if (authStatus == .authorized){
            authoriedComplete(true)
        }else{
            authoriedComplete(false)
        }
    }
    
    /// 是否麦克风权限
    ///
    /// - Parameter authorizedBlock: 回调
    class func isRightRecord(authorizedBlock : AuthorizedBlock?) -> Void{
        guard let authorizedComplete = authorizedBlock else {
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (authorized) in
            authorizedComplete(authorized)
        }
    }
}
