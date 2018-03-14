//
//  SPRecordVideoListVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/5/23.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
class SPVideoListVC: UINavigationController {
    
    
    internal init() {
        super.init(rootViewController: SPVideoListRootVC())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: -- 视频列表
fileprivate class SPVideoListRootVC : SPBaseVC {
    
    fileprivate lazy var videoCollectionView : UICollectionView = {
        let layout = SPVideoCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        let  collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        return collectionView
    }()
    fileprivate let identify:String = "ViewCell"
    fileprivate var videoDataArray : Array<SPVideoModel>? = nil
    
    override func viewDidLoad() {
        self.setupUI()
        self.videoData()
        self.sendNotification()
        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        
        for filterName in filterNames {
            let filter = CIFilter(name: filterName)
            print("\rfilter:\(filterName)\rattributes:\(filter?.attributes)")
        }

    }
}
// MARK: -- UI
extension SPVideoListRootVC {
    
    fileprivate func setupUI(){
        self.setupCollectionView()
        self.setupNavUI()
    }
    /**< 创建collectionview */
    fileprivate func setupCollectionView(){
        self.view.addSubview(self.videoCollectionView)
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.register(SPVideoCollectionCell.self, forCellWithReuseIdentifier: identify)
        self.videoCollectionView.backgroundColor = UIColor.white
        self.addConstraintToView()
    }
    /**< 创建导航栏上控件 */
    fileprivate func setupNavUI(){
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        addButton.addTarget(self, action: #selector(clickAdd), for: .touchUpInside)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.red, for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func addConstraintToView (){
        self.videoCollectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.view).offset(0)
        }
    }
    
}
// MARK: -- action
extension SPVideoListRootVC {
    @objc fileprivate func clickAdd(){
        self.present(SPRecordVideoVC(), animated: true, completion: nil)
    }
    /**
     点击删除
     */
    fileprivate func clickDetete(videoModel:SPVideoModel?){
        guard let model = videoModel else {
            return
        }
        let alert = UIAlertController(title: "tips", message: "is delete?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cance", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "delete", style: UIAlertActionStyle.default, handler: { (action) in
              SPVideoHelp.remove(videoUrl: model.url!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -- delegate
extension SPVideoListRootVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.videoDataArray?.count)!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.videoDataArray?.count)! > 0  ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! SPVideoCollectionCell
        cell.videoModel = self.videoDataArray?[indexPath.row]
        cell.clickComplete = {
          [unowned self]  (videoModel:SPVideoModel?) in
            self.clickDetete(videoModel: videoModel)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoPlayVC = SPVideoPlayVC()
        videoPlayVC.videoModel = self.videoDataArray?[indexPath.row]
        self.present(videoPlayVC, animated: true, completion: nil)
    }
    
}
// MARK: -- 数据
extension SPVideoListRootVC {
    /**< 获取视频数据  */
    @objc fileprivate func videoData(){
        let array = SPVideoHelp.videoFile()
        self.videoDataArray = array
        dispatchMainQueue {
            self.videoCollectionView.reloadData()
        }
    }
}
// MARK: -- 通知
extension SPVideoListRootVC{
    /**< 发送通知 */
    func sendNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(videoData), name:NSNotification.Name(rawValue: kVideoChangeNotification), object: nil)
    }
}
