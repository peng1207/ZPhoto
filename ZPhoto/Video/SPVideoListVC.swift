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
    fileprivate lazy var noDataView : UILabel = {
        let label = UILabel()
        label.text = SPLanguageChange.getString(key: "NO_VIDEO_TIP")
        label.numberOfLines = 0;
        label.font = fontSize(fontSize: 14)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        self.setupUI()
        self.videoData()
        self.sendNotification()
        let userDefault = UserDefaults.standard
        let languages:NSArray = userDefault.object(forKey: "AppleLanguages") as! NSArray
        SPLog("languages is \(languages)")
        
        //        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        
        //        for filterName in filterNames {
        //            let filter = CIFilter(name: filterName)
        //            print("\rfilter:\(filterName)\rattributes:\(filter?.attributes)")
        //        }
        
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
        self.view.addSubview(self.noDataView);
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.register(SPVideoCollectionCell.self, forCellWithReuseIdentifier: identify)
        self.videoCollectionView.backgroundColor = UIColor.white
        self.addConstraintToView()
    }
    /**< 创建导航栏上控件 */
    fileprivate func setupNavUI(){
//        let addButton = UIButton(type: .custom)
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        addButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        addButton.addTarget(self, action: #selector(clickAdd), for: .touchUpInside)
        addButton.setImage(UIImage(named: "videoAdd"), for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func addConstraintToView (){
        self.videoCollectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.noDataView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.right.equalTo(self.view).offset(-20);
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
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
        let alert = UIAlertController(title: SPLanguageChange.getString(key: "TIPS"), message: SPLanguageChange.getString(key: "DELETE_VIDEO_MSG"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: SPLanguageChange.getString(key: "CANCE"), style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: SPLanguageChange.getString(key: "DELETE"), style: UIAlertActionStyle.default, handler: { [weak self](action) in
            self?.videoDataArray?.remove(object: model)
            SPVideoHelp.remove(fileUrl: model.url!)
            self?.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     处理没有数据的
     */
    fileprivate func dealNoData(){
        if ((self.videoDataArray?.count)! > 0) {
            self.noDataView.isHidden = true
            self.videoCollectionView.isHidden = false
        }else{
            self.noDataView.isHidden = false
            self.videoCollectionView.isHidden = true
        }
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
        self.reloadData()
    }
    /*
     刷新数据
     */
    fileprivate func reloadData(){
        dispatchMainQueue {
            self.videoCollectionView.reloadData()
            self.dealNoData()
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
