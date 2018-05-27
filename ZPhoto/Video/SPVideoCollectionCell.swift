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
    lazy public var playImageView : UIImageView! = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "play")
        return imageView
    }()
    
    lazy public var deleteBtn : UIButton! = {
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "delete.png")
//        button.setImage(image, for: UIControlState.normal)
        button.setBackgroundImage(image, for: .normal)
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        return button
    }()
    var videoModel : SPVideoModel!{
        didSet{
            videoImageView.image = videoModel.thumbnailImage
        }
    }
    var clickComplete : ((_ videoModel : SPVideoModel?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.addAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: UI
extension SPVideoCollectionCell{
    
    fileprivate func setupUI(){
        self.contentView.addSubview(videoImageView)
        self.contentView.addSubview(deleteBtn)
        self.contentView.addSubview(playImageView)
        videoImageView.snp.makeConstraints { (maker) in
            maker.top.right.left.bottom.equalTo(self.contentView).offset(0)
        }
        deleteBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(5)
            maker.right.equalTo(self.contentView).offset(-5)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        playImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.center.equalTo(self.contentView.snp.center).offset(0)
        }
    }
    
}
//MARK: action
extension SPVideoCollectionCell{
    fileprivate func addAction(){
        deleteBtn.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
    }
    
    @objc  fileprivate func buttonClick(){
        guard let complete = clickComplete else {
            return
        }
        complete(videoModel)
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

