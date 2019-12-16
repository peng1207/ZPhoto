//
//  SPClipToolView.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/8/5.
//

import Foundation
import UIKit
import SnapKit
/// 按钮类型
enum SPClipType {
    /// 取消
    case cance
    /// 完成
    case done
    /// 旋转
    case rotate
    ///  放大
    case zoom
}
/// 点击按钮类型回调
typealias SPClipTypeComplete = (_ type : SPClipType)->Void
/// 裁剪图片 工具view
class SPClipToolView:  UIView{
    fileprivate lazy var canceBtn : UIButton = {
       
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("cance", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font =  sp_fontSize(fontSize: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("done", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
         btn.titleLabel?.font =  sp_fontSize(fontSize: 16)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var rotateBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
      
        btn.setImage(  Bundle.sp_getImg(name: "public_rotate@2x"), for: UIControl.State.normal)
//        if let bundle = Bundle(identifier: "org.cocoapods.SPCommonLibrary"){
//             btn.setImage(UIImage(named: "public_rotate", in: bundle, compatibleWith: nil), for: UIControl.State.normal)
//        }else{
//            btn.setImage(UIImage(named: "public_rotate"), for: UIControl.State.normal)
//        }
        btn.addTarget(self, action: #selector(sp_clickRotate), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var zoomBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(Bundle.sp_getImg(name: "public_zoom@2x"), for: UIControl.State.normal)
//        if let bundle = Bundle(identifier: "org.cocoapods.SPCommonLibrary"){
//            btn.setImage(UIImage(named: "public_zoom", in: bundle, compatibleWith: nil), for: UIControl.State.normal)
//        }else{
//              btn.setImage(UIImage(named: "public_zoom"), for: UIControl.State.normal)
//        }
      
        btn.addTarget(self, action: #selector(sp_clickZoom), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var clickBlock : SPClipTypeComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.canceBtn)
        self.addSubview(self.doneBtn)
        self.addSubview(self.rotateBtn)
        self.addSubview(self.zoomBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(40)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(40)
        }
        self.rotateBtn.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.rotateBtn.snp.height).offset(0)
            maker.centerX.equalTo(self.snp.centerX).offset(-40)
        }
        self.zoomBtn.snp.makeConstraints { (maker) in
            maker.width.height.top.equalTo(self.rotateBtn).offset(0)
            maker.centerX.equalTo(self.snp.centerX).offset(40)
        }
    }
    deinit {
        
    }
}
extension SPClipToolView {
    @objc fileprivate func sp_clickCance(){
        sp_dealClick(type: .cance)
    }
    @objc fileprivate func sp_clickDone(){
        sp_dealClick(type: .done)
    }
    /// 点击旋转
    @objc fileprivate func sp_clickRotate(){
        sp_dealClick(type: .rotate)
    }
    /// 点击
    @objc fileprivate func sp_clickZoom(){
        sp_dealClick(type: .zoom)
    }
    fileprivate func sp_dealClick (type : SPClipType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
}
