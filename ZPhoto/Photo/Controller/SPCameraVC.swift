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
import SPCommonLibrary
/// 相机
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
            self?.sp_deal(buttontype: type)
        }
        return view
    }()
    fileprivate lazy var filterView : SPFilterView = {
        let view =  SPFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.collectSelectComplete = { [weak self](model : SPFilterModel)  in
            self?.cameraManmager.filter = model.filter
        }
        view.sp_cornerRadius(radius: filterViewWidth / 2.0)
        return view
    }() //滤镜显示view
    fileprivate lazy var layoutView : SPVideoLayoutView = {
        let view = SPVideoLayoutView()
        view.isHidden = true
        view.selectBlock = { [weak self] (type) in
            self?.sp_deal(videoLayoutType: type)
        }
        return view
    }()
    fileprivate lazy var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
         btn.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_back), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate var filterRightConstraint : Constraint!
    fileprivate let filterViewWidth :  CGFloat = 60
    fileprivate let kCameraManagerKVOKey = "noFilterCIImage"
    fileprivate var lastScale : CGFloat = 1.00
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_initCamera()
        sp_addGesture()
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
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.backBtn)
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
            maker.width.equalTo(filterViewWidth)
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.width.height.equalTo(40)
            maker.top.equalTo(self.view).offset(sp_statusBarHeight() + 2)
        }
        self.layoutView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.btnView.snp.top).offset(0)
            maker.height.equalTo(40)
        }
    }
    deinit {
        self.cameraManmager.removeObserver(self, forKeyPath: kCameraManagerKVOKey)
    }
}
fileprivate extension SPCameraRootVC{
    
    /// 处理按钮点击类型
    ///
    /// - Parameter type: 类型
    func sp_deal(buttontype:SPButtonClickType){
        switch buttontype {
        case .cance:
            sp_log(message: "点击返回")
            sp_back()
        case .done:
            sp_log(message: "点击拍照")
            sp_clickCamera()
        case .filter:
            sp_log(message: "点击滤镜")
            sp_clickFilter()
        case .flash:
            sp_log(message: "点击闪光灯")
            sp_clickFlash()
        case .change:
            sp_log(message: "点击切换镜头")
            sp_clickChangeDev()
        case .layout:
            self.layoutView.isHidden = !self.layoutView.isHidden
        default:
            sp_log(message: "没有定义")
        }
    }
     func sp_deal(videoLayoutType:SPVideoLayoutType){
        self.cameraManmager.videoLayoutType = videoLayoutType
    }
    /// 点击返回
   @objc func sp_back(){
        self.cameraManmager.sp_cane()
        self.dismiss(animated: true, completion: nil)
    }
    /// 点击拍照
    func sp_clickCamera(){
        let outputCIImg = self.cameraManmager.showOutputCGImage
        var outputImg : UIImage?
        if let ciImg = outputCIImg {
            outputImg = UIImage(cgImage: ciImg)
        }
        if let img = outputImg {
            
            let imgData = img.jpegData(compressionQuality: 0.5)
            if let data = imgData {
                do {
                    try data.write(to: URL(fileURLWithPath: SPPhotoHelp.SPPhotoDirectory + "/" + SPPhotoHelp.sp_getFileName()), options: Data.WritingOptions.atomic)
                }catch {
                    sp_log(message: "写入缓存数据失败")
                }
            }else{
                sp_log(message: "转换数据出错")
            }
        }
    }
    /// 点击滤镜
    func sp_clickFilter(){
        if(self.filterView.isHidden){
            self.filterRightConstraint.update(offset: 0)
        }else{
            self.filterRightConstraint.update(offset: -filterViewWidth)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        sp_changeFilterData()
    }
    /*
     改变滤镜图片的数据
     */
    func sp_changeFilterData(){
      
        sp_mainQueue {
            if (self.filterView.isHidden == false){
                sp_sync {
                    self.videoData.setup(inputImage: self.cameraManmager.noFilterCIImage, complete: { [weak self] () in
                        sp_mainQueue {
                            self?.filterView.filterList = self?.videoData.getFilterList()
                        }
                    })
                }
            }
        }
    }
    /// 点击闪光灯
    func sp_clickFlash(){
        if self.cameraManmager.sp_flashlight() {
            self.btnView.sp_deal(btnType: .flash, isSelect: true)
        }else{
            self.btnView.sp_deal(btnType: .flash, isSelect: false)
        }
       
    }
    /// 更改前后摄像头
    func sp_clickChangeDev(){
        self.cameraManmager.sp_changeCamera()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kCameraManagerKVOKey {
                sp_changeFilterData()
        }
    }
    
    func sp_addGesture(){
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(sp_pinchAction(sender:))))
    }
    @objc func sp_pinchAction(sender : UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            lastScale = 1.0
            return
        }
        let scale = 1.0 - (lastScale - sender.scale)
        if lastScale >= sender.scale {
            sp_log(message: "缩小")
            self.cameraManmager.sp_zoomOut(scale: 0.1)
        }else{
            sp_log(message: "放大")
            self.cameraManmager.sp_zoomIn(scale:0.1)
        }
        sp_log(message: "\(scale)----\(lastScale)----\(sender.velocity)")
        lastScale = sender.scale
        
    }
}
