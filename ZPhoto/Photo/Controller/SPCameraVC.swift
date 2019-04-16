//
//  SPCameraVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/15.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import AVFoundation

class SPCameraVC : SPBaseNavVC {
    internal init() {
        super.init(rootViewController: SPCameraRootVC());
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

fileprivate class SPCameraRootVC: SPBaseVC {
    lazy fileprivate var preView : SPVideoPreviewLayerView = {
        return SPVideoPreviewLayerView()
    }() // 显示的view
    lazy fileprivate var cameraManmager : SPCameraManager = {
        let manager = SPCameraManager()
       
        return manager
    }()
    fileprivate lazy var btnView : SPCameraBtnView = {
        let view = SPCameraBtnView()
        view.clickBlock = { [weak self] (type)in
            self?.sp_dealBtnClick(type: type)
        }
        return view
    }()
    fileprivate lazy var filterView : SPRecordVideoFilterView = {
        let view =  SPRecordVideoFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.collectSelectComplete = { [weak self](model : SPFilterModel)  in
            self?.cameraManmager.filter = model.filter
        }
        return view
    }() //滤镜显示view
    lazy fileprivate var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
    fileprivate var filterRightConstraint : Constraint!
    fileprivate let filterViewHeight :  CGFloat = 60
     fileprivate let kCameraManagerKVOKey = "noFilterCIImage"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_initCamera()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    fileprivate func sp_initCamera(){
        self.cameraManmager.videoLayer = self.preView.layer as? AVCaptureVideoPreviewLayer
        self.cameraManmager.sp_initCamera()
         self.cameraManmager.addObserver(self, forKeyPath: kCameraManagerKVOKey, options: .new, context: nil)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.preView)
        self.preView.backgroundColor = UIColor.black
        self.view.addSubview(self.btnView)
         self.view.addSubview(self.filterView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    func sp_addConstraint(){
        self.preView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self.view).offset(0)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.filterView.snp.makeConstraints { (maker) in
            filterRightConstraint =  maker.right.equalTo(self.view).offset(0).constraint
            maker.height.equalTo(self.view.snp.height).multipliedBy(0.5)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
            maker.width.equalTo(filterViewHeight)
        }
    }
    deinit {
        self.cameraManmager.removeObserver(self, forKeyPath: kCameraManagerKVOKey)
    }
}
fileprivate extension SPCameraRootVC{
    
    func sp_dealBtnClick(type:ButtonClickType){
        switch type {
        case .cance:
            SPLog("点击返回")
            sp_back()
        case .done:
            SPLog("点击拍照")
            sp_clickCamera()
        case .filter:
            SPLog("点击滤镜")
            sp_clickFilter()
        case .flash:
            SPLog("点击闪光灯")
            sp_clickFlash()
        case .change:
            SPLog("点击切换镜头")
            sp_clickChangeDev()
        }
    }
    func sp_back(){
        self.cameraManmager.sp_cane()
        self.dismiss(animated: true, completion: nil)
    }
    func sp_clickCamera(){
        let outputCIImg = self.cameraManmager.filterCGImage
        var outputImg : UIImage?
        if let ciImg = outputCIImg {
            outputImg = UIImage(cgImage: ciImg)
        }
        if let img = outputImg {
            let imgData = UIImageJPEGRepresentation(img, 0.5)
            if let data = imgData {
                do {
                    try data.write(to: URL(fileURLWithPath: SPPhotoHelp.SPPhotoDirectory + "/" + SPPhotoHelp.sp_getFileName()), options: Data.WritingOptions.atomic)
                }catch {
                    SPLog("写入缓存数据失败")
                }
            }else{
                SPLog("转换数据出错")
            }
        }
    }
    func sp_clickFilter(){
        if(self.filterView.isHidden){
            self.filterRightConstraint.update(offset: 0)
        }else{
            self.filterRightConstraint.update(offset: -filterViewHeight)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        sp_changeFilterData()
    }
    /*
     改变滤镜图片的数据
     */
    func sp_changeFilterData(){
        sp_dispatchMainQueue {
            if (self.filterView.isHidden == false){
                self.videoData.setup(inputImage: self.cameraManmager.noFilterCIImage, complete: { [weak self] () in
                    sp_dispatchMainQueue {
                        self?.filterView.filterList = self?.videoData.getFilterList()
                    }
                })
            }
        }
    }
    func sp_clickFlash(){
        self.cameraManmager.sp_flashlight()
    }
    func sp_clickChangeDev(){
        self.cameraManmager.sp_changeCamera()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kCameraManagerKVOKey {
                sp_changeFilterData()
        }
    }
    
}
