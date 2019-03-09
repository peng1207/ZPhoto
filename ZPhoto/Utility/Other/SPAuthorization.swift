//
//  SPAuthorization.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2018/5/5.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

typealias AuthorizedBlock = (_ auth : Bool) -> Void

// 权限表
class SPAuthorizatio{
    
    // 相机权限
   class func isRightCamera(authoriedBlock : AuthorizedBlock?) -> Void {
        guard let authoriedComplete = authoriedBlock  else {
            return
        }
        
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .notDetermined {
            // 第一次授权
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (grant) in
                authoriedComplete(grant)
            }
        }else if authStatus == .authorized{
            authoriedComplete(true)
        }else{
            authoriedComplete(false)
        }
        
        
    }
    
    // 相册权限
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
