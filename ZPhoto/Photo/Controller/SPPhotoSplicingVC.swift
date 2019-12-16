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
/// 拼接
class SPPhotoSplicingVC: SPBaseVC {
    var dataArray : [SPPhotoModel]!
    fileprivate var typeList : [SPPhotoSPlicingType]!
    fileprivate var colorList : [UIColor] = SPPhotoSplicingHelp.sp_getDefaultColor()
    fileprivate var selectType : SPPhotoSPlicingType?
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "SAVE"), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn.titleLabel?.font = sp_fontSize(fontSize:  15)
        btn.addTarget(self, action: #selector(sp_clickSave), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var textView : SPTextView = {
        let view = SPTextView()
        view.showKeyboardBlock = { [weak self] in
            self?.sp_showKeyboard()
        }
        view.toolView.btnBlock = { [weak self] (type ) in
            self?.sp_deal(btnType: type)
        }
        //        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var conetentView : UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    
    fileprivate lazy var toolView : SPPhotoToolView = {
        let view = SPPhotoToolView()
        view.canShowSelect = false
        view.backgroundColor = sp_getMianColor()
        view.dataArray = [
            SPToolModel.sp_init(type: .layout)
            ,SPToolModel.sp_init(type: .background)
            ,SPToolModel.sp_init(type: .frame)
            ,SPToolModel.sp_init(type: .zoom)
            ,SPToolModel.sp_init(type: .text)
            ,SPToolModel.sp_init(type: .edit)
//            ,SPToolModel.sp_init(type: .filter)
        ]
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
    fileprivate lazy var bgView : SPBackgroundView = {
        let view = SPBackgroundView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.selectBlock = { [weak self](color,image) in
            self?.sp_deal(color: color,image: image)
        }
        return view
    }()
    fileprivate lazy var frameView : SPPhotoFrameView = {
        let view = SPPhotoFrameView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.sp_setMax(abroad: 10, inside: 10)
        view.block = { [weak self] (margin,padding) in
            self?.marginSpace = margin
            self?.paddingSpace = padding
            self?.sp_setupData()
        }
        return view
    }()
    fileprivate lazy var rightItemView : SPNavItemBtnView = {
        let view = SPNavItemBtnView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        return view
    }()
    fileprivate var marginSpace : CGFloat = 4
    fileprivate var paddingSpace : CGFloat = 4
    fileprivate let viewTag = 1000
    fileprivate var ratio : CGFloat = 1
     fileprivate var tmpEditTextView : SPTextEditView?
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
 
        self.view.addSubview(self.conetentView)
        self.view.addSubview(self.safeView)
        self.safeView.backgroundColor = self.toolView.backgroundColor
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.frameView)
         self.view.addSubview(self.textView)
        self.sp_addConstraint()
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "SPLICING")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightItemView)
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
        guard sp_count(array: self.dataArray) > 0 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        
        var index = 0
        for model in self.dataArray {
            let value = SPPhotoSplicingHelp.sp_frameAndSpace(tyep: type, value: SPPhotoSplicingStruct(index: index, count: self.dataArray.count, width: sp_screenWidth(), height: sp_screenWidth() * self.ratio, margin: marginSpace, padding: paddingSpace))
            let frame = value.frame
            let space : SPSpace = value.space
            var view : SPCustomPictureView? = self.conetentView.viewWithTag(viewTag + index) as? SPCustomPictureView
            if view == nil {
                view = SPCustomPictureView(frame:frame)
                view?.canTap = true
                self.conetentView.addSubview(view!)
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
        sp_contentLayout()
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(70)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            }else{
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.toolView).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
        }
        self.layoutView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.bgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.frameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    fileprivate func sp_contentLayout(){
        self.conetentView.snp.remakeConstraints { (maker) in
            maker.top.greaterThanOrEqualTo(self.view).offset(0)
            maker.left.right.equalTo(self.view).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(-30)
            maker.height.equalTo(self.conetentView.snp.width).multipliedBy(self.ratio)
        }
    }
    deinit {
        
    }
}
extension SPPhotoSplicingVC {
    
