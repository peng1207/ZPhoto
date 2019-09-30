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
    fileprivate lazy var selectView : SPSelectView = {
        let view = SPSelectView()
        view.clearBlock = { [weak self] in
           self?.sp_clearAll()
        }
        view.indexBlock = { [weak self](index) in
            self?.sp_removeIndex(index: index)
        }
        view.selectMaxCount = selectMaxCount
        return view
    }()
    var selectMaxCount : Int = 9
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
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.selectView)
        self.safeView.backgroundColor = self.selectView.backgroundColor
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectVC.view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.selectView.snp.top).offset(0)
        }
        self.selectView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(100)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.selectView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPVideoSplicingSelectVC{
    
    /// 处理选择视频
    /// - Parameter model: 视频model
    fileprivate func sp_dealSelect(model : SPVideoModel?){
        if sp_count(array: self.selectView.dataArray) >= self.selectMaxCount {
            sp_showMaxNumTip()
            return
        }
        guard let m = model else {
            return
        }
        self.selectView.sp_add(model: m)
        self.selectVC.selectArray = self.selectView.dataArray as? [SPVideoModel]
    }
    /// 展示选择最大的提示
    fileprivate func sp_showMaxNumTip(){
        let alertController  = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "Exceed_MAX_NUM"), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "KNOW"), style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    /// 点击下一步
    @objc fileprivate func sp_clickNext(){
        if sp_count(array: self.selectVC.selectArray) > 0 {
            let vc = SPVideoSplicingVC()
            vc.selectArray = self.selectVC.selectArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// 清除所有
    fileprivate func sp_clearAll(){
        self.selectVC.selectArray = nil 
    }
    /// 移除某一个
    /// - Parameter index: 位置
    fileprivate func sp_removeIndex(index : Int){
        var list = self.selectVC.selectArray
        if  index < sp_count(array: list) {
            list?.remove(at: index)
            self.selectVC.selectArray = list
        }
    }
}
