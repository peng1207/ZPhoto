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
import SPCommonLibrary
class SPPhotoSelectVC: SPBaseVC {

    fileprivate lazy var photoListVC : SPPhotoListVC = {
        let vc = SPPhotoListVC()
        vc.selectBlock = { [weak self](model ) in
            self?.sp_dealSelectComplete(model: model)
        }
        vc.selectMaxCount = selectMaxCount
        vc.isCanAddOther = true
        self.addChild(vc)
        return vc
    }()
    
    fileprivate lazy var selectView : SPPhotoSelectView = {
        let view = SPPhotoSelectView()
        view.clearBlock = { [weak self] in
           self?.sp_clearAll()
        }
        view.indexBlock = { [weak self](index) in
            self?.sp_removeIndex(index: index)
        }
        view.selectMaxCount = selectMaxCount
        return view
    }()
    fileprivate lazy var nextBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "NEXT"), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickNext), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate let selectMaxCount : Int = 9
    var isLong : Bool = false
    
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
extension SPPhotoSelectVC : CAAnimationDelegate{
    
    /// 处理选择的图片
    ///
    /// - Parameter model: 图片model
    func sp_dealSelectComplete(model : SPPhotoModel){
       
        sp_addImgAnimation(img: model.img,point:  self.photoListVC.sp_getCellPoint(model: model))
        self.selectView.sp_add(model: model)
        
    }
    /// 清除所有选中的
    func sp_clearAll(){
        for model in self.selectView.dataArray {
             self.sp_addImgAnimation(img: model.img ,point: self.photoListVC.sp_getCellPoint(model: model),isDow: false)
        }
        self.photoListVC.sp_clearSelect()
    }
    /// 删除某一个
    ///
    /// - Parameter index: 位置
    func sp_removeIndex(index : Int){
        if index < self.selectView.dataArray.count {
            let model = self.selectView.dataArray[index]
            sp_addImgAnimation(img: model.img,point: self.photoListVC.sp_getCellPoint(model: model), isDow: false)
        }
          self.photoListVC.sp_removeSelect(index: index)
        
    }
    /// 图片增加动画
    ///
    /// - Parameters:
    ///   - img: 动画的图片
    ///   - isDow: 是否往下的动画 否则则为往上动画
    func sp_addImgAnimation(img : UIImage?,point : CGPoint,isDow : Bool = true){
        
        guard let image = img else {
            return
        }
        let duration = 1.0
        let animationGroup = CAAnimationGroup()
        animationGroup.delegate = self
        animationGroup.duration = duration
        let roationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        roationAnimation.fromValue = NSNumber(value: 0)
        roationAnimation.toValue = NSNumber(value: Double.pi*2)
  
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 0.8
        let layerW : CGFloat = 50.00
        let startPoint = point
        let path = UIBezierPath()
        // 随机数
        let randomX = arc4random() % (UInt32(sp_screenWidth()) + 1)
        let randomY = arc4random() % UInt32(self.selectView.frame.origin.y - 100) + UInt32(layerW)
        if isDow {
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: CGFloat(randomX), y: CGFloat(randomY)))
            path.addLine(to: CGPoint(x: sp_screenWidth() / 2.0, y: self.selectView.frame.origin.y + layerW))
        }else{
            path.move(to: CGPoint(x: sp_screenWidth() / 2.0, y: self.selectView.frame.origin.y + layerW))
            path.addLine(to: CGPoint(x: CGFloat(randomX), y:CGFloat(randomY)))
            path.addLine(to: startPoint)
        }
        let position = CAKeyframeAnimation(keyPath: "position")
        position.path = path.cgPath
        
        animationGroup.animations = [roationAnimation,position,scaleAnimation]
        
        let imgLayer = CALayer()
        if isDow {
             imgLayer.frame = CGRect(x:  sp_screenWidth() / 2.0, y: -layerW, width: layerW, height: layerW)
        }else{
             imgLayer.frame = CGRect(x:  sp_screenWidth() / 2.0, y: sp_screenHeight()  + layerW, width: layerW, height: layerW)
        }
       
        imgLayer.contents = image.cgImage
        imgLayer.cornerRadius = layerW / 2.0
        imgLayer.masksToBounds = true
        self.view.layer.addSublayer(imgLayer)
        imgLayer.add(animationGroup, forKey: "")
        sp_asyncAfter(time: duration) {
            imgLayer.isHidden = true
            imgLayer.removeAllAnimations()
            imgLayer.removeFromSuperlayer()
        }
    }
    /// 点击下一步
    @objc func sp_clickNext(){
        if sp_count(array:  self.selectView.dataArray) > 0 {
            if self.isLong {
                let vc = SPLongGraphVC()
                vc.dataArray = self.selectView.dataArray
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = SPPhotoSplicingVC()
                vc.dataArray = self.selectView.dataArray
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }else{
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "NO_CHOICE_TIPS"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "OK"), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
