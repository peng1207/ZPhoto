//
//  SPVideoSelectVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/6/29.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
typealias SPVideoSelectComplete = (_ model : SPVideoModel?)->Void

class SPVideoSelectVC: SPBaseVC {
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "videoSelectCellID"
    fileprivate var dataArray : [SPVideoModel]?
    var selectArray : [SPVideoModel]? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectBlock : SPVideoSelectComplete?
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
    fileprivate func sp_setupData(){
        sp_sync {
            let array = SPVideoHelp.sp_videoFile()
            sp_mainQueue {
                self.dataArray = array
                self.collectionView.reloadData()
            }
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 0, right: 2)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPVideoSelectCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
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
extension SPVideoSelectVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPVideoSelectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPVideoSelectCollectionCell
        if indexPath.row < sp_count(array:  self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.iconImgView.image = model?.thumbnailImage
            if let second = model?.second {
                 cell.timeLabel.text = formatForMin(seconds:second)
            }else{
                cell.timeLabel.text = "00:00"
            }
            if let selectList = self.selectArray,let m = model ,selectList.contains(m){
                cell.numLabel.isHidden = false
                cell.numLabel.text = sp_getString(string: selectList.sp_number(of: m))
            }else{
                cell.numLabel.isHidden = true
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataArray) {
            guard let block = selectBlock else{
                return
            }
            block(self.dataArray?[indexPath.row])
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.size.width - 2 - 2 - 2 * 3 ) / 4.0 )
        return CGSize(width: width, height: width)
    }
}
