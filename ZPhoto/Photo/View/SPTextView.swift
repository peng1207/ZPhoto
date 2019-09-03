//
//  SPTextView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPTextView:  UIView{
    lazy var toolView : SPTextToolView = {
        let view = SPTextToolView()
        view.backgroundColor = UIColor.black
        view.toolView.selectType = .edit
        view.toolView.selectBlock = { [weak self] (type ) in
            self?.sp_deal(toolType: type)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var keyboardView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var colorView : SPColorView = {
        let view = SPColorView()
        return view
    }()
    fileprivate lazy var fontNameView : SPFontNameView = {
        let view = SPFontNameView()
        return view
    }()
    fileprivate lazy var fontSizeView : SPSliderView = {
        let view = SPSliderView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate var scrollViewHeight : Constraint!
    var showKeyboardBlock : SPBtnComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_addNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.toolView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.keyboardView)
        self.scrollView.addSubview(self.colorView)
        self.scrollView.addSubview(self.fontNameView)
        self.scrollView.addSubview(self.fontSizeView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(70)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.toolView.snp.bottom).offset(0)
            self.scrollViewHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.keyboardView.snp.makeConstraints { (maker) in
            maker.width.height.top.equalTo(self.scrollView).offset(0)
            maker.left.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView).offset(0)
        }
        self.colorView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
//            maker.centerY.equalTo(self.scrollView).offset(0)
            maker.left.equalTo(self.keyboardView.snp.right).offset(0)
        }
        self.fontNameView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.colorView.snp.right).offset(0)
            maker.top.width.height.equalTo(self.colorView).offset(0)
        }
        self.fontSizeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.fontNameView.snp.right).offset(0)
            maker.top.width.height.equalTo(self.fontNameView).offset(0)
        }
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - notification
extension SPTextView {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardShow(obj:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc fileprivate func sp_keyboardShow(obj : Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        sp_update(scrollview: height)
        sp_updateSuperView(isBottom: true)
    }
}
//MARK: - action
extension SPTextView {
    fileprivate func sp_KeyBoradhide(){
        self.scrollViewHeight.update(offset: 0)
        sp_updateSuperView()
    }
    fileprivate func sp_update(scrollview height : CGFloat){
        self.scrollViewHeight.update(offset: height)
    }
    fileprivate func sp_update(scrollView offset : Int){
        sp_asyncAfter(time: 0.1) {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.sp_width() * CGFloat(offset), y: 0), animated: false)
            sp_log(message: self.scrollView.contentOffset)
        }
    }
    fileprivate func sp_updateDefault(){
        sp_hideKeyboard()
        sp_update(scrollview: 200)
        sp_updateSuperView(isBottom: false)
    }
    fileprivate func sp_showKeyboard(){
        guard let block = self.showKeyboardBlock else {
            return
        }
        block()
    }
    fileprivate func sp_updateSuperView(isBottom : Bool = false){
        if let view = self.superview {
            self.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(view).offset(0)
                if isBottom{
                    maker.bottom.equalTo(view).offset(0)
                }else{
                    if #available(iOS 11.0, *) {
                        maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
                    } else {
                        maker.bottom.equalTo(view.snp.bottom).offset(0)
                    }
                }
                
                maker.height.greaterThanOrEqualTo(0)
            }
        }
    }
    fileprivate func sp_deal(toolType : SPSplicingToolType){
        guard self.toolView.toolView.selectType != nil else {
            sp_update(scrollview: 0)
            sp_updateSuperView(isBottom: false)
            sp_hideKeyboard()
            return
        }
        switch toolType {
        case .edit:
            sp_showKeyboard()
            sp_update(scrollView: 0)
            sp_updateSuperView(isBottom: true)
        case .textColor:
            sp_update(scrollView: 1)
            sp_updateDefault()
        case .fontName:
            sp_update(scrollView: 2)
            sp_updateDefault()
        case .fontSize:
            sp_update(scrollView: 3)
            sp_updateDefault()
        default:
            sp_log(message: "")
        }
    }
}
