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
        if sp_count(array: self.dataArray) > 0 {
            var tmpView : UIView?
            var index = 0
            for model in self.dataArray! {
                let imgView = UIImageView()
                imgView.image = model.img
                self.scrollView.addSubview(imgView)
                var size : CGSize = CGSize.zero
                if let s = model.img?.size {
                    size = s
                }
                imgView.snp.makeConstraints { (maker) in
                    maker.width.equalTo(self.scrollView.snp.width).offset(-4)
                    maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
                    maker.left.equalTo(self.scrollView).offset(2)
                    if index == sp_count(array: self.dataArray) - 1 {
                        maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-2)
                    }
                    if let v = tmpView{
                        maker.top.equalTo(v.snp.bottom).offset(2)
                    }else{
                        maker.top.equalTo(self.scrollView.snp.top).offset(2)
                    }
                    
                    maker.height.equalTo(imgView.snp.width).multipliedBy(size.height / size.width)
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
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
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
