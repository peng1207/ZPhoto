//
//  SPImagePickerVC.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/15.
//

import Foundation
import UIKit
import SnapKit
/// 选择图片回调
public typealias SPImagePickerComplete = (_ images : [UIImage]? , _ assets : [Any]?)->Void
/// 选择图片 入口
public class SPImagePickerVC : UINavigationController{
    
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    /// 初始化
    /// - Parameter maxSelectNum: 最大选择的数量
    /// - Parameter complete: 选择后的回调
    public init(maxSelectNum : Int,complete : SPImagePickerComplete?){
        let albumVC = SPAlbumVC()
        albumVC.maxSelectNum = maxSelectNum
        albumVC.selectComplete = complete
        super.init(rootViewController: albumVC)
    }
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    fileprivate func sp_setupUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationBar.tintColor = UIColor.white
        self.sp_addConstraint()
    }
    /// 处理有没数据
    fileprivate func sp_dealNoData(){
         
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}

