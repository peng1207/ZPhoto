//
//  SPRecordVideoVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/4/8.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import SPCommonLibrary

// 按钮点击事件回调
typealias ButtonClickBlock =  (_ clickType:SPButtonClickType,_ button:UIButton) ->Void

class SPRecordVideoVC: SPBaseNavVC {
    
    internal init() {
        super.init(rootViewController: SPRecordVideoRootVC());
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

fileprivate class SPRecordVideoRootVC: SPBaseVC {
    lazy fileprivate var recordVideoView : SPRecordVideoBtnView! = {
        let view = SPRecordVideoBtnView()
        view.backgroundColor = UIColor.clear
        return view
    }() // 操作按钮
    lazy fileprivate var preView : SPVideoPreviewLayerView = {
        return SPVideoPreviewLayerView()
    }() // 显示视频流
    lazy fileprivate var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
   lazy fileprivate var filterView : SPFilterView! = {
        let view =  SPFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.sp_cornerRadius(radius: filterViewWidth / 2.0)
        return view
    } () //滤镜显示view
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_cance), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var layoutView : SPVideoLayoutView = {
        let view = SPVideoLayoutView()
        view.isHidden = true
        view.selectBlock = { [weak self] (type) in
            self?.sp_deal(videoLayoutType: type)
        }
        return view
    }()
    fileprivate var pinchGesture : UIPinchGestureRecognizer!  // 手势
    fileprivate var lastScale : CGFloat = 1.00
    
    lazy fileprivate var videoManager : SPRecordVideoManager! = {
        let manager = SPRecordVideoManager()
        return manager
    }()  // 视频处理类
    
    fileprivate let kVideoManagerKVOKey = "noFilterCIImage"
    fileprivate var filterRightConstraint : Constraint? = nil
    fileprivate let filterViewWidth :  CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupVideoManager()
        self.sp_setupUI()
        self.sp_addAction()
        self.sp_addGeusture()
        // Do any additional setup after loading the view.
    }
    /// 设置videoManager
    fileprivate func sp_setupVideoManager(){
        self.videoManager.sp_complete(noCameraAuthBlock: { [weak self] () in
            self?.dealNOCameraAuthAction()
        }, noMicrophoneBlock: { [weak self] () in
            self?.dealNOMicrophoneAuthAction()
        })
        self.videoManager.videoLayer = self.preView.layer as? AVCaptureVideoPreviewLayer
        self.videoManager.addObserver(self, forKeyPath: kVideoManagerKVOKey, options: .new, context: nil)
        self.videoManager.sp_initRecord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.dealOrientation(toInterfaceOrientation: toInterfaceOrientation)
    }
    // 创建UI
   override func sp_setupUI (){
        
        self.view.addSubview(self.preView)
        self.preView.backgroundColor = UIColor.black
        self.view .addSubview(self.recordVideoView)
        self.view.addSubview(self.filterView)
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    
    deinit {
        sp_log(message: "销毁对象")
        videoManager.removeObserver(self, forKeyPath: kVideoManagerKVOKey)
        recordVideoView.removeFromSuperview()
        recordVideoView = nil
        videoManager = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: -- UI 
extension SPRecordVideoRootVC {
    
 
    /**< 添加约束到view  */
    private func sp_addConstraint(){
        self.preView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self.view).offset(0);
        }
        self.recordVideoView.snp.makeConstraints { (maker) in
            maker.right.left.equalTo(self.view).offset(0);
            maker.height.greaterThanOrEqualTo(0)
            
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0);
            };
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
            maker.bottom.equalTo(self.recordVideoView.snp.top).offset(0)
            maker.height.equalTo(40)
        }
    }
}

