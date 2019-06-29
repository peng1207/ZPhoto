//
//  SPVideoVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/2.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit

class SPVideoVC: SPBaseNavVC {
    
    internal init() {
        super.init(rootViewController: SPVideoRootVC());
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

fileprivate class SPVideoRootVC: SPBaseVC {
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate lazy var recordBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
         btn.setImage(UIImage(named: "add_white"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickRecord), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = sp_getMianColor()
        btn.sp_cornerRadius(cornerRadius: 40)
        return btn
    }()
    fileprivate lazy var fileView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .right
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "FIlE")
        view.clickBlock = { [weak self] in
            self?.sp_clickFile()
        }
        return view
    }()
    fileprivate lazy var splicingView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .left
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "SPLICING")
        view.clickBlock = { [weak self] in
            self?.sp_clickSplicing()
        }
        return view
    }()
    fileprivate lazy var editView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .right
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "EDIT")
        view.clickBlock = { [weak self] in
            self?.sp_clickEdit()
        }
        return view
    }()
    fileprivate lazy var inversionView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .left
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "INVERSION")
        view.clickBlock = { [weak self] in
            self?.sp_clickInversion()
        }
        return view
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
    override func sp_clickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "VIDEO")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)
        
        self.view.addSubview(self.fileView)
        self.view.addSubview(self.splicingView)
        self.view.addSubview(self.editView)
        self.view.addSubview(self.inversionView)
        self.view.addSubview(self.recordBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.recordBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
            maker.width.height.equalTo(80)
        }
        self.fileView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.recordBtn.snp.left).offset(0)
            maker.width.height.equalTo(100)
            maker.bottom.equalTo(self.recordBtn.snp.centerY).offset(-10)
        }
        self.splicingView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordBtn.snp.right).offset(0)
            maker.width.height.equalTo(self.fileView).offset(0)
            maker.bottom.equalTo(self.fileView.snp.bottom).offset(0)
        }
        self.editView.snp.makeConstraints { (maker) in
            maker.right.width.height.equalTo(self.fileView).offset(0)
            maker.top.equalTo(self.fileView.snp.bottom).offset(20)
        }
        self.inversionView.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.splicingView).offset(0)
            maker.top.equalTo(self.editView.snp.top).offset(0)
        }
    }
    
    deinit {
        
    }
}
extension SPVideoRootVC {
    /// 点击录制
    @objc fileprivate func sp_clickRecord(){
        self.present(SPRecordVideoVC(), animated: true, completion: nil)
    }
    fileprivate func sp_clickFile(){
        let vc = SPVideoListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 点击拼接
    fileprivate func sp_clickSplicing(){
        
    }
    /// 点击编辑
    fileprivate func sp_clickEdit(){
        
    }
    /// 点击倒放
    fileprivate func sp_clickInversion(){
        
    }
}
