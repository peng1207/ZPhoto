//
//  SPPhotoFrameView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
typealias SPFrameComplete = (_ margin : CGFloat , _  padding : CGFloat)->Void
class SPPhotoFrameView:  UIView{
    fileprivate lazy var abroadImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "frame_abroad")
        return view
    }()
    fileprivate lazy var abroadSilder : UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIColor.white
        view.maximumValue = 6
        view.value = 4
        view.addTarget(self, action: #selector(sp_abroad), for: UIControl.Event.valueChanged)
        return view
    }()
    fileprivate lazy var insideImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "frame_inside")
        return view
    }()
    fileprivate lazy var insideSilder : UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIColor.white
        view.maximumValue = 6
        view.value = 4
        view.addTarget(self, action: #selector(sp_inside), for: UIControl.Event.valueChanged)
        return view
    }()
    var block : SPFrameComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_setMax(abroad : CGFloat ,inside : CGFloat ){
        self.abroadSilder.maximumValue = Float(abroad)
        self.insideSilder.maximumValue = Float(inside)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.abroadImgView)
        self.addSubview(self.abroadSilder)
        self.addSubview(self.insideImgView)
        self.addSubview(self.insideSilder)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.abroadImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(5)
            maker.width.height.equalTo(30)
        }
        self.insideImgView.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.abroadImgView).offset(0)
            maker.top.equalTo(self.abroadImgView.snp.bottom).offset(10)
            maker.bottom.equalTo(self).offset(-5)
        }
        self.abroadSilder.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.abroadImgView.snp.right).offset(10)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.centerY.equalTo(self.abroadImgView.snp.centerY).offset(0)
        }
        self.insideSilder.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.abroadSilder).offset(0)
            maker.centerY.equalTo(self.insideImgView.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPhotoFrameView {
    
    @objc fileprivate func sp_abroad(){
        sp_dealComplete()
    }
    @objc fileprivate func sp_inside(){
        sp_dealComplete()
    }
    
    fileprivate func sp_dealComplete(){
        guard let complete = self.block else {
            return
        }
        complete(CGFloat(self.abroadSilder.value),CGFloat(self.insideSilder.value))
    }
    
}
