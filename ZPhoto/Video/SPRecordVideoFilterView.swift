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
        let layout = SPRecordVideoFilterFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
//        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var filterList : Array<SPFilterModel>?  {
        didSet{
                
            filterCollectionView?.reloadData()
        }
    }
    var collectSelectComplete : ((_ model : SPFilterModel) ->  Void)?
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SPLog("collection select ")
        if indexPath.row < (filterList?.count)! , let complete  = collectSelectComplete{
            complete((filterList?[indexPath.row])!)
        }
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
        imageView.isUserInteractionEnabled = true
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.contentView).offset(0)
        }
    }
}

class SPRecordVideoFilterFlowLayout : UICollectionViewFlowLayout{
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        self.itemSize = CGSize(width: (self.collectionView?.bounds.size.width)! / 5, height: (self.collectionView?.bounds.size.height)!)
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        super.prepare()
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
