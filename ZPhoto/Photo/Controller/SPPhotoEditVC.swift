//
//  SPPhotoEditVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
// 编辑图片

import Foundation
import SnapKit
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
  
    fileprivate lazy var editView : SPPhotoEditView = {
        let view = SPPhotoEditView()
        view.clickBlock = { [weak self](type)in
            self?.sp_dealBtnClick(type: type)
        }
        return view
    }()
    
    var photoModel : SPPhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
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
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
    {
        if let e = error as NSError?
        {
            SPLog(e)
        }
        else
        {
            UIAlertController.init(title: nil,
                                   message: "保存成功！",
                                   preferredStyle: UIAlertControllerStyle.alert).show(self, sender: nil);
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.image = self.photoModel?.img
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
    }
    deinit {
        
    }
}
extension SPPhotoEditVC : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.iconImgView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let delta_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
        
        let delta_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
        
        //让imageView一直居中
        
        //实时修改imageView的center属性 保持其居中
       
        self.iconImgView.center = CGPoint(x: scrollView.contentSize.width/2 + delta_x, y: scrollView.contentSize.height/2 + delta_y)
         SPLog(self.iconImgView.frame)
    }
    
}

extension SPPhotoEditVC {
    @objc fileprivate func sp_clickEdit(){
        
    }
    fileprivate func sp_dealBtnClick(type : ButtonClickType){
        switch type {
        case .cance:
            sp_clickBack()
        case .done:
            sp_clickFinish()
        default:
            SPLog("点击没有定义的")
        }
    }
    fileprivate func sp_clickFinish(){
        
    }
     
}
