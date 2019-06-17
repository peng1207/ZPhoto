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
        //根据当前滚动进行对每个cell进行缩放
        //首先获取 当前rect范围内的 attributes对象
        let array = super.layoutAttributesForElements(in: rect)
        let ScaleFactor:CGFloat = 0.001//缩放因子
        //计算缩放比  首先计算出整体中心点的X值 和每个cell的中心点X的值
        //用着两个x值的差值 ，计算出绝对值
        //colleciotnView中心点的值
        let centerX =  (collectionView?.contentOffset.x)! + (collectionView?.bounds.size.width)!/2
        //循环遍历每个attributes对象 对每个对象进行缩放
        for attr in array! {
            //计算每个对象cell中心点的X值
            let cell_centerX = attr.center.x
            
            //计算两个中心点的便宜（距离）
            //距离越大缩放比越小，距离小 缩放比越大，缩放比最大为1，即重合
            let distance = abs(cell_centerX-centerX)
            let scale:CGFloat = 1/(1+distance*ScaleFactor)
            attr.transform3D = CATransform3DMakeScale(1.0, scale, 1.0)
            
        }
        
        return array
//        let array = super.layoutAttributesForElements(in: rect)
//        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

