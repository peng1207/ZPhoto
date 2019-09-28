//
//  SPClipImgVC.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/2.
//

import Foundation
import SnapKit
import UIKit
public typealias SPClipImgComplete = (_ image : UIImage?, _ isCance : Bool)->Void

public enum SPClipImgType {
    case square
    case other
}

public class SPClipImgVC: UIViewController {
    
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    fileprivate lazy var clipView : SPClipView = {
        let view = SPClipView()
        view.sp_border(color: UIColor.white, width: 1)
        view.imgFrameBlock = {
            return self.iconImgView.frame
        }
        return view
    }()
    fileprivate lazy var toolView : SPClipToolView = {
        let view = SPClipToolView()
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(type: type)
        }
        return view
    }()
    public var originalImg : UIImage?
    public var clipBlock : SPClipImgComplete?
    public var clipImgType : SPClipImgType = .square
    fileprivate var heightConstraint : Constraint!
    fileprivate var clipHeight : Constraint!
    fileprivate var clipWidth : Constraint!
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.image = originalImg
        if let img = originalImg {
            let w = img.size.width
            let h = img.size.height
            let viewH = sp_screenWidth() * h / w
            self.heightConstraint.update(offset: viewH)
            
            if w > h {
                self.clipWidth.update(offset: viewH)
                self.clipHeight.update(offset: viewH)
            }else{
                self.clipWidth.update(offset: sp_screenWidth())
                self.clipHeight.update(offset: sp_screenWidth())
            }
        }
    }
    /// 创建UI
    fileprivate func sp_setupUI() {
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.iconImgView)
        self.view.addSubview(self.clipView)
        self.view.addSubview(self.toolView)
        self.toolView.zoomBtn.isHidden = self.clipImgType == .square ? true : false
        self.sp_addConstraint()
    }
   
    /// 处理有没数据
    fileprivate func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(0)
            maker.top.greaterThanOrEqualTo(sp_statusBarHeight())
            maker.centerY.equalTo(self.view).offset(0)
            maker.right.equalTo(self.view).offset(0)
            self.heightConstraint = maker.height.equalTo(0).constraint
            maker.bottom.lessThanOrEqualTo(self.toolView.snp.top).offset(0)
        }
        self.clipView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.iconImgView.snp.centerX).offset(0)
            maker.centerY.equalTo(self.iconImgView.snp.centerY).offset(0)
            self.clipWidth = maker.width.equalTo(0).constraint
            self.clipHeight = maker.height.equalTo(0).constraint
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(40)
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
extension SPClipImgVC {
    
    fileprivate func sp_deal(type : SPClipType){
        switch type {
        case .cance:
            sp_clickCance()
        case .done:
            sp_clickDone()
        case .rotate:
            sp_clickRoate()
        case .zoom:
            sp_clickZoom()
        default:
            sp_log(message: "没有其他")
        }
    }
    
    fileprivate func sp_clickCance(){
        sp_dealComplete(img: nil, isCance: true)
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func sp_clickDone(){
        sp_log(message: self.clipView.frame)
        sp_log(message: self.iconImgView.frame)
        /// 获取到裁剪框在图片的位置
        var clipFrame = self.view.convert(self.clipView.frame, to: self.iconImgView)
        sp_log(message: clipFrame)
        if let img = self.originalImg {
            let scale = self.iconImgView.frame.size.width / img.size.width
            sp_log(message: scale )
            sp_log(message: self.iconImgView.frame.size.height / img.size.height)
            clipFrame.origin.x = clipFrame.origin.x / scale
            clipFrame.origin.y = clipFrame.origin.y / scale
            clipFrame.size.width = clipFrame.size.width / scale
            clipFrame.size.height = clipFrame.size.height / scale
            sp_log(message: "new ")
            sp_log(message: clipFrame)
            sp_dealComplete(img: img.sp_scaled(newFrame: clipFrame), isCance: false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    /// 处理回调
    ///
    /// - Parameters:x5
    ///   - img: 图片
    ///   - isCance: 是否点击取消
    fileprivate func sp_dealComplete(img : UIImage?,isCance :Bool){
        guard let block = self.clipBlock else {
            return
        }
        block(img,isCance)
    }
    fileprivate func sp_clickZoom(){
        let actionSheetVC = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
    }
    fileprivate func sp_clickRoate(){
        if let img = self.originalImg {
            self.originalImg = img.sp_roate()
            sp_setupData()
        }
    }
    
}
