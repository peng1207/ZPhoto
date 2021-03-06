//
//  SPPhotoVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/26.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 图片主入口
class SPPhotoVC: SPBaseNavVC {
  
    internal init() {
        super.init(rootViewController: SPPhotoRootVC());
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


fileprivate class SPPhotoRootVC: SPBaseVC {
    
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControl.Event.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate lazy var cameraBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "add_white"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickCamera), for: UIControl.Event.touchUpInside)
        btn.sp_cornerRadius(radius: 40)
        btn.backgroundColor = sp_getMianColor()
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
    fileprivate lazy var gifView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .right
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "FILM")
        view.clickBlock = { [weak self] in
            self?.sp_clickGif()
        }
        return view
    }()
    fileprivate lazy var editView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .left
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "LONG_GRAPH")
        view.clickBlock = { [weak self] in
            self?.sp_clickLongGraph()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        FileManager.sp_directory(createPath: SPPhotoHelp.SPPhotoDirectory)
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
    /// 点击返回
    override func sp_clickBack(){
        self.dismiss(animated: true, completion: nil)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "PHOTO")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)
        self.view.addSubview(self.cameraBtn)
        self.view.addSubview(self.fileView)
        self.view.addSubview(self.splicingView)
        self.view.addSubview(self.gifView)
        self.view.addSubview(self.editView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cameraBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(-40)
            maker.width.equalTo(80)
            maker.height.equalTo(80)
        }
        self.fileView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.cameraBtn.snp.left).offset(0)
            maker.width.height.equalTo(100)
            maker.bottom.equalTo(self.cameraBtn.snp.centerY).offset(-10)
        }
        self.splicingView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cameraBtn.snp.right).offset(0)
            maker.width.height.equalTo(self.fileView).offset(0)
            maker.bottom.equalTo(self.fileView.snp.bottom).offset(0)
        }
        self.gifView.snp.makeConstraints { (maker) in
            maker.right.width.height.equalTo(self.fileView).offset(0)
            maker.top.equalTo(self.fileView.snp.bottom).offset(20)
        }
        self.editView.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.splicingView).offset(0)
            maker.top.equalTo(self.gifView.snp.top).offset(0)
        }
        
    }
    deinit {
        
    }
}
extension SPPhotoRootVC {
    /// 点击相机
    @objc fileprivate func sp_clickCamera(){
        let cameraVC = SPCameraVC()
        cameraVC.modalPresentationStyle = .fullScreen
        self.present(cameraVC, animated: true, completion: nil)
    }
    /// 点击文件
    fileprivate func sp_clickFile(){
        let vc = SPPhotoListVC()
        vc.selectMaxCount = 1
        vc.isCanAddOther = true
        vc.pushEditVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 点击拼接
    fileprivate func sp_clickSplicing(){
        let vc = SPPhotoSelectVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 点击影片
    fileprivate func sp_clickGif(){
        let vc = SPPhotoSelectVC()
        vc.pushVCType = .film
        vc.selectMaxCount = 12
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 点击长图
    fileprivate func sp_clickLongGraph(){
        let vc = SPPhotoSelectVC()
        vc.pushVCType = .longGraph
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
