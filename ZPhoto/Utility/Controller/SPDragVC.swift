//
//  SPDragVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/7.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
typealias SPDragComplete = (_ array : [Any]?)->Void

/// 拖拽
class SPDragVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    var dataArray : [Any]?
    var complete : SPDragComplete?
    fileprivate let cellID = "dragCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_addGesture()
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
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(SPDragCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLanguageChange.sp_getString(key: "DONE"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_done))
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
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
extension SPDragVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPDragCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPDragCollectionCell
        if indexPath.row < sp_count(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            if let photoModel : SPPhotoModel = model as? SPPhotoModel{
                cell.image = photoModel.img
            }else if let videoModel : SPVideoModel = model as? SPVideoModel{
                cell.image = videoModel.thumbnailImage
            }else{
                cell.image = nil
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        sp_log(message: sourceIndexPath)
        sp_log(message: destinationIndexPath)
        if let data = self.dataArray?[sourceIndexPath.row] {
            self.dataArray?.remove(at: sourceIndexPath.row)
            self.dataArray?.insert(data, at: destinationIndexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = Int( (collectionView.frame.size.width - 20 - 20 ) / 3.0 )
        return CGSize(width: w, height: w)
    }
}
extension SPDragVC {
    
    @objc fileprivate func sp_done(){
        self.sp_dealComplete()
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.complete else {
            return
        }
        block(self.dataArray)
    }
    fileprivate func sp_addGesture(){
        let longGres = UILongPressGestureRecognizer(target: self, action: #selector(sp_handle(longPress:)))
        self.collectionView.addGestureRecognizer(longGres)
        
    }
    @objc fileprivate func sp_handle(longPress : UILongPressGestureRecognizer){
        switch longPress.state {
        case .began:
            if let indexPath = self.collectionView.indexPathForItem(at: longPress.location(in: self.collectionView)){
                if  let cell = self.collectionView.cellForItem(at: indexPath){
                    self.view.bringSubviewToFront(cell)
                    self.collectionView.beginInteractiveMovementForItem(at: indexPath)
                   
                }
            }
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(longPress.location(in: self.collectionView))
        case .ended:
            self.collectionView.endInteractiveMovement()
        default:
            self.collectionView.cancelInteractiveMovement()
            sp_log(message: "")
        }
    }
}
