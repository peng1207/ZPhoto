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
    }()
    lazy fileprivate var preView : SPRecordVideoView! = {
        return SPRecordVideoView()
    }()
    
    fileprivate var changeButton : UIButton!
    fileprivate var pinchGesture : UIPinchGestureRecognizer!
    fileprivate var lastScale : CGFloat = 1.00
    
    lazy fileprivate var videoManager : SPRecordVideoManager! = {
        let manager = SPRecordVideoManager()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
     
        self.setupUI()
        self.videoManager.videoLayer = self.preView.layer as? AVCaptureVideoPreviewLayer
        self.videoManager.setupRecord()
        self.addChangeButton()
        self.addactionToButton()
        self.addPinchGeusture()
        // Do any additional setup after loading the view.
    }
  
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.dealOrientation(toInterfaceOrientation: toInterfaceOrientation)
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
        self.view .addSubview(self.recordVideoView)
        self.addConstraintToView()
    }
    /**< 添加约束到view  */
    private func addConstraintToView(){
        self.preView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self.view).offset(0);
        }
        self.recordVideoView.snp.makeConstraints { (maker) in
            maker.bottom.right.left.equalTo(self.view).offset(0);
            maker.height.equalTo(60)
        }
    }
    
    // 添加切换按钮
    func addChangeButton (){
        changeButton = SPRecordVideoBtnView.setupButton(title: "切换",selectTitle: nil, fontsize: 14)
        changeButton.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        changeButton.addTarget(self, action: #selector(clickChangeAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: changeButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
}

// MARK: -- 处理事件
extension SPRecordVideoRootVC {
    // 添加事件到按钮
    fileprivate func addactionToButton(){
        self.recordVideoView.buttonClickBlock = { [weak self](clickType : ButtonClickType,button:UIButton) in
            self?.dealButtonClickAction(clickType: clickType, button: button)
        }
    }
    @objc fileprivate func clickChangeAction(){
        self.dealButtonClickAction(clickType: .change, button: changeButton)
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
        self.addConstraintToView()
        
    }
    fileprivate func addActionToButton (){
        canceButton.addTarget(self, action: #selector(clickCanceAction), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(clickDoneAction), for: .touchUpInside)
        flashLampButton.addTarget(self, action: #selector(clickOpenAction), for: .touchUpInside)
    }
    // 点击取消
    func clickCanceAction(){
        self.dealAction(clickType: .cance, button: canceButton)
    }
    func clickDoneAction(){
        self.dealAction(clickType: .done, button: recordButton)
    }
    func clickOpenAction(){
        self.dealAction(clickType: .flash, button: flashLampButton)
    }
    func dealAction(clickType:ButtonClickType,button : UIButton) {
        buttonClickBlock?(clickType,button)
    }
    
    fileprivate func addConstraintToView(){
        self.canceButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.height.equalTo(self.snp.height).offset(-20)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.equalTo(self.recordButton)
        }
        self.recordButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceButton.snp.right).offset(20)
            maker.centerY.equalTo(self.canceButton.snp.centerY)
            maker.height.equalTo(self.canceButton.snp.height)
            maker.width.equalTo(self.flashLampButton)
        }
        self.flashLampButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordButton.snp.right).offset(20)
            maker.height.equalTo(self.recordButton.snp.height)
            maker.centerY.equalTo(self.recordButton.snp.centerY)
            maker.width.equalTo(self.canceButton)
            maker.right.equalTo(self.snp.right).offset(-12)
        }
    }
    
    
}
