//
//  SPPhotoEditVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
// 编辑图片

import Foundation
import SnapKit
import SPCommonLibrary
class SPPhotoEditVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.maximumZoomScale = 3
        view.minimumZoomScale = 1
        return view
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var filterView : SPFilterView = {
        let view =  SPFilterView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.collectSelectComplete = { [weak self](model : SPFilterModel)  in
            self?.sp_dealFilter(model: model)
        }
        view.sp_cornerRadius(radius: filterViewWidth / 2.0)
        return view
    }() //滤镜显示view
    fileprivate lazy var editView : SPPhotoEditToolView = {
        let view = SPPhotoEditToolView()
        view.clickBlock = { [weak self](type)in
            self?.sp_dealBtnClick(type: type)
        }
        return view
    }()
    lazy fileprivate var videoData : SPRecordVideoData! = {
        return SPRecordVideoData()
    }()
    fileprivate let filterViewWidth :  CGFloat = 60
    fileprivate var filterRightConstraint : Constraint!
    var photoModel : SPPhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData(image: self.photoModel?.img)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /// 赋值
    fileprivate func sp_setupData(image : UIImage?){
        self.iconImgView.image = image
        guard let img = image else {
            return
        }
        let size = img.size
        let imgW = size.width > sp_screenWidth() ? sp_screenWidth() : size.width
        let imgH = imgW / (size.width / size.height)
        self.iconImgView.snp.remakeConstraints { (maker) in
            maker.width.equalTo(imgW)
            maker.height.equalTo(imgH)
            maker.top.equalTo(self.scrollView)
            maker.left.equalTo(self.scrollView)
            maker.centerX.equalTo(self.scrollView).offset(0)
//            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
        self.scrollView.contentSize = CGSize(width: 0, height: imgH)
    }
    override func sp_clickBack() {
        super.sp_clickBack()
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        self.view.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.iconImgView)
        self.view.addSubview(self.editView)
        self.view.addSubview(self.filterView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.editView.snp.top).offset(0)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.editView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(40)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.filterView.snp.makeConstraints { (maker) in
            filterRightConstraint =  maker.right.equalTo(self.view).offset(0).constraint
            maker.height.equalTo(self.view.snp.height).multipliedBy(0.5)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
            maker.width.equalTo(filterViewWidth)
        }
    }
    deinit {
        
    }
}
extension SPPhotoEditVC : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.iconImgView
    }
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let delta_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
//
//        let delta_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
//
//        //让imageView一直居中
//
//        //实时修改imageView的center属性 保持其居中
//
//        self.iconImgView.center = CGPoint(x: scrollView.contentSize.width/2 + delta_x, y: scrollView.contentSize.height/2 + delta_y)
//        sp_log(message: self.iconImgView.frame)
//    }
    
}

extension SPPhotoEditVC {
    fileprivate func sp_dealBtnClick(type : ButtonClickType){
        switch type {
        case .cance:
            sp_clickBack()
        case .done:
            sp_clickFinish()
        case .shear:
            sp_clickShear()
        case .filter:
            sp_clickFilter()
        default:
            sp_log(message: "点击没有定义的")
        }
    }
    fileprivate func sp_clickFinish(){
        
    }
    fileprivate func sp_clickShear(){
        let clipVC = SPClipImgVC()
        clipVC.originalImg = self.iconImgView.image
        clipVC.clipBlock = { [weak self] (image , isCance ) in
            if !isCance {
                self?.sp_setupData(image: image)
            }
        }
        self.present(clipVC, animated: true, completion: nil)
    }
    fileprivate func sp_clickFilter(){
        if(self.filterView.isHidden){
            self.filterRightConstraint.update(offset: 0)
        }else{
            self.filterRightConstraint.update(offset: -filterViewWidth)
        }
        self.filterView.isHidden = !self.filterView.isHidden
        sp_changeFilterData()
    }
    /*
     改变滤镜图片的数据
     */
    func sp_changeFilterData(){
        sp_sync {
            if (self.filterView.isHidden == false){
                if let image = self.iconImgView.image {
                    self.videoData.setup(inputImage: CIImage(image: image), complete: { [weak self] () in
                        sp_mainQueue {
                            self?.filterView.filterList = self?.videoData.getFilterList()
                        }
                    })
                }
            }
        }
    }
    fileprivate func sp_dealFilter(model : SPFilterModel?){
        guard let filterModel = model else {
            return
        }
        self.iconImgView.image = filterModel.showImage
    }
    
}
