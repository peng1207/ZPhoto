//
//  SPVideoSplicingVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/6.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
/// 视频拼接
class SPVideoSplicingVC: SPBaseVC {
    var selectArray : [SPVideoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
