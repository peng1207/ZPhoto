//
//  SPLongGraphVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/8/14.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 长图
class SPLongGraphVC: SPBaseVC {
    var dataArray : [SPPhotoModel]?
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var toolView : SPPhotoToolView = {
        let view = SPPhotoToolView()
        view.backgroundColor = sp_getMianColor()
        view.dataArray = [SPToolModel.sp_init(type: .layout),SPToolModel.sp_init(type: .background),SPToolModel.sp_init(type: .frame),SPToolModel.sp_init(type: .text),SPToolModel.sp_init(type: .filter)]
        view.selectBlock = { [weak self](type) in
            self?.sp_deal(toolType: type)
        }
        return view
    }()
    fileprivate lazy var layoutView : SPLongGraphLayoutView = {
        let view = SPLongGraphLayoutView()
        view.backgroundColor = sp_getMianColor()
        view.clickBlock = { [weak self] in
            self?.sp_setupData()
        }
        view.isHidden = true
        return view
    }()
    fileprivate lazy var bgView : SPBackgroundView = {
        let view = SPBackgroundView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.selectBlock = { [weak self] (color , image)in
            self?.sp_deal(color: color, image: image)
        }
        return view
    }()
    fileprivate lazy var frameView : SPPhotoFrameView = {
        let view = SPPhotoFrameView()
        view.backgroundColor = sp_getMianColor()
        view.isHidden = true
        view.sp_setMax(abroad: (sp_screenWidth() - 100 ) / 2.0, inside: sp_screenWidth())
        view.block = { [weak self] (margin,padding) in
            self?.marginSpace = margin
            self?.padding = padding
            self?.sp_setupData()
        }
        return view
    }()
    fileprivate lazy var filterView : SPFilterView = {
        let view =  SPFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.collectSelectComplete = { [weak self](model : SPFilterModel)  in
            self?.sp_deal(filterModel: model)
        }
        view.sp_cornerRadius(radius: filterViewWidth / 2.0)
        return view
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
    fileprivate lazy var rightItemView : SPNavItemBtnView = {
        let view = SPNavItemBtnView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        view.clickBlock = { [weak self] (type) in
            self?.sp_deal(btnType: type)
        }
        return view
    }()
    fileprivate lazy var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
    fileprivate let imageViewTag : Int = 1000
    fileprivate let filterViewWidth :  CGFloat = 60
    fileprivate var marginSpace : CGFloat = 2
    fileprivate var padding : CGFloat = 2
    fileprivate var tmpEditTextView : SPTextEditView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 赋值
    fileprivate func sp_setupData(){
        let direction : SPDirection = self.layoutView.direction
        if sp_count(array: self.dataArray) > 0 {
            var tmpView : UIView?
            var index = 0
            for model in self.dataArray! {
                
                var imgView : UIImageView
                
                if let view = self.scrollView.viewWithTag(imageViewTag + index) as? UIImageView {
                    imgView = view
                }else{
                    imgView = UIImageView()
                    imgView.image = model.img
                    self.scrollView.addSubview(imgView)
                }
               
                imgView.tag = imageViewTag + index
               
                var size : CGSize = CGSize.zero
                if let s = model.img?.size {
                    size = s
                }
                imgView.snp.remakeConstraints { (maker) in
                    if direction == .vertical {
                        maker.width.equalTo(self.scrollView.snp.width).offset(-marginSpace * 2.0 )
                        maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
                        maker.left.equalTo(self.scrollView).offset(marginSpace)
                        if index == sp_count(array: self.dataArray) - 1 {
                            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-marginSpace)
                        }
                        if let v = tmpView{
                            maker.top.equalTo(v.snp.bottom).offset(padding)
                        }else{
                            maker.top.equalTo(self.scrollView.snp.top).offset(marginSpace)
                        }
                        maker.height.equalTo(imgView.snp.width).multipliedBy(size.height / size.width)
                    }else{
                        maker.height.equalTo(self.scrollView.snp.height).offset(-marginSpace * 2.0 )
                        maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
                        maker.top.equalTo(self.scrollView).offset(marginSpace)
                        if let v = tmpView {
                            maker.left.equalTo(v.snp.right).offset(padding)
                        }else{
                            maker.left.equalTo(self.scrollView.snp.left).offset(marginSpace)
                        }
                        maker.width.equalTo(imgView.snp.height).multipliedBy(size.width / size.height)
                        if index == sp_count(array: self.dataArray) - 1 {
                            maker.right.equalTo(self.scrollView.snp.right).offset(-marginSpace)
                        }
                    }
                }
                tmpView = imgView
                index = index + 1
            }
        }
    }
    
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "LONG_GRAPH")
        self.view.addSubview(self.scrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightItemView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.frameView)
        self.view.addSubview(self.filterView)
        self.view.addSubview(self.textView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
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
            maker.height.equalTo(40)
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
        self.filterView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view).offset(0)
            maker.height.equalTo(self.view.snp.height).multipliedBy(0.5)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
            maker.width.equalTo(filterViewWidth)
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.toolView).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
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
    deinit {
        
    }
}
extension SPLongGraphVC{
    
