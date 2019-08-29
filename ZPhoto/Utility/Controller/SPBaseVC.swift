//
//  SPBaseVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/25.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
class SPBaseVC : UIViewController{
    lazy var safeView : UIView = {
        let view = UIView()
        view.backgroundColor = sp_getMianColor()
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBase()
    }
    func sp_setupUI() {
        
    }
    func sp_dealNoData(){
        
    }
   @objc func sp_clickBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

 extension  SPBaseVC{
    
    fileprivate func setupBase(){
        // UI适配
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
    }
    
}
