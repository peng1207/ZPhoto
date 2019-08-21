//
//  SPPhotoSplicingVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
//
// 处理拼接图片

import Foundation
import SnapKit
import SPCommonLibrary
class SPPhotoSplicingVC: SPBaseVC {
    var dataArray : [SPPhotoModel]!
    fileprivate var typeList : [SPSPlicingType]!
    fileprivate var colorList : [UIColor] = SPPhotoSplicingHelp.sp_getDefaultColor()
    fileprivate var selectType : SPSPlicingType?
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "SAVE"), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickSave), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    fileprivate lazy var hiddenView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.1)
        return view
    }()
    fileprivate lazy var toolView : SPSplicingToolView = {
        let view = SPSplicingToolView()
        view.backgroundColor = sp_getMianColor()
        view.selectBlock = { [weak self](type) in
            self?.sp_deal(toolType: type)
        }
        return view
    }()
    fileprivate lazy var layoutView : SPLayoutView = {
        let view = SPLayoutView()
        view.backgroundColor = sp_getMianColor()
        view.selectBlock = { [weak self](type) in
            self?.sp_deal(type: type)
        }
        view.isHidden = true
        return view
    }()
    fileprivate lazy var colorView : SPBackgroundView = {
        let view = SPBackgroundView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.selectBlock = { [weak self](color) in
            self?.sp_deal(color: color)
        }
        return view
    }()
    fileprivate var marginSpace : CGFloat = 4
    fileprivate var paddingSpace : CGFloat = 4
    fileprivate let viewTag = 1000
    fileprivate var ratio : CGFloat = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_getData()
        sp_setupData()
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
    override func sp_clickBack() {
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "GIVEUP_EDIT_PICTURE_TIPS"), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "EDIT"), style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GIVEUP"), style: UIAlertAction.Style.cancel, handler: { (action) in
                super.sp_clickBack()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.backgroundColor = sp_getMianColor()
        self.view.addSubview(self.hiddenView)
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.colorView)
        self.sp_addConstraint()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.saveBtn)
    }
    fileprivate func sp_getData(){
        self.typeList =  SPPhotoSplicingHelp.sp_getSplicingLayout(count: self.dataArray.count)
        if self.typeList.count > 0  {
            if let type = self.typeList.first {
                   self.selectType = type
            }
        }
        self.layoutView.sp_update(typeList: self.typeList, count: sp_count(array: self.dataArray))
    }
    fileprivate func sp_setupData(){
        guard let type = self.selectType else {
            return
        }
        
        var index = 0
        for model in self.dataArray {
            let value = SPPhotoSplicingHelp.sp_frameAndSpace(tyep: type, value: SPPhotoSplicingStruct(index: index, count: self.dataArray.count, width: sp_screenWidth(), height: sp_screenWidth() / self.ratio, margin: marginSpace, padding: paddingSpace))
            let frame = value.frame
            let space : SPSpace = value.space
            var view : SPCustomPictureView? = self.bgView.viewWithTag(viewTag + index) as? SPCustomPictureView
            if view == nil {
                view = SPCustomPictureView(frame:frame)
                view?.canTap = true
                self.bgView.addSubview(view!)
            }else{
                view?.frame = frame
            }
            view?.tag = viewTag + index
            view?.sp_update(space: space)
            view?.sp_update(img: model.img)
            view?.layoutType = SPPhotoSplicingHelp.sp_getLayoutType(index: index, count: self.dataArray.count, type: type)
            view?.sp_drawMaskLayer()
            
            index = index + 1
        }
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hiddenView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.bgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(-20)
            maker.height.equalTo(self.bgView.snp.width).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(70)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            }else{
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.layoutView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.colorView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPhotoSplicingVC {
    
    fileprivate func sp_deal(type : SPSPlicingType){
        self.selectType = type
        sp_setupData()
    }
    fileprivate func sp_deal(color : UIColor){
        self.bgView.backgroundColor = color
    }
    fileprivate func sp_deal(toolType : SPSplicingToolType){
        switch toolType {
        case .layout:
            self.layoutView.isHidden = false
            self.colorView.isHidden = true
        case .background:
            self.colorView.isHidden = false
            self.layoutView.isHidden = true
        default:
            sp_log(message: "没有")
        }
    }
    
    @objc fileprivate func sp_clickSave(){
       
        let img = UIImage.sp_image(view: self.bgView)
        if  let i = img {
            UIImageWriteToSavedPhotosAlbum(i, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
   @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
    {
        if let e = error as NSError?
        {
            print(e)
        }
        else
        {
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "SAVE_SUCCESS"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "OK"), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
