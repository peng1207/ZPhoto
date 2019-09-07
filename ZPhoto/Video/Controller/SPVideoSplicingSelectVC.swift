//
//  SPVideoSplicingSelectVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/6.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 视频拼接选择的视频
class SPVideoSplicingSelectVC: SPBaseVC {
    
    fileprivate lazy var selectVC : SPVideoSelectVC = {
        let vc = SPVideoSelectVC()
        vc.selectBlock = { [weak self](model) in
            self?.sp_dealSelect(model: model)
        }
        return vc
    }()
    fileprivate var selectArray : [SPVideoModel] = [SPVideoModel]()
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "NEXT"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_clickNext))
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
extension SPVideoSplicingSelectVC{
    
    fileprivate func sp_dealSelect(model : SPVideoModel?){
        guard let m = model else {
            return
        }
        self.selectArray.append(m)
        self.selectVC.selectArray = self.selectArray
    }
    @objc fileprivate func sp_clickNext(){
        if self.selectArray.count > 0 {
            let vc = SPVideoSplicingVC()
            vc.selectArray = self.selectArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
