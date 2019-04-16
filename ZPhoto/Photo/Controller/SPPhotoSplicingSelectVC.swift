//
//  SPPhotoSplicingVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
//
// 拼接选择图片

import Foundation
import SnapKit
class SPPhotoSplicingSelectVC: SPBaseVC {

    fileprivate lazy var photoListVC : SPPhotoListVC = {
        let vc = SPPhotoListVC()
        vc.selectBlock = { [weak self](model ) in
            self?.sp_dealSelectComplete(model: model)
        }
        vc.selectMaxCount = selectMaxCount
        self.addChildViewController(vc)
        return vc
    }()
    
    fileprivate lazy var selectView : SPPhotoSplicingSelectView = {
        let view = SPPhotoSplicingSelectView()
        view.clearBlock = { [weak self] in
            self?.photoListVC.sp_clearSelect()
        }
        view.indexBlock = { [weak self](index) in
            self?.photoListVC.sp_removeSelect(index: index)
        }
        view.selectMaxCount = selectMaxCount
        return view
    }()
    
    
    fileprivate lazy var nextBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "NEXT"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
       btn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickNext), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate let selectMaxCount : Int = 9
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
        self.view.addSubview(self.photoListVC.view)
        self.view.addSubview(self.selectView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.nextBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.photoListVC.view.snp.makeConstraints { (maker) in
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
    }
    deinit {
        
    }
}
fileprivate extension SPPhotoSplicingSelectVC{
    
    /// 处理选择的图片
    ///
    /// - Parameter model: 图片model
    func sp_dealSelectComplete(model : SPPhotoModel){
        self.selectView.sp_add(model: model)
    }
    /// 点击下一步
    @objc func sp_clickNext(){
        if sp_getArrayCount(array: self.selectView.dataArray) > 0 {
            let vc = SPPhotoSplicingVC()
            vc.dataArray = self.selectView.dataArray
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_CHOICE_TIPS"), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "OK"), style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        
       
    }
}
