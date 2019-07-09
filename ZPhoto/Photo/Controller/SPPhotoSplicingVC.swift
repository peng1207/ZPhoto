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
class SPPhotoSplicingVC: SPBaseVC {
    var dataArray : [SPPhotoModel]!
    fileprivate var typeList : [SPSPlicingType]!
    fileprivate var colorList : [UIColor] = SPPhotoSplicingHelp.sp_getDefaultColor()
    fileprivate var selectType : SPSPlicingType!
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "SAVE"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSave), for: UIControlEvents.touchUpInside)
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
        return view
    }()
    fileprivate var marginSpace : CGFloat = 4
    fileprivate var paddingSpace : CGFloat = 2
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
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: SPLanguageChange.sp_getString(key: "GIVEUP_EDIT_PICTURE_TIPS"), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "EDIT"), style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "GIVEUP"), style: UIAlertActionStyle.cancel, handler: { (action) in
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
    }
    fileprivate func sp_setupData(){
        self.bgView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var index = 0
        for model in self.dataArray {
            let frame = SPPhotoSplicingHelp.sp_getFrame(index: index, count: self.dataArray.count, type: self.selectType, width: sp_getScreenWidth(), height: sp_getScreenWidth())
            let view = SPCustomPictureView(frame:frame)
            let space : (left : CGFloat , right : CGFloat , top : CGFloat , bottom : CGFloat) = SPPhotoSplicingHelp.sp_borderSpacing(index: index, count: self.dataArray.count, type: self.selectType, margin: marginSpace, padding: paddingSpace)
            let left : CGFloat = space.left
            let top : CGFloat = space.top
            let right : CGFloat = space.right
            let bottom : CGFloat = space.bottom
            view.sp_update(left: left, top: top, right: right, bottom: bottom)
            view.sp_update(img: model.img)
            view.layoutType = SPPhotoSplicingHelp.sp_getLayoutType(index: index, count: self.dataArray.count, type: self.selectType)
            view.sp_drawMaskLayer()
            self.bgView.addSubview(view)
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
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
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
    }
    deinit {
        
    }
}
extension SPPhotoSplicingVC {
    
    @objc fileprivate func sp_clickSave(){
    
        let img = UIImage.sp_img(of: self.bgView)
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
            UIAlertController.init(title: nil,
                                   message: "保存成功！",
                                   preferredStyle: UIAlertControllerStyle.alert).show(self, sender: nil);
        }
    }
}
