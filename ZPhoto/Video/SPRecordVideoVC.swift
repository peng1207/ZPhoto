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

// 按钮点击事件
public enum ButtonClickType : Int {
    case done                // 点击完成
    case cance               // 点击取消
    case flash               // 点击闪光灯
    case change             // 点击切换镜头
    case filter                 // 点击滤镜
}
// 按钮点击事件回调
typealias ButtonClickBlock =  (_ clickType:ButtonClickType,_ button:UIButton) ->Void


class SPRecordVideoVC: UINavigationController {
    
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
    lazy fileprivate var preView : SPRecordVideoView! = {
        return SPRecordVideoView()
    }() // 显示视频流
    lazy fileprivate var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
    fileprivate var filterView : SPRecordVideoFilterView! = {
        let view =  SPRecordVideoFilterView()
        view.isHidden = true
        return view
    } () //滤镜显示view
    fileprivate var pinchGesture : UIPinchGestureRecognizer!  // 手势
    fileprivate var lastScale : CGFloat = 1.00
    
    lazy fileprivate var videoManager : SPRecordVideoManager! = {
        let manager = SPRecordVideoManager()
        return manager
    }()  // 视频处理类
    
    fileprivate let kVideoManagerKVOKey = "noFilterCIImage"
    fileprivate var filterTopConstraint : Constraint? = nil
    fileprivate let filterViewHeight :  CGFloat = 60.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setupUI()
        self.videoManager.videoLayer = self.preView.layer as? AVCaptureVideoPreviewLayer
        self.videoManager.addObserver(self, forKeyPath: kVideoManagerKVOKey, options: .new, context: nil)
        self.videoManager.setupRecord()
        self.addActionToButton()
        self.addPinchGeusture()
        // Do any additional setup after loading the view.
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
        videoManager.removeObserver(self, forKeyPath: kVideoManagerKVOKey)
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
            filterTopConstraint = maker.top.equalTo(self.view).offset( -(filterViewHeight + getStatusBarHeight())).constraint
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(filterViewHeight)
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
    
    fileprivate func dealButtonClickAction(clickType : ButtonClickType,button:UIButton){
        switch clickType {
        case .cance:
            SPLog("点击取消")
            self.videoManager.sp_cance()
            self.dismiss(animated: true, completion: nil)
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
        }
    }
 
    
    /**< 处理屏幕旋转后视频的方向  */
    fileprivate func dealOrientation(toInterfaceOrientation: UIInterfaceOrientation){
        switch toInterfaceOrientation {
        case .landscapeLeft:
            self.videoManager.videoLayer?.connection.videoOrientation = .landscapeLeft
        case .landscapeRight:
            self.videoManager.videoLayer?.connection.videoOrientation = .landscapeRight
        case .portrait:
            self.videoManager.videoLayer?.connection.videoOrientation = .portrait
        case .portraitUpsideDown:
            self.videoManager.videoLayer?.connection.videoOrientation = .portraitUpsideDown
        default: break
            
        }
    }
    
    fileprivate func clickFilterAction(){
        if(self.filterView.isHidden){
            self.filterTopConstraint?.update(offset: getStatusBarHeight())
        }else{
            self.filterTopConstraint?.update(offset: -filterViewHeight)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        self.changeFilterData()
    }
    
    fileprivate func changeFilterData(){
        dispatchMainQueue {
            if (self.filterView.isHidden == false){
                self.videoData.setup(inputImage: self.videoManager.noFilterCIImage, complete: { [weak self] () in
                    dispatchMainQueue {
                        self?.filterView.filterList = self?.videoData.getFilterList()
                    }
                })
            }
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kVideoManagerKVOKey {
            self.changeFilterData()
        }
    }
    
}

class SPRecordVideoBtnView: UIView {
    
    lazy var canceButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "cance",selectTitle: nil, fontsize: 14)
    }()
    lazy var recordButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "start",selectTitle: "end", fontsize: 14)
    }()
    lazy var flashLampButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "on",selectTitle: "off", fontsize: 14)
    }()
    lazy var changeButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "切换", selectTitle: nil , fontsize: 14)
    }()
    lazy var filterButton : UIButton! = {
        return SPRecordVideoBtnView.setupButton(title: "滤镜", selectTitle: nil, fontsize: 14)
    }()
    var buttonClickBlock : ButtonClickBlock?
    
    class func setupButton (title:String,selectTitle:String?,fontsize:CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.setTitle(title, for: .normal)
        if let select = selectTitle {
            button.setTitle(select, for: .selected)
        }
        button.titleLabel?.font = fontSize(fontSize: fontsize)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        button.layer.cornerRadius = 40.0 / 2.0
        button.clipsToBounds = true
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
    
    fileprivate func setupUI(){
        self .addSubview(canceButton)
        self.addSubview(recordButton)
        self.addSubview(flashLampButton)
        self.addSubview(changeButton)
        self.addSubview(filterButton)
        self.addConstraintToView()
        
    }
    fileprivate func addActionToButton (){
        canceButton.addTarget(self, action: #selector(clickCanceAction), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(clickDoneAction), for: .touchUpInside)
        flashLampButton.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(clickChangeAction), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(clickFilterAction), for: .touchUpInside)
    }
    // 点击取消
    func clickCanceAction(){
        self.dealAction(clickType: .cance, button: canceButton)
    }
    // 点击完成
    func clickDoneAction(){
        self.dealAction(clickType: .done, button: recordButton)
    }
    // 点击 闪光灯
    func clickOpenAction(){
        self.dealAction(clickType: .flash, button: flashLampButton)
    }
    // 点击切换
    func  clickChangeAction(){
        self.dealAction(clickType: .change, button: changeButton)
    }
    // 点击滤镜
    func clickFilterAction(){
        self.dealAction(clickType: .filter, button: filterButton)
    }
    
    func dealAction(clickType:ButtonClickType,button : UIButton) {
        buttonClickBlock?(clickType,button)
    }

    
    fileprivate func addConstraintToView(){
        self.canceButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.height.equalTo(40)
            maker.width.equalTo(self.recordButton)
            maker.top.equalTo(10)
        }
        self.recordButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceButton.snp.right).offset(20)
            maker.top.equalTo(self.canceButton.snp.top)
            maker.height.equalTo(self.canceButton.snp.height)
            maker.width.equalTo(self.flashLampButton)
        }
        self.flashLampButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.right).offset(20)
            maker.height.equalTo(self.recordButton.snp.height)
            maker.top.equalTo(self.recordButton.snp.top)
            maker.width.equalTo(self.canceButton)
            maker.right.equalTo(self.snp.right).offset(-12)
        }
        self.filterButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceButton.snp.left).offset(0)
            maker.height.equalTo(self.canceButton.snp.height)
            maker.width.equalTo(self.canceButton.snp.width).offset(0)
            maker.top.equalTo(self.canceButton.snp.bottom).offset(10)
        }
        self.changeButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.flashLampButton.snp.right).offset(0)
            maker.height.equalTo(self.flashLampButton.snp.height).offset(0)
            maker.width.equalTo(self.flashLampButton.snp.width).offset(0)
            maker.top.equalTo(self.filterButton.snp.top).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    
    
}
