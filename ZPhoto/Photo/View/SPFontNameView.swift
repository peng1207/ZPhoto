//
//  SPFontNameView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPFontNameView:  UIView{
    
    fileprivate lazy var dataArray : [String] = {
        var list = [String]()
        list.append("Thonburi-Bold")
        list.append("GillSans-Bold")
        list.append("Arial-BoldMT")
        list.append("HoeflerText-Regular")
        list.append("Helvetica-Light")
        list.append("Menlo-Regular")
        list.append("Charter-Bold")
        list.append("AppleSDGothicNeo-Regular")
       
        return list
    }()
    fileprivate var tableView : UITableView!
    fileprivate var selectName : String?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var clickBlock : ((_ name : String )->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
//        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 44
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sp_screenWidth(), height: 0))
        self.tableView.tableFooterView = view
        
        self.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPFontNameView : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "fontNameCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = self.tableView.backgroundColor
            cell?.textLabel?.text = SPLanguageChange.sp_getString(key: "index_title")
            cell?.imageView?.image = UIImage(named: "public_select")
            cell?.textLabel?.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        }
        if indexPath.row < sp_count(array: self.dataArray){
            let name = self.dataArray[indexPath.row]
            cell?.textLabel?.font = UIFont(name: name, size: 15)
            cell?.imageView?.isHidden = true
            if let select = self.selectName {
                if select == name {
                    cell?.imageView?.isHidden = false
                }
            }
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray) {
            let name = self.dataArray[indexPath.row]
            self.selectName = name
            guard let block = self.clickBlock else{
                return
            }
            block(name)
        }
    }
    
}
