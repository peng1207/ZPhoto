//
//  SPShare.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/7/29.
//

import Foundation
import UIKit
public class SPShare {
    
    /// 调用系统分享图片
    ///
    /// - Parameters:
    ///   - imgs: 图片数组
    ///   - vc: 当前控制器
    public class func sp_share(imgs : [UIImage]?,vc : UIViewController?){
        guard let shareImgs = imgs else {
            return
        }
        guard let currentVC = vc else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: shareImgs, applicationActivities: nil)
        let popover = activityVC.popoverPresentationController
        if (popover != nil) {
            popover?.permittedArrowDirections = .up
        }
        currentVC.present(activityVC, animated: true, completion: nil)
    }
    /// 调用系统分享视频
    ///
    /// - Parameters:
    ///   - videoUrls: 视频URL集合
    ///   - vc: 当前控制器
    public class func sp_share(videoUrls : [URL]?,vc : UIViewController?){
        guard let shareList = videoUrls else {
            return
        }
        guard let currentVC = vc else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: shareList, applicationActivities: nil)
        let popover = activityVC.popoverPresentationController
        if (popover != nil) {
            popover?.permittedArrowDirections = .up
        }
        currentVC.present(activityVC, animated: true, completion: nil)
    }
    /// 调用系统分享其他数据
    ///
    /// - Parameters:
    ///   - shareData: 分享的数据
    ///   - vc: 当前的控制器
    public class func sp_share(shareData:[Any]?,vc : UIViewController?){
        guard let shareList = shareData else {
            return
        }
        guard let currentVC = vc else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: shareList, applicationActivities: nil)
        let popover = activityVC.popoverPresentationController
        if (popover != nil) {
            popover?.permittedArrowDirections = .up
        }
        
        currentVC.present(activityVC, animated: true, completion: nil)
    }
}
