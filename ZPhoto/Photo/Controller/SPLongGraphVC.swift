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
    fileprivate let imageViewTag : Int = 1000
   
    fileprivate var marginSpace : CGFloat = 2
    fileprivate var padding : CGFloat = 2
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
        self.view.addSubview(self.scrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "SAVE"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(sp_clickSave))
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.layoutView)
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.frameView)
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
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.toolView).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
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
    fileprivate func sp_deal(toolType : SPSplicingToolType){
        
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
        default:
             sp_log(message: "")
        }
        
    }
    fileprivate func sp_dealLayout(){
        self.layoutView.isHidden = !self.layoutView.isHidden
    }
    fileprivate func sp_dealBg(){
        self.bgView.isHidden = !self.bgView.isHidden
    }
    fileprivate func sp_dealFrame(){
        self.frameView.isHidden = !self.frameView.isHidden
    }
    fileprivate func sp_deal(color : UIColor? , image : UIImage?){
        if let i = image {
            self.scrollView.layer.contents = i.cgImage
        }else{
            self.scrollView.backgroundColor = color
        }
    }
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
    }
    
}
