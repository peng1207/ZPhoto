//
//  SPRecordVideoFilterView.swift
//  ZPhoto
//
//  Created by okdeer on 2018/3/8.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
fileprivate let  itemH: CGFloat = 60
class SPRecordVideoFilterView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
 
    lazy fileprivate  var filterCollectionView : UICollectionView? =  {
        let layout = SPRecordVideoFilterFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout:layout)
        collectionView.backgroundColor = self.backgroundColor
 
        return collectionView
    }()
  
    fileprivate  lazy var selectLayer : CALayer = {
        let layer = CALayer()
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        return layer
    }()
    
    var filterList : Array<SPFilterModel>?  {
        didSet{
            sp_reload()
        }
    }
    var collectSelectComplete : ((_ model : SPFilterModel) ->  Void)?
     fileprivate let identify:String = "filterViewCell"
    fileprivate var isScroll : Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_reload(){
       
        guard !self.isScroll else {
            return
        }
        
        if sp_count(array:  self.filterList) > 0 {
            UIView.performWithoutAnimation {
                filterCollectionView?.reloadSections([0])
            }
        }else{
            filterCollectionView?.reloadData()
        }
      
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectLayer.frame = CGRect(x: 0, y: self.frame.size.height / 2.0 - itemH / 2.0, width: self.frame.size.width, height: itemH)
    }
    
}

extension  SPRecordVideoFilterView {
    /**
     创建UI
     */
    fileprivate func setupUI(){
        self.addSubview(filterCollectionView!)
        
        self.layer.addSublayer(self.selectLayer)
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
        if indexPath.row <  sp_count(array:  self.filterList){
            let model = filterList?[indexPath.row]
            cell.imageView.image = model?.showImage
        }
        return cell
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScroll = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isScroll = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.convert((self.filterCollectionView?.center)!, to: self.filterCollectionView)
        
        let indexPath = self.filterCollectionView?.indexPathForItem(at: pInView)
        completeBlock(indexPath: indexPath)
        let  scrollToScrollStop : Bool = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            sp_asyncAfter(time: 0.5) {
                self.isScroll = false
                sp_log(message: "滚动结束")
                
            }
        }
    }
    /*
     选中的滤镜回调
     */
    fileprivate func completeBlock(indexPath:IndexPath?){
        if let index = indexPath {
            if index.row < (filterList?.count)! , let complete  = collectSelectComplete{
                complete((filterList?[index.row])!)
            }
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
        
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 0.1 * itemH
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
//        itemH = self.collectionView?.bounds.width ?? 0;
        self.itemSize = CGSize(width: itemH, height: itemH)
        //设置边距(让第一张图片与最后一张图片出现在最中央)ps:这里可以进行优化
        let inset = (self.collectionView?.bounds.height ?? 0)  * 0.5 - self.itemSize.height * 0.5
        self.sectionInset = UIEdgeInsets(top: inset,left: 0, bottom: inset, right: 0)
    }
    /**
     用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
     并返回。
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let ret = super.layoutAttributesForElements(in: rect)
//        //可见矩阵
//        let visiableRect = CGRect(x:self.collectionView!.contentOffset.x,y: self.collectionView!.contentOffset.y, width:self.collectionView!.frame.width,height:self.collectionView!.frame.height)
//
//        //接下来的计算是为了动画效果
//        let maxCenterMargin = self.collectionView!.bounds.height * 0.5 + itemH * 0.5;
//        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
//        let centerX = self.collectionView!.contentOffset.y + self.collectionView!.frame.size.height * 0.5;
//        for attributes in ret! {
//            //如果不在屏幕上，直接跳过
//            if !visiableRect.intersects(attributes.frame) {continue}
//            let scale = 1 + (0.8 - abs(centerX - attributes.center.y) / maxCenterMargin)
//            attributes.transform = CGAffineTransform(scaleX: 1.0, y: scale)
//        }
        
        return ret
    }
    
    /**
     用来设置collectionView停止滚动那一刻的位置
     
     - parameter proposedContentOffset: 原本collectionView停止滚动那一刻的位置
     - parameter velocity:              滚动速度
     
     - returns: 最终停留的位置
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //实现这个方法的目的是：当停止滑动，时刻有一张图片是位于屏幕最中央的。
        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        //获得collectionVIew中央的X值(即显示在屏幕中央的Y)
        let centerY = proposedContentOffset.y + self.collectionView!.frame.height * 0.5;
        //这个范围内所有的属性
        let array = self.layoutAttributesForElements(in: lastRect)
        
        //需要移动的距离
        var adjustOffsetY = CGFloat(MAXFLOAT);
        for attri in array! {
            if abs(attri.center.y - centerY) < abs(adjustOffsetY) {
                adjustOffsetY = attri.center.y - centerY;
            }
        }
        return CGPoint(x:proposedContentOffset.x , y:proposedContentOffset.y + adjustOffsetY )
    }
    
    /**
     返回true只要显示的边界发生改变就重新布局:(默认是false)
     内部会重新调用prepareLayout和调用
     layoutAttributesForElementsInRect方法获得部分cell的布局属性
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
