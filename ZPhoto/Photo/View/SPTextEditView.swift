//
//  SPTextEditView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/2.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPTextEditView:  UIView{
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.isHidden = true
        btn.setImage(UIImage(named: "delete"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_close), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.isHidden = true
        btn.setImage(UIImage(named: "public_edit"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickEdit), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var textView : UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.textColor = self.textColor
        view.font = self.font
        view.backgroundColor = UIColor.clear
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsets.zero
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.bounces = false
        view.isScrollEnabled = false
        return view
    }()
    var clickBlock : SPBtnTypeComplete?
    fileprivate var textHeight : Constraint!
    fileprivate var textWidth : Constraint!
    fileprivate var font : UIFont = sp_fontSize(fontSize: 30)
    fileprivate var textColor : UIColor = UIColor.white
    fileprivate var lastPoint : CGPoint = CGPoint.zero
    override init(frame: CGRect) {
        super.init(frame: frame)
       sp_isBoard(isShow: true)
        self.sp_setupUI()
        sp_addGest()
        sp_addNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sp_log(message: "点击")
        if !self.textView.isEditable {
            sp_clickTap()
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
//        sp_addLineView()
         self.addSubview(self.textView)
        self.addSubview(self.closeBtn)
        self.addSubview(self.editBtn)
       
        self.textView.delegate = self
        self.sp_addConstraint()

    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(-5)
            maker.top.equalTo(self).offset(-5)
            maker.width.height.equalTo(25)
        }
        self.editBtn.snp.makeConstraints { (maker) in
            maker.top.width.height.equalTo(self.closeBtn).offset(0)
            maker.right.equalTo(self).offset(5)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(15)
            self.textHeight = maker.height.equalTo(30).constraint
            self.textWidth = maker.width.equalTo(30).constraint
            maker.right.equalTo(self).offset(-15)
            maker.bottom.equalTo(self).offset(-10)
        }
    }
    deinit {
        self.textView.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPTextEditView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let size = self.superview?.frame.size {
            let s = NSString(string: textView.text)
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.minimumLineHeight = 30
            paraStyle.lineSpacing = 0
            paraStyle.lineBreakMode = .byWordWrapping
            paraStyle.paragraphSpacing = 0
            paraStyle.paragraphSpacingBefore = 0
            let att : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : self.font,NSAttributedString.Key.paragraphStyle : paraStyle,NSAttributedString.Key.foregroundColor : self.textColor,NSAttributedString.Key.kern : 0.5]
            let newFrame = s.boundingRect(with: CGSize(width: size.width - 20 - 25 - self.sp_x(), height: size.height - 10), options: .usesLineFragmentOrigin, attributes: att, context: nil)
        
            self.textWidth.update(offset: newFrame.size.width < 30 ? 30 : newFrame.size.width)
            self.textHeight.update(offset: newFrame.size.height < 30 ? 30 : newFrame.size.height + 10)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.isEditable {
            return true
        }else{
            sp_clickTap()
            return false
        }
    }
 
}
extension SPTextEditView {
    @objc fileprivate func sp_close(){
        sp_dealComplete(type: .close)
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_clickEdit(){
        sp_dealComplete(type: .edit)
        sp_edit()
    }
    fileprivate func sp_dealComplete(type : SPButtonClickType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
    @objc func sp_edit(){
        self.textView.isEditable = true
        self.textView.becomeFirstResponder()
         self.textView.isUserInteractionEnabled = true
    }
    /// 更新字体大小和颜色
    ///
    /// - Parameters:
    ///   - font: 字体颜色
    ///   - textColor: 字体大小
    func sp_update(font : UIFont?, textColor : UIColor?){
        if let f = font {
            self.font = f
        }
        if let c = textColor {
            self.textColor = c
        }
        textViewDidChange(self.textView)
    }
    /// 添加手势
    fileprivate func sp_addGest(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
//        self.addGestureRecognizer(tap)
//        self.isUserInteractionEnabled = true
        self.textView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(sp_click(pagGest:)))
        self.addGestureRecognizer(pan)
    }
    @objc fileprivate func sp_clickTap(){
        sp_log(message: "点击手势")
        self.closeBtn.isHidden = !self.closeBtn.isHidden
        self.editBtn.isHidden = !self.editBtn.isHidden
        if self.closeBtn.isHidden == false {
            sp_isBoard(isShow: true)
        }else{
            sp_isBoard(isShow: false)
        }
    }
    @objc fileprivate func sp_click(pagGest : UIPanGestureRecognizer){
        if self.textView.isEditable {
            return
        }
        guard let sView = self.superview else {
            return
        }
        
        let point = pagGest.location(in: pagGest.view?.superview)
        if pagGest.state == .began {
            lastPoint = point
        }
        let x = point.x - lastPoint.x
        let y = point.y - lastPoint.y
        var contentSize = sView.frame.size
        if let scrollView = sView as? UIScrollView {
            contentSize = scrollView.contentSize
        }
        if contentSize.width <= 0 {
            contentSize.width = sView.sp_width()
        }
        if contentSize.height <= 0 {
            contentSize.height = sView.sp_height()
        }
        let w = self.sp_width()
        let h = self.sp_height()
        var newFrame = self.frame
        newFrame.origin.x = newFrame.origin.x + x
        newFrame.origin.y = newFrame.origin.y + y
        
        if newFrame.origin.x + w - 5 >= contentSize.width {
            newFrame.origin.x = contentSize.width - w + 5
        }
        if newFrame.origin.y + h - 10 >= contentSize.height {
            newFrame.origin.y = contentSize.height - h + 10
        }
        if newFrame.origin.x <= 0  {
            newFrame.origin.x = 0
        }
        if  newFrame.origin.y <= 0 {
            newFrame.origin.y = 0
        }

        self.snp.remakeConstraints { (maker) in
            maker.left.equalTo(sView).offset(newFrame.origin.x)
            maker.top.equalTo(sView).offset(newFrame.origin.y)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        lastPoint = point
        
    }

    func sp_isBoard(isShow : Bool){
        if isShow {
             self.sp_border(color: sp_getMianColor(), width: sp_scale(value: 1))
        }else{
            self.sp_border(color: UIColor.clear, width: 0)
        }
    }
    func sp_noEdit(){
        self.textView.isEditable = false
        self.textView.resignFirstResponder()
        self.textView.isUserInteractionEnabled = false
    }
}
extension SPTextEditView {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc fileprivate func sp_keyboardHidden(){
        self.sp_noEdit()
    }
    
}
