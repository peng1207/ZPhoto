//
//  SPRecordVideoFilterView.swift
//  ZPhoto
//
//  Created by okdeer on 2018/3/8.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

class SPRecordVideoFilterView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
 
    
    lazy fileprivate  var filterCollectionView : UICollectionView? =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize  =  CGSize(width: 30, height: 30)
        layout.minimumLineSpacing = 0 
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    var filterList : Array<SPFilterModel>?  {
        didSet{
                
            filterCollectionView?.reloadData()
        }
    }
     fileprivate let identify:String = "filterViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension  SPRecordVideoFilterView {
    /**
     创建UI
     */
    fileprivate func setupUI(){
        self.addSubview(filterCollectionView!)
        filterCollectionView?.snp.makeConstraints({ (maker) in
            maker.left.top.right.bottom.equalTo(self).offset(0)
        })
        filterCollectionView?.delegate  = self
        filterCollectionView?.dataSource = self
        filterCollectionView?.register(SPRecordVideoFilterCell.self , forCellWithReuseIdentifier: self.identify)
    }
}
//MARK: delete
extension SPRecordVideoFilterView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let  list = filterList else {
            return 0
        }
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! SPRecordVideoFilterCell
        if indexPath.row <  (filterList?.count)!{
                  let model = filterList?[indexPath.row]
            cell.imageView.image = model?.showImage
        }
      
        return cell
    }
}

class SPRecordVideoFilterCell : UICollectionViewCell{
    
    var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SPRecordVideoFilterCell {
    /**
     创建UI
     */
    fileprivate func setupUI(){
        imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.contentView).offset(0)
        }
    }
}
