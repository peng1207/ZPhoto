//
//  SPRecordVideoCollectionCell.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/5/23.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit

class SPVideoCollectionCell : UICollectionViewCell{
    
    lazy public var videoImageView : UIImageView! = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var videoModel : SPVideoModel!{
        didSet{
            videoImageView.image = videoModel.thumbnailImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SPVideoCollectionCell{
    
    fileprivate func setupUI(){
        self.contentView.addSubview(videoImageView)
        videoImageView.snp.makeConstraints { (maker) in
            maker.top.right.left.bottom.equalTo(self.contentView).offset(0)
        }
    }
    
}

class SPVideoCollectionFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
       
    }
    
    override func prepare() {
         self.itemSize = CGSize(width: (self.collectionView?.bounds.size.width)! * 3 / 5.0, height: (self.collectionView?.bounds.size.height)! * 3 / 4.0 )
        self.minimumLineSpacing = 20
        self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
       
        super.prepare()
    }
     
  
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        
//        //可见矩阵
//        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
//        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
//        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5;
//        SPLog(visiableRect)
//        SPLog(centerX)
//        for attributes in array! {
//            //如果不在屏幕上，直接跳过
//            
//            if !visiableRect.intersects(attributes.frame) {
//                 attributes.transform = CGAffineTransform(rotationAngle: -5 * CGFloat(M_PI / 180))
//                continue
//            }
//            SPLog("在屏幕中\(attributes)")
//           
//        }
        
        return array
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