    /// 处理选择的布局类型
    ///
    /// - Parameter type: 类型
    fileprivate func sp_deal(type : SPPhotoSPlicingType){
        self.selectType = type
        sp_setupData()
    }
    /// 处理view的背景颜色或背景图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - image: 图片
    fileprivate func sp_deal(color : UIColor?,image : UIImage? ){
        if let c = color {
            self.conetentView.backgroundColor = c
            self.conetentView.layer.contents = nil
        }
        if let img = image?.sp_resizeImg(size: CGSize(width: sp_screenWidth(), height: sp_screenWidth())) {
            self.conetentView.layer.contents = img.cgImage
            self.conetentView.backgroundColor = nil
        }
    }
    /// 处理点击的工具类型
    ///
    /// - Parameter toolType: 类型
    fileprivate func sp_deal(toolType : SPToolType){
        switch toolType {
        case .layout:
            sp_allHidden(otherView: self.layoutView)
            sp_dealLayout()
        case .background:
            sp_allHidden(otherView: self.bgView)
            sp_dealBg()
        case .frame :
            sp_allHidden(otherView: self.frameView)
            sp_dealFrame()
        case .zoom:
            sp_allHidden(otherView: nil)
            sp_dealZoom()
        case .text:
            sp_allHidden(otherView: self.textView)
            sp_dealText()
        case .edit:
            sp_allHidden(otherView: nil)
            sp_dealEdit()
        default:
            sp_log(message: "没有")
        }
    }
    /// 处理边框
    fileprivate func sp_dealFrame(){
        self.frameView.isHidden = !self.frameView.isHidden
    }
    /// 处理布局
    fileprivate func sp_dealLayout(){
        self.layoutView.isHidden = !self.layoutView.isHidden
    }
    /// 处理背景
    fileprivate func sp_dealBg(){
        self.bgView.isHidden = !self.bgView.isHidden
    }
    /// 处理比例
    fileprivate func sp_dealZoom(){
        let actionSheetVC = UIAlertController(title: SPLanguageChange.sp_getString(key: "ZOOM"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheetVC.addAction(UIAlertAction(title: "1:1", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 1.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "2:1", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 0.5)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "16:9", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 9.0 / 16.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "4:5", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 5.0 / 4.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "4:3", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 3.0 / 4.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "7:5", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 5.0 / 7.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: "3:2", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_update(ratio: 2.0 / 3.0)
        }))
        actionSheetVC.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(actionSheetVC, animated: true, completion: nil)
    }
    /// 处理文本
    fileprivate func sp_dealText(){
        self.textView.isHidden = !self.textView.isHidden
        self.textView.toolView.toolView.selectType = .edit
        sp_addEditTextView()
    }
    /// 增加文字编辑
    fileprivate func sp_addEditTextView(){
        let view = SPTextEditView()
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        self.conetentView.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.conetentView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.conetentView).offset(100)
        }
        self.tmpEditTextView = view
        view.sp_edit()
    }
    /// 处理编辑
    fileprivate func sp_dealEdit(){
        let dragVC = SPDragVC()
        dragVC.dataArray = self.dataArray
        dragVC.complete = { [weak self] (array) in
            if let list : [SPPhotoModel] = array as? [SPPhotoModel] {
                if sp_count(array: list) != sp_count(array: self?.dataArray){
                    self?.sp_getData()
                }
                self?.dataArray = list
                self?.sp_setupData()
            }
        }
        self.navigationController?.pushViewController(dragVC, animated: true)
    }
    /// 弹出键盘可以编辑
    fileprivate func sp_showKeyboard(){
        guard let view = self.tmpEditTextView else {
            return
        }
        view.sp_edit()
    }
    /// 处理按钮点击事件
    ///
    /// - Parameter btnType: 按钮类型
    fileprivate func sp_deal(btnType : SPButtonClickType){
        switch btnType {
        case .close:
            self.tmpEditTextView?.removeFromSuperview()
            self.sp_dealEditText()
        case .select:
            self.tmpEditTextView?.sp_isBoard(isShow: false)
            self.sp_dealEditText()
        case .save:
            sp_clickSave()
        case .share:
            sp_clickShare()
        default:
            sp_log(message: "")
        }
    }
    /// 处理编辑文本框 隐藏键盘和临时view设置为nil
    fileprivate func sp_dealEditText(){
        self.tmpEditTextView?.sp_noEdit()
        self.tmpEditTextView = nil
        self.textView.isHidden = true
    }
    /// 更新view的宽高
    ///
    /// - Parameter ratio: 比例
    fileprivate func sp_update(ratio : CGFloat){
        self.ratio = ratio
        self.sp_setupData()
        self.sp_contentLayout()
    }
    /// 设置view 是否隐藏 （除了要展示的view）
    ///
    /// - Parameter otherView: 当前的需要展示的view
    fileprivate func sp_allHidden(otherView : UIView?){
        if self.layoutView != otherView{
            self.layoutView.isHidden = true
        }
        if self.bgView != otherView {
            self.bgView.isHidden = true
        }
        if self.frameView != otherView {
            self.frameView.isHidden = true
        }
        if self.textView != otherView {
            self.textView.isHidden = true
        }
    }
    /// 分享
    fileprivate func sp_clickShare(){
        if let img = UIImage.sp_image(view: self.conetentView) {
            SPShare.sp_share(imgs: [img], vc: self)
        }
    }
    /// 点击保存
    @objc fileprivate func sp_clickSave(){
       
        let img = UIImage.sp_image(view: self.conetentView)
        if  let i = img {
            UIImageWriteToSavedPhotosAlbum(i, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    /// 图片保存到相册回调
    /// - Parameter image: 图片
    /// - Parameter error: 错误码
    /// - Parameter contextInfo: 描述
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
