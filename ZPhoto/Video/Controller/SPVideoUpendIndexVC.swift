//
//  SPVideoUpendIndexVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/1.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 倒放视频入口 选择视频
class SPVideoUpendIndexVC: SPBaseVC {
    
    fileprivate lazy var selectVC : SPVideoSelectVC = {
        let vc = SPVideoSelectVC()
        vc.selectBlock = { [weak self](model) in
            self?.sp_dealSelect(model: model)
        }
        return vc
    }()
    
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
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "CHOOSE_VIDEO")
        self.view.addSubview(self.selectVC.view)
        self.addChild(self.selectVC)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectVC.view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
        }
    }
    deinit {
        
    }
}

extension SPVideoUpendIndexVC{
    
    /// 处理选择的视频
    /// - Parameter model: 视频model
    fileprivate func sp_dealSelect(model : SPVideoModel?){
        let upendVC = SPVideoUpendVC()
        upendVC.videoModel = model
        self.navigationController?.pushViewController(upendVC, animated: true)
    }
    
    
}
