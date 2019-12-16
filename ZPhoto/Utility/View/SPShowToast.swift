//
//  SPShowToast.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import MBProgressHUD
import SPCommonLibrary
class SPShowToast {
    
    /// 展示动画
    /// - Parameter text: 内容
    /// - Parameter view: 展示的view
    /// - Parameter afterDelay: 几秒后自动隐藏
    class func sp_showAnimation(text : String, view : UIView,afterDelay : TimeInterval = 0.0){
        sp_mainQueue {
            let hudView = MBProgressHUD(view: view)
            hudView.label.text = text
            hudView.label.textColor = UIColor.white
            hudView.bezelView.color = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
            view.addSubview(hudView)
            hudView.show(animated: true)
            if afterDelay > 0 {
                hudView.hide(animated: true, afterDelay: afterDelay)
            }
        }
       
    }
    
    ///  隐藏动画
    ///
    /// - Parameter view: 在那个view隐藏
    class func sp_hideAnimation(view : UIView){
        sp_mainQueue {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    /// 提示语提示框
    ///
    /// - Parameters:
    ///   - tips: 提示语
    ///   - afterDelay: 延迟几秒隐藏
   class func sp_showTextAlert(tips:String,afterDelay : TimeInterval = 2.0) {
        sp_mainQueue {
            if sp_getString(string: tips).count > 0 {
                let appdelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let hudView = MBProgressHUD(view: appdelete.window!)
                hudView.mode = .text
                hudView.label.font = sp_fontSize(fontSize: 14)
                hudView.label.textColor = UIColor.white
                hudView.label.text = tips
                hudView.bezelView.color = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
                appdelete.window?.addSubview(hudView)
                hudView.show(animated: true)
                hudView.hide(animated: true, afterDelay: afterDelay)
            }
        }
        
    }
}
