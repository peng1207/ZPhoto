//
//  SPBaseVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/25.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
class SPBaseVC : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBase()
    }
}

fileprivate extension  SPBaseVC{
    
    fileprivate func setupBase(){
        // UI适配
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
    }
    
}
