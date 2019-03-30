//
//  SPPhotoBrowse.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/18.
//  Copyright © 2019 huangshupeng. All rights reserved.
//
// 浏览图片的控制器
import Foundation
import SnapKit
class SPPhotoBrowseVC: SPBaseVC {
     fileprivate var collectionView : UICollectionView!
    var dataArray : [SPPhotoModel]?
    fileprivate let cellID = "SPPhotoBrowseCellID"
    var selectModel : SPPhotoModel?
    
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
        if let model = selectModel ,sp_getArrayCount(array: self.dataArray) > 0  {
            if let isExist = self.dataArray?.contains(model) ,isExist {
                    var index = 0
                for m in self.dataArray!{
                    if m == model {
                        break
                    }
                    index = index + 1
                }
                if index < sp_getArrayCount(array: self.dataArray) {
                    sp_after(time: 0.1) {
                        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                    }
                }
            }
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(SPPhotoListCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
      
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
extension SPPhotoBrowseVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPPhotoListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPPhotoListCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell.model = self.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            let vc = SPPhotoEditVC()
            vc.photoModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
