//
//  SPFilmVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/2.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
/// 影片
class SPFilmVC: SPBaseVC {
     var dataArray : [SPPhotoModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "FILM")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "SAVE"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(sp_clickSave))
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
            
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
  
    }
    deinit {
        
    }
}
extension SPFilmVC {
    @objc fileprivate func sp_clickSave(){
        
        if let image = UIImage.sp_image(view: self.view) {
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
