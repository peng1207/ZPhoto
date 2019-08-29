//
//  SPPhotoListVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
typealias SPPhotoListSelectComplete = (_ model : SPPhotoModel)->Void
class SPPhotoListVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var choiceBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "CHOICE"), for: UIControl.State.normal)
        btn.setTitle(SPLanguageChange.sp_getString(key: "CANCE"), for: UIControl.State.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControl.State.selected)
        btn.titleLabel?.font = sp_fontSize(fontSize:  16)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.addTarget(self, action: #selector(sp_clickChoise), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var editView : SPPhotoListToolView = {
        let view = SPPhotoListToolView()
        view.deleteBlock = { [weak self] in
            self?.sp_clickDelete()
        }
        view.shareBlock = { [weak self] in
            self?.sp_clickShare()
        }
        view.isHidden = true
        return view
    }()
    fileprivate var dataArray : [SPPhotoModel]?
    var selectArray : [SPPhotoModel] = [SPPhotoModel]()
    fileprivate let cellID = "SPPHOTOLISTCOLLECTCELLID"
    fileprivate var isEdit : Bool = false
    fileprivate var editHeight : Constraint!
    var selectBlock : SPPhotoListSelectComplete?
    var selectMaxCount : Int = 9
    var isCanAddOther : Bool = false
    var pushEditVC : Bool = false
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
        sp_sync {
            self.dataArray = SPPhotoHelp.sp_getPhototList()
            sp_mainQueue {
                 self.collectionView.reloadData()
            }
           
        }
       
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPPhotoListCollectionCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.editView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.choiceBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.editView.snp.top).offset(0)
        }
        self.editView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            self.editHeight = maker.height.equalTo(0).constraint
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
extension SPPhotoListVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array:  self.dataArray) > 0 || self.isCanAddOther ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array:  self.dataArray) + (self.isCanAddOther ? 1 : 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPPhotoListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SPPhotoListCollectionCell
        cell.contentView.backgroundColor = UIColor.white
        if indexPath.row < sp_count(array:  self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.model = model
            var isSelect = false
            if let m = model, self.selectArray.contains(m){
                isSelect = true
                cell.num = self.selectArray.sp_number(of: m)
            }else{
                cell.num = 0
            }
            cell.isSelect = isSelect;
        }else{
            cell.model = nil
            cell.isSelect = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array:  self.dataArray) {
              let model = self.dataArray?[indexPath.row]
            if let m = model {
                if isEdit {
                    if self.selectArray.contains(m) {
                        self.selectArray.remove(object: m)
                    }else{
                        self.selectArray.append(m)
                    }
                    self.collectionView.reloadData()
                     sp_dealBtnEnabled()
                }else{
                    if let block = self.selectBlock {
                        sp_dealSelect(block: block, m: m)
                       
                    }else{
                        let vc = SPPhotoBrowseVC()
                        vc.dataArray = self.dataArray
                        vc.selectModel = m
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }else{
            sp_pushSelectImg()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger( (collectionView.frame.size.width - 6.0) / 4.0)
        return CGSize(width: width, height: width)
    }
}
extension SPPhotoListVC {
    fileprivate func sp_pushSelectImg(){
        if sp_count(array:  self.selectArray) < self.selectMaxCount || self.selectMaxCount == 0{
            let imageVC = SPImagePickerVC(maxSelectNum: self.selectMaxCount > 0 ? self.selectMaxCount - sp_count(array: self.selectArray) : 1) { [weak self](images, assets) in
                self?.sp_dealAddOther(images: images)
            }
            self.present(imageVC, animated: true, completion: nil)
        }else{
            sp_maxNumTips()
        }
      
    }
    fileprivate func sp_dealAddOther(images : [UIImage]?){
        if self.pushEditVC {
            if let list = images {
                let model = SPPhotoModel()
                model.img = list.first
                let editVC = SPPhotoEditVC()
                editVC.photoModel = model
                self.navigationController?.pushViewController(editVC, animated: true)
            }
        }else{
            if let list = images , sp_count(array: list) > 0, let block = self.selectBlock{
                for image in list {
                    let model = SPPhotoModel()
                    model.img = image
                    self.selectArray.append(model)
                    block(model)
                }
            }
        }
    }
    
    /// 处理选择的
    ///
    /// - Parameters:
    ///   - block: 回调
    ///   - m: 选择的数据
    fileprivate func sp_dealSelect(block : SPPhotoListSelectComplete,m : SPPhotoModel){
        if sp_count(array:  self.selectArray) < self.selectMaxCount || self.selectMaxCount == 0{
            block(m)
            self.selectArray.append(m)
            self.collectionView.reloadData()
        }else{
            self.sp_maxNumTips()
        }
    }
    fileprivate func sp_maxNumTips(){
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: "\(SPLanguageChange.sp_getString(key: "MAXSELECT"))\(sp_getString(string: self.selectMaxCount))\(SPLanguageChange.sp_getString(key: "PICTURES"))", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    /// 删除选择的
    ///
    /// - Parameter model: 选择的model
    open func sp_removeSelect(model : SPPhotoModel){
        self.selectArray.remove(object: model)
        self.collectionView.reloadData()
    }
    /// 清除所有的数据
    func sp_clearSelect(){
        self.selectArray.removeAll()
        self.collectionView.reloadData()
    }
    /// 删除某个位置的元素
    ///
    /// - Parameter index: 位置
    func sp_removeSelect(index : Int){
        self.selectArray.sp_remove(of: index)
        self.collectionView.reloadData()
    }
    /// 获取cell 的位置
    ///
    /// - Parameter model: 数据源
    /// - Returns: 位置
    func sp_getCellPoint(model : SPPhotoModel)->CGPoint{
        var point = CGPoint(x: 0, y: 0 )
        if let index = self.dataArray?.index(of: model){
            if let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                point = self.collectionView.convert(cell.frame.origin, to: self.view)
                point.x = point.x + cell.frame.size.width / 2.0
                point.y = point.y + cell.frame.size.height / 2.0
            }
        }else{
            point = CGPoint(x: self.view.sp_width() / 2.0, y: 0)
        }
        return point
    }
    
    @objc fileprivate func sp_clickChoise(){
        self.choiceBtn.isSelected = !self.choiceBtn.isSelected;
        self.isEdit = !self.isEdit
        if self.choiceBtn.isSelected == false {
            self.selectArray.removeAll()
            self.collectionView.reloadData()
        }
        sp_dealEditView()
        sp_dealBtnEnabled()
    }
    /// 点击分享
    @objc fileprivate func sp_clickShare(){
        var imgArray = [UIImage]()
        for model in self.selectArray {
            if let img = model.img {
                imgArray.append(img)
            }
        }
        SPShare.sp_share(imgs: imgArray, vc: self)
        
    }
    /// 点击删除
    @objc fileprivate func sp_clickDelete(){
        let actionSheet = UIAlertController(title: SPLanguageChange.sp_getString(key: "TIPS"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction = UIAlertAction(title:  SPLanguageChange.sp_getString(key: "DELETE"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
            self?.sp_dealFileDelete()
        })
        let canceAction = UIAlertAction(title:  SPLanguageChange.sp_getString(key: "CANCE"), style: UIAlertAction.Style.cancel) { (action) in
            
        }
        deleteAction.setValue(SPColorForHexString(hex: SP_HexColor.color_ff3300.rawValue), forKey: "_titleTextColor")
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(canceAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    /// 处理文件删除
    fileprivate func sp_dealFileDelete(){
        for model in self.selectArray {
            FileManager.remove(path: sp_getString(string: model.filePath))
             let point = sp_getCellPoint(model: model)
            sp_removeImgAnimation(img: model.img,startPoint: point)
        }
        self.dataArray?.remove(of: self.selectArray)
        self.selectArray.removeAll()
        self.collectionView.reloadData()
        sp_dealBtnEnabled()
    }
    fileprivate func sp_removeImgAnimation(img : UIImage?,startPoint : CGPoint){
        guard let image = img else {
            return
        }
        let layerW : CGFloat = 50.00
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        
        
        
         let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.2
        
         let position = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.move(to:startPoint)
        var curvePoint = CGPoint(x: startPoint.x + sp_screenWidth() / 2.0 , y: startPoint.y - 30)
        if curvePoint.x >= sp_screenWidth() {
            curvePoint.x = startPoint.x - sp_screenWidth() / 2.0
        }
        
        if curvePoint.x < 0  {
            curvePoint.x = sp_screenWidth() / 2.0
        }
        if curvePoint.y < 0  {
            curvePoint.y = 0
        }
        
        path.addQuadCurve(to: CGPoint(x: sp_screenWidth() - 10 - 15, y: self.editView.frame.origin.y + 15), controlPoint: curvePoint)
        position.path = path.cgPath
        position.rotationMode = CAAnimationRotationMode.rotateAuto
        
        groupAnimation.animations = [scaleAnimation,position]
        
        let imgLayer = CALayer()
        imgLayer.frame = CGRect(x: 0, y: -layerW, width: layerW, height: layerW)
        imgLayer.contents = image.cgImage
        imgLayer.cornerRadius = layerW / 2.0
        imgLayer.masksToBounds = true
        self.view.layer.addSublayer(imgLayer)
        imgLayer.add(groupAnimation, forKey: "")
        sp_asyncAfter(time: 1) {
            imgLayer.removeFromSuperlayer()
        }
    }
    
    
    
    /// 处理编辑view是否显示
    fileprivate func sp_dealEditView(){
        if self.choiceBtn.isSelected {
            self.editHeight.update(offset: 50)
            self.editView.isHidden = false
        }else{
            self.editHeight.update(offset: 0)
            self.editView.isHidden = true
        }
    }
    /// 处理编辑按钮是否可以点击
    fileprivate func sp_dealBtnEnabled(){
        if sp_count(array:  self.selectArray) > 0 {
            self.editView.sp_dealBtn(isEnabled: true)
        }else{
            self.editView.sp_dealBtn(isEnabled: false)
        }
    }
}
