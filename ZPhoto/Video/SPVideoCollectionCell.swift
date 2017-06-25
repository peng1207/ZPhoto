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
        return array
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

