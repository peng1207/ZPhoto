//
//  SPVideoEditVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/12.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

class  SPVideoEditVC : SPBaseVC {
    lazy fileprivate var scheduleView : SPVideoScheduleView! = {
        let view = SPVideoScheduleView()
        return view
    }()
     var videoModel : SPVideoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      SPLog(SPVideoHelp.images(asset: videoModel?.asset))
        
        self.view.addSubview(scheduleView)
        scheduleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.right.equalTo(self.view).offset(-20)
            maker.top.equalTo(self.view).offset(20)
            maker.height.equalTo(30)
        }
    }
    deinit {
        
    }
}
// MARK: -- action
extension SPVideoEditVC {
    
}
// MARK: -- 通知 观察者
extension SPVideoEditVC {
    
}
// MARK: -- delegate
extension SPVideoEditVC  {
    
}
// MARK: -- UI
extension SPVideoEditVC {
    
}
