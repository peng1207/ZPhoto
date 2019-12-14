//
//  SPAlbumVC.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/15.
//

import Foundation
import SnapKit
import UIKit
import Photos
/// 相簿图片结构体
struct SPImageAlbumItem {
    /// 相簿名称
    var title : String?
    /// 相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
}
/// 相簿列表
class SPAlbumVC: UIViewController{
    var itemArray : [SPImageAlbumItem] = [SPImageAlbumItem]()
    fileprivate let imageManager : PHCachingImageManager = PHCachingImageManager()
    fileprivate var tableView : UITableView!
    /// 最大的选择图片数量
    public var maxSelectNum : Int = 1
    public var selectComplete : SPImagePickerComplete?
    fileprivate let cellRowHeight : CGFloat = 80
    fileprivate lazy var itemSize : CGSize = {
         return CGSize(width: self.cellRowHeight * SP_DEVICE_SCALE, height: self.cellRowHeight * SP_DEVICE_SCALE)
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.sp_setupUI()
        sp_getPhotos()
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
    /// 创建UI
    fileprivate func sp_setupUI() {
        self.navigationItem.title = SPLibararyLanguage.sp_library(key: "sdk_album")
        self.view.backgroundColor = UIColor.white
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SPLibararyLanguage.sp_library(key: "sdk_cance"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sp_clickCance))
        self.tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = cellRowHeight
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    fileprivate func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        sp_log(message: "销毁")
    }
}
extension SPAlbumVC {
    
    /// 跳到图片列表
    /// - Parameter albumItem: 当前的相簿
    fileprivate func sp_pushListVC(albumItem : SPImageAlbumItem?){
        let listVC = SPImagePickerListVC()
        listVC.maxSelectNum = self.maxSelectNum
        listVC.albumItem = albumItem
        listVC.selectComplete = self.selectComplete
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    /// 点击取消
    @objc fileprivate func sp_clickCance(){
        self.dismiss(animated: true, completion: nil)
    }
    /// 获取相簿图片数据
    fileprivate func sp_getPhotos(){
        SPAuthorizatio.sp_isPhoto { [weak self](auth) in
            if auth {
                self?.sp_getAlbum()
            }else{
                self?.sp_noAuth()
            }
        }
    }
    /// 没有权限
    private func sp_noAuth(){
       self.tableView.isHidden = true
    }
    /// 获取相簿
    private func sp_getAlbum(){
        sp_sync {
            let option = PHFetchOptions()
            let smartAlum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: option)
            self.sp_convertCollection(collection: smartAlum)
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.sp_convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            //相册按包含的照片数量排序（降序）
            self.itemArray.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            sp_mainQueue {
                self.tableView.reloadData()
            }
        }
    }
    
    ///转化处理获取到的相簿
    private func sp_convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if c.assetCollectionSubtype == .smartAlbumAllHidden {
                continue
            }
            if c.assetCollectionSubtype.rawValue == 1000000201 {
                continue
            }
            if assetsFetchResult.count > 0 {
                self.itemArray.append(SPImageAlbumItem(title: c.localizedTitle, fetchResult: assetsFetchResult))
            }
        }
    }
}
extension SPAlbumVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemArray.count > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "albumCellID"
        var cell : SPAlbumTableCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? SPAlbumTableCell
        if cell == nil {
            cell = SPAlbumTableCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        }
        if indexPath.row < self.itemArray.count {
            let item = self.itemArray[indexPath.row]
            cell?.titleLabel.text = item.title
            if let asset = item.fetchResult.firstObject {
                self.imageManager.requestImage(for: asset, targetSize: self.itemSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, hasable) in
                    cell?.iconImgView.image = image
                }
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.itemArray.count {
            sp_pushListVC(albumItem: self.itemArray[indexPath.row])
        }
    }
    
}
class SPAlbumTableCell: UITableViewCell {
    lazy var iconImgView : UIImageView = {
       let view = UIImageView()
        return view
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.iconImgView)

        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.iconImgView.snp.height).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImgView.snp.right).offset(10)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView).offset(-30)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_scale(value: 1))
        }
    }
    deinit {
        
    }
}
