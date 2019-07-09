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


// 按钮点击事件回调
typealias ButtonClickBlock =  (_ clickType:ButtonClickType,_ button:UIButton) ->Void

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
   lazy fileprivate var filterView : SPRecordVideoFilterView! = {
        let view =  SPRecordVideoFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.sp_cornerRadius(cornerRadius: filterViewWidth / 2.0)
        return view
    } () //滤镜显示view
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
        self.setupVideoManager()
        self.setupUI()
        self.addActionToButton()
        self.addPinchGeusture()
        // Do any additional setup after loading the view.
    }
    /*
     设置videoManager
     */
    fileprivate func setupVideoManager(){
        self.videoManager.setup(noCameraAuthBlock: { [weak self] () in
            self?.dealNOCameraAuthAction()
        }, noMicrophoneBlock: { [weak self] () in
            self?.dealNOMicrophoneAuthAction()
        })
        
        self.videoManager.videoLayer = self.preView.layer as? AVCaptureVideoPreviewLayer
        self.videoManager.addObserver(self, forKeyPath: kVideoManagerKVOKey, options: .new, context: nil)
        self.videoManager.setupRecord()
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
    deinit {
        SPLog("销毁对象")
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
    
    // 创建UI
    func setupUI (){
        
        self.view.addSubview(self.preView)
        self.preView.backgroundColor = UIColor.black
        self.view .addSubview(self.recordVideoView)
        self.view.addSubview(self.filterView)
        self.addConstraintToView()
    }
    /**< 添加约束到view  */
    private func addConstraintToView(){
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
    }
}

// MARK: -- 处理事件
extension SPRecordVideoRootVC {
    // 添加事件到按钮
    fileprivate func addActionToButton(){
        self.recordVideoView.buttonClickBlock = { [weak self](clickType : ButtonClickType,button:UIButton) in
            self?.dealButtonClickAction(clickType: clickType, button: button)
        }
        self.filterView.collectSelectComplete = { [weak self](model : SPFilterModel)  in
                self?.videoManager.filter = model.filter
        }
    }
    // 添加缩放手势
    fileprivate func addPinchGeusture(){
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        self.view.addGestureRecognizer(pinchGesture)
    }
    @objc fileprivate func pinchAction(sender : UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            lastScale = 1.0
            return
        }
        let scale = 1.0 - (lastScale - sender.scale)
        if lastScale >= sender.scale {
            SPLog("缩小")
            videoManager.sp_zoomOut(scale: 0.1)
        }else{
            SPLog("放大")
            videoManager.sp_zoomIn(scale:0.1)
        }
        SPLog("\(scale)----\(lastScale)----\(sender.velocity)")
        lastScale = sender.scale
        
    }
    /*
      处理按钮点击事件的
     */
    fileprivate func dealButtonClickAction(clickType : ButtonClickType,button:UIButton){
        switch clickType {
        case .cance:
            SPLog("点击取消")
           self.clickCance()
        case .done:
            
            if button.isSelected {
                SPLog("点击结束")
                self.videoManager.sp_stopRecord()
            }else {
                SPLog("点击录制")
                self.videoManager.sp_startRecord()
            }
            button.isSelected = !button.isSelected
        case .flash:
            SPLog("点击闪光灯")
            button.isSelected = !button.isSelected
            self.videoManager.sp_flashlight()
        case .change:
            SPLog("点击切换镜头")
            self.videoManager.sp_changeVideoDevice()
        case .filter:
            self.clickFilterAction();
             SPLog("点击滤镜 ")
        default:
            SPLog("其他没有定义")
        }
    }
    fileprivate func clickCance(){
        self.videoManager.sp_cance()
        self.videoManager.sp_flashOff()
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
    fileprivate func clickFilterAction(){
        if(self.filterView.isHidden){
            self.filterRightConstraint?.update(offset: 0)
        }else{
            self.filterRightConstraint?.update(offset: -filterViewWidth)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        self.changeFilterData()
    }
    /*
     改变滤镜图片的数据
     */
    fileprivate func changeFilterData(){
        sp_dispatchMainQueue {
            if (self.filterView.isHidden == false){
                self.videoData.setup(inputImage: self.videoManager.noFilterCIImage, complete: { [weak self] () in
                    sp_dispatchMainQueue {
                        self?.filterView.filterList = self?.videoData.getFilterList()
                    }
                })
            }
        }
    }
    /*
     监听图片改变的
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kVideoManagerKVOKey {
            self.changeFilterData()
        }
    }
    /*
     处理没有摄像头权限的事件
     */
    fileprivate func dealNOCameraAuthAction(){
        let alert = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_CAMERA_AUTH_TIPS"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertActionStyle.cancel, handler: {(action ) in
            self.disMissVC()
        }))
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GO_TO_SET"), style: UIAlertActionStyle.default, handler: { (action) in
            SPSysSet.openSetting()
             self.disMissVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     处理没有麦克风的事件
     */
    fileprivate func dealNOMicrophoneAuthAction(){
        let alert = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_MICROPHONE_AUTH_TIPS"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GO_TO_SET"), style: UIAlertActionStyle.default, handler: { (action) in
            SPSysSet.openSetting()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     隐藏控制器
     */
    fileprivate func disMissVC (){
        self.dismiss(animated: true, completion: nil)
    }
}

class SPRecordVideoBtnView: UIView {
    
    lazy fileprivate var canceButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title:"",selectTitle: nil, fontsize: 14,norImage: UIImage(named: "back"))
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
        label.font = sp_fontSize(fontSize: 14);
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
        button.titleLabel?.font = sp_fontSize(fontSize: fontsize)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        if let image = norImage {
            button.setImage(image, for: UIControlState.normal)
        }
        
        if let sImage = selectImage {
            button.setImage(sImage, for: UIControlState.selected)
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
        self .addSubview(canceButton)
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
            sp_dispatchMainQueue {
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
        canceButton.addTarget(self, action: #selector(clickCanceAction), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(clickDoneAction), for: .touchUpInside)
        if !SP_IS_IPAD {
         flashLampButton.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
        }
        changeButton.addTarget(self, action: #selector(clickChangeAction), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(clickFilterAction), for: .touchUpInside)
    }
    // 点击取消
    @objc func clickCanceAction(){
        self.dealAction(clickType: .cance, button: canceButton)
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
    
    func dealAction(clickType:ButtonClickType,button : UIButton) {
        buttonClickBlock?(clickType,button)
    }
    
    fileprivate func addConstraintToView(){
        self.canceButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.height.equalTo(40)
            maker.width.equalTo(40)
            maker.top.equalTo(self).offset(10)
        }
        self.recordButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.canceButton.snp.top)
            maker.height.equalTo(self.canceButton.snp.height)
            maker.width.equalTo(self.canceButton)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
        }
        if !SP_IS_IPAD {
            self.flashLampButton.snp.makeConstraints { (maker) in
                maker.height.equalTo(self.canceButton.snp.height)
                maker.top.equalTo(self.canceButton.snp.top)
                maker.width.equalTo(self.canceButton)
                maker.right.equalTo(self.snp.right).offset(-12)
            }
        }
        
        self.filterButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.left).multipliedBy(0.5)
            maker.height.equalTo(self.canceButton.snp.height)
            maker.width.equalTo(self.canceButton.snp.width).offset(0)
            maker.top.equalTo(self.canceButton.snp.top).offset(0)
        }
        self.changeButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.left).multipliedBy(1.5)
            maker.height.equalTo(self.canceButton.snp.height).offset(0)
            maker.width.equalTo(self.canceButton.snp.width).offset(0)
            maker.top.equalTo(self.filterButton.snp.top).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.canceButton.snp.bottom).offset(10)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.width.equalTo(120)
            maker.height.equalTo(self.filterButton.snp.height)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
       
    }
    
    
}
