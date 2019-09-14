//
//  SPAnimationView.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/9/12.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAnimationView:  UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
