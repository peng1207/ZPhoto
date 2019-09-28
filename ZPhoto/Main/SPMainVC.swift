//
//  SPMainVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/26.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
class SPMainVC: SPBaseVC {
  
    fileprivate lazy var videoView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .left
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "VIDEO")
        view.clickBlock = { [weak self] in
            self?.sp_clickVideo()
        }
        return view
    }()
    fileprivate lazy var photoView : SPPentagonView = {
        let view = SPPentagonView()
        view.corners = .left
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "PHOTO")
        view.clickBlock = { [weak self] in
            self?.sp_clickPhoto()
        }
        return view
    }()
    fileprivate lazy var setView : SPPentagonView = {
        let view = SPPentagonView()
        view.titleLabel.text = SPLanguageChange.sp_getString(key: "SET")
        view.clickBlock = { [weak self] in
            self?.sp_clickSet()
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
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.videoView)
        self.view.addSubview(self.photoView)
        self.view.addSubview(self.setView)
  
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
       
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.setView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view.snp.centerX).offset(0)
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
        self.videoView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.setView).offset(0)
            maker.left.equalTo(self.view.snp.centerX).offset(0)
            maker.bottom.equalTo(self.view.snp.centerY).offset(-10)
        }
        self.photoView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.setView).offset(0)
            maker.left.equalTo(self.videoView.snp.left).offset(0)
            maker.top.equalTo(self.view.snp.centerY).offset(10)
        }
    }
    deinit {
        
    }
}
//MARK: - action
extension SPMainVC {
    @objc fileprivate func sp_clickVideo(){
        let videoVC = SPVideoVC()
        videoVC.modalPresentationStyle = .fullScreen
        self.present(videoVC, animated: true, completion: nil)
    }
    @objc fileprivate func sp_clickPhoto(){
        let photoVC = SPPhotoVC()
        photoVC.modalPresentationStyle = .fullScreen
        self.present(photoVC, animated: true, completion: nil)
    }
    @objc fileprivate func sp_clickSet(){
//        let tempVC  = SPTmpVC()
//        self.present(tempVC, animated: true, completion: nil)
        let setNavVC = SPBaseNavVC(rootViewController: SPSetVC())
        setNavVC.modalPresentationStyle = .fullScreen
        self.present(setNavVC, animated: true, completion: nil)
    }
}
