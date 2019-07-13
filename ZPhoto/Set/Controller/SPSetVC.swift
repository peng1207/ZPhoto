//
//  SPSetVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/7/11.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
class SPSetVC: SPBaseVC {
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPSetModel] = [SPSetModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupData()
        self.sp_setupUI()
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
    override func sp_clickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func sp_setupData(){
        self.dataArray.append(SPSetModel.sp_init(type: .share))
        self.dataArray.append(SPSetModel.sp_init(type: .score))
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "SET")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 0)
        self.tableView.tableFooterView = view
        
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
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
        
    }
}
extension SPSetVC{
    /// 点击分享
    @objc fileprivate func sp_clickShare(){
        let shareUrl = "https://apps.apple.com/cn/app/id1381058961"
        sp_shareOther(shareData: ["分享",shareUrl], vc: self)
    }
    /// 点击评分
    @objc fileprivate func sp_clickScore(){
        let urlString = "https://itunes.apple.com/cn/app/id1381058961?action=write-review";
        UIApplication.shared.open(URL(string: urlString)!, options:[String : Any](), completionHandler: nil)
    }
}


extension SPSetVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "setCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
//            cell?.selectionStyle = .none
        }
        if indexPath.row < self.dataArray.count {
            let model = self.dataArray[indexPath.row]
            cell?.textLabel?.text = model.title
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < self.dataArray.count {
            let model = self.dataArray[indexPath.row]
            switch model.type {
            case .share:
                sp_clickShare()
            case .score:
                sp_clickScore()
            }
        }
    }
    
}
