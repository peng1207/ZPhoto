//
//  SPVideoSelectEditVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/1.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
class SPVideoSelectEditVC: SPBaseVC {
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
        self.view.addSubview(self.selectVC.view)
        self.addChildViewController(self.selectVC)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectVC.view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPVideoSelectEditVC{
    
    fileprivate func sp_dealSelect(model : SPVideoModel?){
        let editVC = SPVideoEditVC()
        editVC.videoModel = model
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
}