    @objc fileprivate func sp_clickSave(){
        if let image = UIImage.sp_image(view: self.scrollView) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    fileprivate func sp_clickShare(){
        if let image = UIImage.sp_image(view: self.scrollView) {
              SPShare.sp_share(imgs: [image], vc: self)
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
    /// 处理不同类型的事件
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
        case .frame:
            sp_allHidden(otherView: self.frameView)
            sp_dealFrame()
        case .filter:
            sp_allHidden(otherView: self.filterView)
            sp_dealFilter()
        case .text:
            sp_allHidden(otherView: self.textView)
            sp_dealText()
        default:
             sp_log(message: "")
        }
    }
    /// 处理布局
    fileprivate func sp_dealLayout(){
        self.layoutView.isHidden = !self.layoutView.isHidden
    }
    /// 处理背景颜色和背景图片
    fileprivate func sp_dealBg(){
        self.bgView.isHidden = !self.bgView.isHidden
    }
    /// 处理边框
    fileprivate func sp_dealFrame(){
        self.frameView.isHidden = !self.frameView.isHidden
    }
    /// 处理滤镜
    fileprivate func sp_dealFilter(){
        self.filterView.isHidden = !self.filterView.isHidden
        if (self.filterView.isHidden == false && sp_count(array: self.filterView.filterList) == 0){
            sp_sync {
                self.videoData.setup(inputImage: CIImage(image: sp_appLogoImg()!), complete: { [weak self] () in
                    sp_mainQueue {
                        self?.filterView.filterList = self?.videoData.getFilterList()
                    }
                })
            }
        }
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
        self.scrollView.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.equalTo(100)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.scrollView).offset(100)
        }
        self.tmpEditTextView = view
        view.sp_edit()
    }
    /// 处理scrollview的背景颜色或背景图片
    ///
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - image: 图片
    fileprivate func sp_deal(color : UIColor? , image : UIImage?){
        if let i = image {
            self.scrollView.layer.contents = i.cgImage
        }else{
            self.scrollView.layer.contents = nil
            self.scrollView.backgroundColor = color
        }
    }
    /// 处理选择滤镜后的回调
    ///
    /// - Parameter filterModel: 滤镜
    fileprivate func sp_deal(filterModel : SPFilterModel?){
        guard let model = filterModel else {
            return
        }
        sp_deal(img: model, isAll: true, index: 0)
    }
    /// 处理图片的滤镜
    ///
    /// - Parameters:
    ///   - filterModel: 滤镜
    ///   - isAll: 是否全部的图片
    ///   - index: 不是全部图片是哪个图片
    fileprivate func sp_deal(img filterModel : SPFilterModel,isAll : Bool, index : NSInteger){
        self.scrollView.subviews.forEach { (view) in
            if let imageView = view as? UIImageView {
                let tag = imageView.tag
                let index = tag - imageViewTag
                if index >= 0 , index < sp_count(array: self.dataArray){
                    let model = self.dataArray?[tag - imageViewTag]
                    if let image = model?.img {
                        var ciImg : CIImage?
                        if let filter = filterModel.filter {
                            if isAll {
                                filter.setDefaults()
                                filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
                                ciImg = filter.outputImage
                            }else if tag == index {
                                filter.setDefaults()
                                filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
                                ciImg = filter.outputImage
                            }
                            if let ci = ciImg {
                                imageView.image =  UIImage(ciImage: ci)
                            }
                        }else{
                            imageView.image = image
                        }
                        
                       
                    }
                }
            }
        }
    }
    
    /// 处理工具view是否隐藏
    ///
    /// - Parameter otherView: 当前展示哪个view
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
        if self.filterView != otherView {
            self.filterView.isHidden = true
        }
        if self.textView != otherView {
            self.textView.isHidden = true
        }
        
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
        case .edit:
            sp_dealText()
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
}