// MARK: -- 处理事件
extension SPRecordVideoRootVC {
    // 添加事件到按钮
    fileprivate func sp_addAction(){
        self.recordVideoView.buttonClickBlock = { [weak self](clickType : SPButtonClickType,button:UIButton) in
            self?.sp_deal(clickType: clickType, button: button)
        }
        self.filterView.collectSelectComplete = { [weak self](model : SPFilterModel)  in
                self?.videoManager.filter = model.filter
        }
    }
    // 添加缩放手势
    fileprivate func sp_addGeusture(){
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(sp_pinchAction(sender:)))
        self.view.addGestureRecognizer(pinchGesture)
    }
    @objc fileprivate func sp_pinchAction(sender : UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            lastScale = 1.0
            return
        }
        let scale = 1.0 - (lastScale - sender.scale)
        if lastScale >= sender.scale {
            sp_log(message: "缩小")
            videoManager.sp_zoomOut(scale: 0.1)
        }else{
            sp_log(message: "放大")
            videoManager.sp_zoomIn(scale:0.1)
        }
        sp_log(message: "\(scale)----\(lastScale)----\(sender.velocity)")
        lastScale = sender.scale
        
    }
    /*
      处理按钮点击事件的
     */
    fileprivate func sp_deal(clickType : SPButtonClickType,button:UIButton){
        switch clickType {
        case .cance:
            sp_log(message: "点击取消")
           self.sp_cance()
        case .done:
            if button.isSelected {
                sp_log(message: "点击结束")
                self.videoManager.sp_stopRecord()
            }else {
                sp_log(message: "点击录制")
                self.videoManager.sp_startRecord()
            }
            button.isSelected = !button.isSelected
        case .flash:
            sp_log(message: "点击闪光灯")
            button.isSelected = !button.isSelected
            self.videoManager.sp_flashlight()
        case .change:
            sp_log(message: "点击切换镜头")
            self.videoManager.sp_changeCamera()
        case .filter:
            self.sp_filterAction();
             sp_log(message: "点击滤镜 ")
        case .layout:
            self.layoutView.isHidden = !self.layoutView.isHidden
        default:
            sp_log(message: "其他没有定义")
        }
    }
   @objc fileprivate func sp_cance(){
        self.videoManager.sp_cance()
    
        self.disMissVC()
        self.recordVideoView.canceTimer()
    }
    
    /**< 处理屏幕旋转后视频的方向  */
    fileprivate func dealOrientation(toInterfaceOrientation: UIInterfaceOrientation){
        switch toInterfaceOrientation {
        case .landscapeLeft:
            self.videoManager.videoLayer?.connection!.videoOrientation = .landscapeLeft
        case .landscapeRight:
            self.videoManager.videoLayer?.connection!.videoOrientation = .landscapeRight
        case .portrait:
            self.videoManager.videoLayer?.connection!.videoOrientation = .portrait
        case .portraitUpsideDown:
            self.videoManager.videoLayer?.connection!.videoOrientation = .portraitUpsideDown
        default: break
            
        }
    }
    /*
      点击滤镜按钮事件
     */
    @objc fileprivate func sp_filterAction(){
        if(self.filterView.isHidden){
            self.filterRightConstraint?.update(offset: 0)
        }else{
            self.filterRightConstraint?.update(offset: -filterViewWidth)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        self.sp_changeFilterData()
    }
    /*
     改变滤镜图片的数据
     */
    fileprivate func sp_changeFilterData(){
        sp_mainQueue {
            if (self.filterView.isHidden == false){
                sp_sync {
                    self.videoData.setup(inputImage: self.videoManager.noFilterCIImage, complete: { [weak self] () in
                        sp_mainQueue {
                            self?.filterView.filterList = self?.videoData.getFilterList()
                        }
                    })
                }
            }
        }
    }
    /*
     监听图片改变的
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kVideoManagerKVOKey {
            self.sp_changeFilterData()
        }
    }
    /*
     处理没有摄像头权限的事件
     */
    fileprivate func dealNOCameraAuthAction(){
        let alert = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_CAMERA_AUTH_TIPS"), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: {(action ) in
            self.disMissVC()
        }))
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GO_TO_SET"), style: UIAlertAction.Style.default, handler: { (action) in
            sp_sysOpen()
             self.disMissVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     处理没有麦克风的事件
     */
    fileprivate func dealNOMicrophoneAuthAction(){
        let alert = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_MICROPHONE_AUTH_TIPS"), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GO_TO_SET"), style: UIAlertAction.Style.default, handler: { (action) in
            sp_sysOpen()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     隐藏控制器
     */
    fileprivate func disMissVC (){
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func sp_deal(videoLayoutType : SPVideoLayoutType){
        self.videoManager.videoLayoutType = videoLayoutType
    }
}

class SPRecordVideoBtnView: UIView {
    
    lazy fileprivate var layoutButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title:"",selectTitle: nil, fontsize: 14,norImage: UIImage(named: "public_layout"))
    }()
    lazy fileprivate var recordButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "",selectTitle: nil, fontsize: 14,norImage: UIImage(named: "recordStart"),selectImage: UIImage(named: "recordStop"))
    }()
    lazy fileprivate var flashLampButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "",selectTitle: "", fontsize: 14,norImage: UIImage(named: "flashOn"),selectImage: UIImage(named: "flashOff"))
    }()
    lazy fileprivate var changeButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "", selectTitle: nil , fontsize: 14,norImage: UIImage(named: "switchCamera"))
    }()
    lazy fileprivate var filterButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "", selectTitle: nil, fontsize: 14,norImage: UIImage(named: "filter"))
    }()
    lazy fileprivate var timeLabel : UILabel! = {
        let label = UILabel();
        label.font =  sp_fontSize(fontSize: 14);
        label.textAlignment = NSTextAlignment.center;
        label.text = "00:00"
        label.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 40.0 / 2.0
        label.clipsToBounds = true
        return label;
    }()
    
    fileprivate var buttonClickBlock : ButtonClickBlock?
    fileprivate var sourceTimer : DispatchSourceTimer?
    
    class fileprivate func setupButton (title:String,selectTitle:String?,fontsize:CGFloat,norImage:UIImage? = nil, selectImage : UIImage? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        if let select = selectTitle {
            button.setTitle(select, for: .selected)
        }
        button.titleLabel?.font =  sp_fontSize(fontSize: fontsize)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        if let image = norImage {
            button.setImage(image, for: UIControl.State.normal)
        }
        
        if let sImage = selectImage {
            button.setImage(sImage, for: UIControl.State.selected)
        }
        
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.addActionToButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        self.canceTimer()
    }
    
    fileprivate func setupUI(){
        self .addSubview(layoutButton)
        self.addSubview(recordButton)
        if !SP_IS_IPAD {
             self.addSubview(flashLampButton)
        }
        self.addSubview(changeButton)
        self.addSubview(filterButton)
        self.addSubview(timeLabel)
        self.addConstraintToView()
        
    }
    // 设置定时器
    fileprivate func setupTimer (){
        var i = 0;
        sourceTimer = timer({
            sp_mainQueue {
                self.timeLabel.text = formatForMin(seconds: Float64(i))
            }
            i = i + 1
        })
    }
    // 取消定时器
    fileprivate func canceTimer(){
        if let timer = sourceTimer {
            timer.cancel()
            sourceTimer  = nil
            timeLabel.text = "00:00"
        }
    }
    
    // 添加按钮点击事件
    fileprivate func addActionToButton (){
        layoutButton.addTarget(self, action: #selector(clickLayoutAction), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(clickDoneAction), for: .touchUpInside)
        if !SP_IS_IPAD {
         flashLampButton.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
        }
        changeButton.addTarget(self, action: #selector(clickChangeAction), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(clickFilterAction), for: .touchUpInside)
    }
    // 点击取消
    @objc func clickLayoutAction(){
        self.dealAction(clickType: .layout, button: layoutButton)
    }
    // 点击完成
    @objc func clickDoneAction(){
        self.dealAction(clickType: .done, button: recordButton)
        if recordButton.isSelected{
            self.setupTimer()
        }else{
            self.canceTimer()
        }
    }
    // 点击 闪光灯
    @objc func clickOpenAction(){
        self.dealAction(clickType: .flash, button: flashLampButton)
    }
    // 点击切换
    @objc func  clickChangeAction(){
        self.dealAction(clickType: .change, button: changeButton)
    }
    // 点击滤镜
    @objc func clickFilterAction(){
        self.dealAction(clickType: .filter, button: filterButton)
    }
    
    func dealAction(clickType:SPButtonClickType,button : UIButton) {
        buttonClickBlock?(clickType,button)
    }
    
    fileprivate func addConstraintToView(){
        self.layoutButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.height.equalTo(40)
            maker.width.equalTo(40)
            maker.top.equalTo(self).offset(10)
        }
        self.recordButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.layoutButton.snp.top)
            maker.height.equalTo(self.layoutButton.snp.height)
            maker.width.equalTo(self.layoutButton)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
        }
        if !SP_IS_IPAD {
            self.flashLampButton.snp.makeConstraints { (maker) in
                maker.height.equalTo(self.layoutButton.snp.height)
                maker.top.equalTo(self.layoutButton.snp.top)
                maker.width.equalTo(self.layoutButton)
                maker.right.equalTo(self.snp.right).offset(-12)
            }
        }
        self.filterButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.left).multipliedBy(0.5)
            maker.height.equalTo(self.layoutButton.snp.height)
            maker.width.equalTo(self.layoutButton.snp.width).offset(0)
            maker.top.equalTo(self.layoutButton.snp.top).offset(0)
        }
        self.changeButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.left).multipliedBy(1.5)
            maker.height.equalTo(self.layoutButton.snp.height).offset(0)
            maker.width.equalTo(self.layoutButton.snp.width).offset(0)
            maker.top.equalTo(self.filterButton.snp.top).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.layoutButton.snp.bottom).offset(10)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.width.equalTo(120)
            maker.height.equalTo(self.filterButton.snp.height)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
       
    }
    
    
}
