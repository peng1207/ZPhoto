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
        if let srcImage = self.photoModel?.img {
//            if let ciImg = CIImage(image: srcImage) {
//                let tran =  CGAffineTransform(translationX: 10, y: 0)
//
//                let img =  UIImage(ciImage:  ciImg.transformed(by: tran))
//                self.iconImgView.image = img
//
////                UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
//            }
            
            
//            //Quartz重绘图片
            let rect = CGRect(x: 0, y: 0, width: srcImage.size.width , height: srcImage.size.height );//创建矩形框
//            //根据size大小创建一个基于位图的图形上下文
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
            let currentContext =  UIGraphicsGetCurrentContext()//获取当前quartz 2d绘图环境

//            currentContext?.clip(to: rect)//设置当前绘图环境到矩形框
//             currentContext?.translateBy(x: 10, y: 0)
//            currentContext?.scaleBy(x: 0.25, y: 0.5)
//            currentContext?.rotate(by: CGFloat.pi / 180 * 45 ) //旋转角度
//            currentContext.
            //平移， 这里是平移坐标系，跟平移图形是一个道理
//           currentContext?.translateBy(x: rect.size.width, y: 0)

            currentContext?.draw(srcImage.cgImage!, in: rect,byTiling: true)
           
            let drawImage =  UIGraphicsGetImageFromCurrentImageContext();//获得图片
            UIGraphicsEndImageContext()
            let flipImage =  UIImage(cgImage: (drawImage?.cgImage)!, scale: srcImage.scale, orientation: .up)
            
            //Quartz重绘图片
          
            //根据size大小创建一个基于位图的图形上下文
//            UIGraphicsBeginImageContextWithOptions(rect.size, false, 2)
//            let currentContext =  UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
//
//            currentContext?.clip(to: rect)   //设置当前绘图环境到矩形框
//            //绘图
//            currentContext?.draw(srcImage.cgImage!, in: rect)
//            //翻转图片
//            let drawImage =  UIGraphicsGetImageFromCurrentImageContext();//获得图片
//            let flipImage =  UIImage(cgImage:(drawImage?.cgImage)!,
//                                     scale:srcImage.scale,
//                                     orientation:srcImage.imageOrientation  //图片方向不用改
//            )
            
            self.iconImgView.image = flipImage
//             UIImageWriteToSavedPhotosAlbum(flipImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
           
        }
        
        
//        self.iconImgView.image = self.photoModel?.img
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
