//
//  SPSetVC.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/5/14.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import SnapKit
class SPTmpVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var baseView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate lazy var officeView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    fileprivate lazy var baseView1 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    fileprivate let K_TUNF_TAG = 1000
    
    fileprivate let scale : CGFloat = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
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
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.officeView)
 
        self.scrollView.addSubview(self.baseView1)
        self.baseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sp_clickTap)))
        self.sp_addConstraint()
//        sp_setupSubView()
        sp_setupOfficeSubView()
        sp_setupBase1SubView()
        
//        sp_after(time: 5) {
//            SPLog(self.baseView1.subviews)
//        }
        
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    
        self.officeView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.baseView1.snp.bottom).offset(0)
            maker.height.equalTo(160 * scale)
            maker.width.equalTo(70 * scale)
            maker.left.equalTo(self.scrollView).offset(0)
        }
        
//        self.baseView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.officeView.snp.right).offset( 8 * scale)
//            maker.width.equalTo(360 * scale)
//            maker.height.equalTo(530 * scale)
//
//            maker.bottom.equalTo(self.scrollView).offset(-50)
//            maker.top.equalTo(self.scrollView).offset(100)
//        }
        
        self.baseView1.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.officeView.snp.right).offset( 8 * scale)
            maker.width.equalTo(360 * scale)
            maker.height.equalTo(530 * scale)
            maker.right.equalTo(self.scrollView).offset(-8 * scale)
            maker.bottom.equalTo(self.scrollView).offset(-50)
            maker.top.equalTo(self.scrollView).offset(100)
        }
    }
    deinit {
        
    }
}
extension SPTmpVC{
    //MARK: - base
    fileprivate func sp_setupSubView(){
        let maLuLabel = sp_getLabel(text: "两条马路")
        maLuLabel.backgroundColor = UIColor.blue
        maLuLabel.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.baseView).offset(0)
            maker.width.equalTo(8 * scale)
        }
        let leisure1 = sp_getLabel(text: "休闲地方1")
        leisure1.backgroundColor = UIColor.purple
        leisure1.snp.makeConstraints { (maker) in
            maker.left.equalTo(maLuLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self.baseView).offset(0)
            maker.width.equalTo(12 * scale)
        }
        let maLuLabel1 = sp_getLabel(text: "一条马路")
        maLuLabel1.backgroundColor = UIColor.blue
        maLuLabel1.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.baseView).offset(0)
            maker.height.equalTo(4 * scale)
            maker.bottom.equalTo(self.baseView).offset(0)
        }
        let leisure2 = sp_getLabel(text: "休闲地方2")
        leisure2.backgroundColor = UIColor.purple
        leisure2.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.baseView).offset(0)
            maker.height.equalTo(12 * scale)
            maker.bottom.equalTo(maLuLabel1.snp.top).offset(0)
        }
        let parking1 = sp_getLabel(text: "停车场入口1")
        parking1.backgroundColor = UIColor.blue
        parking1.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.baseView).offset(0)
            maker.height.equalTo(6 * scale)
        }
        let parking2 = sp_getLabel(text: "停车场入口2")
        parking2.backgroundColor = UIColor.blue
        parking2.snp.makeConstraints { (maker) in
            maker.top.bottom.right.equalTo(self.baseView).offset(0)
            maker.width.equalTo(6 * scale)
        }
        
        let lWidth = 40 * scale
        let lHeight = 40 * scale
        let space : CGFloat = 20 * scale
        let tung1 = sp_getLabel(text: "1栋")
        
        tung1.backgroundColor = UIColor.blue
        tung1.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(self.baseView).offset(0)
            maker.centerY.equalTo(self.baseView).offset(-8 * scale)
        }
        let tung2 = sp_getLabel(text: "2栋")
        tung2.backgroundColor = UIColor.blue
        tung2.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.right.equalTo(tung1.snp.left).offset(-space)
            maker.bottom.equalTo(tung1.snp.top).offset(-space)
        }
        
        let tung3 = sp_getLabel(text: "3栋")
        tung3.backgroundColor = UIColor.blue
        tung3.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.right.equalTo(tung2).offset(0)
            maker.top.equalTo(tung1.snp.bottom).offset(space)
        }
        
        let tung4 = sp_getLabel(text: "4栋")
        tung4.backgroundColor = UIColor.blue
        tung4.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung1.snp.right).offset(space)
            maker.bottom.equalTo(tung1.snp.top).offset(-space)
        }
        
        let tung5 = sp_getLabel(text: "5栋")
        tung5.backgroundColor = UIColor.blue
        tung5.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung1.snp.right).offset(space)
            maker.top.equalTo(tung1.snp.bottom).offset(space)
        }
        
        let tung6 = sp_getLabel(text: "6栋")
        tung6.backgroundColor = UIColor.blue
        tung6.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
             maker.left.equalTo(tung4.snp.right).offset(space)
            maker.bottom.equalTo(tung4.snp.top).offset(-space)
        }

        let tung7 = sp_getLabel(text: "7栋")
        tung7.backgroundColor = UIColor.blue
        tung7.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
//            maker.centerY.equalTo(tung1.snp.centerY).offset(0)
            maker.top.equalTo(tung6.snp.bottom).offset(lHeight)
            maker.left.equalTo(tung4.snp.right).offset(space)
        }
        
        let tung8 = sp_getLabel(text: "8栋")
        tung8.backgroundColor = UIColor.blue
        tung8.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung4.snp.right).offset(space)
            maker.top.equalTo(tung5.snp.bottom).offset(space)
        }
        
        let tung9 = sp_getLabel(text: "9栋")
        tung9.backgroundColor = UIColor.blue
        tung9.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
            maker.top.equalTo(tung8).offset(0)
        }
        
        let tung10 = sp_getLabel(text: "10栋")
        tung10.backgroundColor = UIColor.blue
        tung10.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.right.equalTo(tung3.snp.left).offset(-space)
            maker.top.equalTo(tung8).offset(0)
        }
        
        let tung11 = sp_getLabel(text: "11栋")
        tung11.backgroundColor = UIColor.blue
        tung11.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.right.equalTo(tung10).offset(0)
//            maker.centerY.equalTo(tung1.snp.centerY).offset(0)
            maker.bottom.equalTo(tung10.snp.top).offset(-lHeight)
        }
        
        let tung12 = sp_getLabel(text: "12栋")
        tung12.backgroundColor = UIColor.blue
        tung12.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.right.equalTo(tung10).offset(0)
            maker.bottom.equalTo(tung2.snp.top).offset(-space)
        }
        
        let tung13 = sp_getLabel(text: "13栋")
        tung13.backgroundColor = UIColor.blue
        tung13.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.bottom.equalTo(tung12.snp.bottom).offset(0)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
        }
        
        let tung14 = sp_getLabel(text: "14栋")
        tung14.backgroundColor = UIColor.blue
        tung14.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung12.snp.left).offset(0)
            maker.bottom.equalTo(tung12.snp.top).offset(-lHeight)
        }
        
        let tung15 = sp_getLabel(text: "15栋")
        tung15.backgroundColor = UIColor.blue
        tung15.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung14.snp.centerY).offset(0)
            maker.left.equalTo(tung14.snp.right).offset(lWidth)
        }
        
        let tung17 = sp_getLabel(text: "17栋")
        tung17.backgroundColor = UIColor.blue
        tung17.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung14.snp.centerY).offset(0)
            maker.left.equalTo(tung6.snp.left).offset(0)
        }
        
        let tung16 = sp_getLabel(text: "16栋")
        tung16.backgroundColor = UIColor.blue
        tung16.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung14.snp.centerY).offset(0)
            maker.right.equalTo(tung17.snp.left).offset(-lWidth)
        }
    
        let tung18 = sp_getLabel(text: "18栋")
        tung18.backgroundColor = UIColor.blue
        tung18.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung12.snp.left).offset(0)
            maker.top.equalTo(tung10.snp.bottom).offset(lHeight )
        }
        
        
        let tung19 = sp_getLabel(text: "19栋")
        tung19.backgroundColor = UIColor.blue
        tung19.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung18.snp.centerY).offset(0)
            maker.left.equalTo(tung18.snp.right).offset(lWidth)
        }
        
        let tung21 = sp_getLabel(text: "21栋")
        tung21.backgroundColor = UIColor.blue
        tung21.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung18.snp.centerY).offset(0)
            maker.left.equalTo(tung6.snp.left).offset(0)
        }
        
        let tung20 = sp_getLabel(text: "20栋")
        tung20.backgroundColor = UIColor.blue
        tung20.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung18.snp.centerY).offset(0)
            maker.right.equalTo(tung21.snp.left).offset(-lWidth)
        }
    
        let tung22 = sp_getLabel(text: "22栋")
        tung22.backgroundColor = UIColor.blue
        tung22.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.bottom.equalTo(tung8.snp.top).offset(-lHeight)
            maker.left.equalTo(tung8.snp.left).offset(0)
        }
        
        let tung23 = sp_getLabel(text: "23栋")
        tung23.backgroundColor = UIColor.blue
        tung23.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung12.snp.centerX).offset(0)
            maker.top.equalTo(tung12.snp.bottom).offset(lHeight)
        }
        
        
        let roadSpace = 8 * scale
        let road1 = sp_getView()
        road1.snp.makeConstraints { (maker) in
            maker.height.equalTo(roadSpace)
            maker.left.equalTo(tung14).offset(0)
            maker.right.equalTo(parking2.snp.left).offset(-2 * scale)
            maker.top.equalTo(tung14.snp.bottom).offset( (lHeight - roadSpace) / 2.0)
        }
        
        let road2 = sp_getView()
        road2.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(road1).offset(0)
            maker.top.equalTo(tung10.snp.bottom).offset((lHeight - roadSpace) / 2.0)
        }
        
        let road3 = sp_getView()
        road3.snp.makeConstraints { (maker) in
            maker.top.equalTo(road1.snp.bottom).offset(0)
            maker.bottom.equalTo(road2.snp.top).offset(0)
            maker.width.equalTo(roadSpace)
            maker.left.equalTo(tung12.snp.right).offset((space - roadSpace) / 2.0)
        }

        let road4 = sp_getView()
        road4.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.left.equalTo(tung2.snp.right).offset((space - roadSpace) / 2.0)
        }
        
        let road5 = sp_getView()
        road5.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.left.equalTo(tung13.snp.right).offset((space - roadSpace) / 2.0)
        }
        
        let road6 = sp_getView()
        road6.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.left.equalTo(tung4.snp.right).offset((space - roadSpace) / 2.0)
        }
        
        let road7 = sp_getView()
        road7.snp.makeConstraints { (maker) in
            maker.left.equalTo(road3.snp.right).offset(0)
            maker.right.equalTo(road6.snp.left).offset(0)
            maker.height.equalTo(roadSpace)
            maker.top.equalTo(tung13.snp.bottom).offset((space - roadSpace) / 2.0)
        }
        
        let road8 = sp_getView()
        road8.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(road7).offset(0)
            maker.top.equalTo(tung2.snp.bottom).offset((space - roadSpace) / 2.0)
        }
        let road9 = sp_getView()
        road9.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(road7).offset(0)
            maker.top.equalTo(tung1.snp.bottom).offset((space - roadSpace) / 2.0)
        }
        
        let road10 = sp_getView()
        road10.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(road7).offset(0)
            maker.top.equalTo(tung3.snp.bottom).offset((space - roadSpace) / 2.0)
        }
        
        
        let road11 = sp_getView()
        road11.snp.makeConstraints { (maker) in
            maker.top.equalTo(road1.snp.bottom).offset(0)
            maker.right.equalTo(road1.snp.right).offset(0)
            maker.width.equalTo(roadSpace)
            maker.bottom.equalTo(tung4.snp.centerY).offset(0)
        }
        
        let road12 = sp_getView()
        road12.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(road2.snp.top).offset(0)
            maker.right.equalTo(road2.snp.right).offset(0)
            maker.width.equalTo(roadSpace)
            maker.top.equalTo(tung5.snp.centerY).offset(0)
        }
        
        let road13 = sp_getView()
        road13.snp.makeConstraints { (maker) in
            maker.right.equalTo(parking2.snp.left).offset(0)
            maker.centerY.equalTo(tung4.snp.centerY).offset(0)
            maker.height.equalTo(roadSpace)
            maker.width.equalTo(roadSpace + roadSpace)
        }
        
        let road14 = sp_getView()
        road14.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(road13).offset(0)
            maker.centerY.equalTo(tung5.snp.centerY).offset(0)
        }
        self.baseView.bringSubview(toFront: maLuLabel)
        
        let sport1 = sp_getLabel(text: "篮球、羽毛球 1")
        sport1.backgroundColor = UIColor.purple
        let sport2 = sp_getLabel(text: "篮球、羽毛球 2")
         sport2.backgroundColor = UIColor.purple
        let sport3 = sp_getLabel(text: "游泳池 3")
        sport3.backgroundColor = UIColor.purple
        let sport4 = sp_getLabel(text: "游泳池 4")
        sport4.backgroundColor = UIColor.purple
        
        sport1.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung4.snp.centerX).offset(0)
            maker.centerY.equalTo(tung13.snp.centerY).offset(0)
            maker.width.height.equalTo(tung4).offset(0)
        }
        sport2.snp.makeConstraints { (maker) in
            maker.width.height.centerX.equalTo(sport1).offset(0)
            maker.centerY.equalTo(tung9.snp.centerY).offset(0)
        }
        sport3.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
            maker.centerY.equalTo(tung2.snp.centerY).offset(0)
            maker.width.height.equalTo(sport1).offset(0)
        }
        sport4.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
            maker.centerY.equalTo(tung3.snp.centerY).offset(0)
            maker.width.height.equalTo(sport1).offset(0)
        }
    }
    //MARK: - base1
    fileprivate func sp_setupBase1SubView(){
        let lWidth = 40 * scale
        let lHeight = 40 * scale
        let space : CGFloat = 0 * scale
        let greenSpace = 1.5 * scale
        let sidewalkSpace = 4 * scale
        let malu1 = sp_getLabel(text: "两条马路", view: self.baseView1)
        malu1.backgroundColor = UIColor.blue
        malu1.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.baseView1).offset(0)
            maker.width.equalTo(8 * scale)
        }
        
        let malu2 = sp_getLabel(text: "一条马路", view: self.baseView1)
        malu2.backgroundColor = UIColor.blue
        malu2.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.baseView1).offset(0)
            maker.height.equalTo(4 * scale)
        }
        
        let parkLu1 = sp_getLabel(text: "停车场西入口路1", view: self.baseView1)
        parkLu1.backgroundColor = UIColor.blue
        parkLu1.snp.makeConstraints { (maker) in
            maker.left.equalTo(malu1.snp.right).offset(0)
            maker.height.equalTo(5 * scale)
            maker.top.right.equalTo(self.baseView1)
        }
        
        let parkLu2 = sp_getLabel(text: "停车场北入口路2", view: self.baseView1)
        parkLu2.backgroundColor = UIColor.blue
        parkLu2.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.baseView1).offset(0)
            maker.top.equalTo(parkLu1.snp.bottom).offset(0)
            maker.bottom.equalTo(malu2.snp.top).offset(0)
            maker.width.equalTo(5 * scale)
        }
        
        let leisure1 = sp_getLabel(text: "休闲地方1", view: self.baseView1)
        leisure1.backgroundColor = UIColor.purple
        leisure1.snp.makeConstraints { (maker) in
            maker.left.equalTo(malu1.snp.right).offset(0)
            maker.top.equalTo(parkLu1.snp.bottom).offset(0)
            maker.bottom.equalTo(malu2.snp.top).offset(0)
            maker.width.equalTo(15 * scale)
        }
        
        let leisure2 = sp_getLabel(text: "休闲地方2", view: self.baseView1)
        leisure2.backgroundColor = UIColor.purple
        leisure2.snp.makeConstraints { (maker) in
            maker.left.equalTo(leisure1.snp.right).offset(0)
            maker.right.equalTo(parkLu2.snp.left).offset(0)
            maker.bottom.equalTo(malu2.snp.top).offset(0)
            maker.height.equalTo(15 * scale)
        }
        
        let tung1 = sp_getLabel(text: "1栋", view: self.baseView1,tag: 1)
        tung1.backgroundColor = UIColor.blue
        tung1.snp.makeConstraints { (maker) in
            maker.left.equalTo(leisure1.snp.right).offset((20 + 12) * scale)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(parkLu1.snp.bottom).offset(11 * scale)
        }
        
        let tung2 = sp_getLabel(text: "2栋", view: self.baseView1,tag: 2)
        tung2.backgroundColor = UIColor.blue
        tung2.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung1.snp.right).offset(lWidth + space)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung1.snp.top).offset(0)
        }
        
        let tung3 = sp_getLabel(text: "3栋", view: self.baseView1,tag: 3)
        tung3.backgroundColor = UIColor.blue
        tung3.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung2.snp.right).offset(lWidth + space)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung1.snp.top).offset(0)
        }
        
        let tung4 = sp_getLabel(text: "4栋", view: self.baseView1,tag: 4)
        tung4.backgroundColor = UIColor.blue
        tung4.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung3.snp.right).offset(lWidth + space)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung1.snp.top).offset(0)
        }
        let vSpace = 4.6 * scale
        let tung5 = sp_getLabel(text: "5栋", view: self.baseView1,tag: 5)
        tung5.backgroundColor = UIColor.blue
        tung5.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung4.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung4.snp.bottom).offset(lHeight + vSpace)
        }
        
        let tung6 = sp_getLabel(text: "6栋", view: self.baseView1,tag: 6)
        tung6.backgroundColor = UIColor.blue
        tung6.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung4.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung5.snp.bottom).offset(lHeight + vSpace)
        }
        
        let tung7 = sp_getLabel(text: "7栋", view: self.baseView1,tag: 7)
        tung7.backgroundColor = UIColor.blue
        tung7.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung4.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung6.snp.bottom).offset(lHeight + vSpace)
        }
        
        let tung8 = sp_getLabel(text: "8栋", view: self.baseView1,tag: 8)
        tung8.backgroundColor = UIColor.blue
        tung8.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung4.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung7.snp.bottom).offset(lHeight + vSpace)
        }
        
        let tung9 = sp_getLabel(text: "9栋", view: self.baseView1,tag: 9)
        tung9.backgroundColor = UIColor.blue
        tung9.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung4.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung8.snp.bottom).offset(lHeight + vSpace)
        }
     
        let tung10 = sp_getLabel(text: "10栋", view: self.baseView1,tag: 10)
        tung10.backgroundColor = UIColor.blue
        tung10.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung3.snp.centerX).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung9.snp.top).offset(0)
        }
        
        let tung11 = sp_getLabel(text: "11栋", view: self.baseView1,tag: 11)
        tung11.backgroundColor = UIColor.blue
        tung11.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung2.snp.centerX).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung9.snp.top).offset(0)
        }
        let tung12 = sp_getLabel(text: "12栋", view: self.baseView1,tag: 12)
        tung12.backgroundColor = UIColor.blue
        tung12.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung9.snp.top).offset(0)
        }
        
        let tung13 = sp_getLabel(text: "13栋", view: self.baseView1,tag: 13)
        tung13.backgroundColor = UIColor.blue
        tung13.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung8.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
        }
        
        let tung14 = sp_getLabel(text: "14栋", view: self.baseView1,tag: 14)
        tung14.backgroundColor = UIColor.blue
        tung14.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung7.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
        }
        
        let tung15 = sp_getLabel(text: "15栋", view: self.baseView1,tag: 15)
        tung15.backgroundColor = UIColor.blue
        tung15.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung6.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
        }
        
        let tung16 = sp_getLabel(text: "16栋", view: self.baseView1,tag: 16)
        tung16.backgroundColor = UIColor.blue
        tung16.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung5.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung1.snp.centerX).offset(0)
        }
        
        let tung17 = sp_getLabel(text: "17栋", view: self.baseView1,tag: 17)
        tung17.backgroundColor = UIColor.blue
        tung17.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung5.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.left.equalTo(tung2.snp.right).offset(space / 2.0)
        }
        
        let tung18 = sp_getLabel(text: "18栋", view: self.baseView1,tag: 18)
        tung18.backgroundColor = UIColor.blue
        tung18.snp.makeConstraints { (maker) in
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung17.snp.centerX).offset(0)
            maker.top.equalTo(tung15.snp.bottom).offset(vSpace / 2.0)
        }
        
        let tung19 = sp_getLabel(text: "19栋", view: self.baseView1,tag: 19)
        tung19.backgroundColor = UIColor.blue
        tung19.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tung8.snp.centerY).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerX.equalTo(tung17.snp.centerX).offset(0)
        }
        
        let tung20 = sp_getLabel(text: "20栋", view: self.baseView1,tag: 20)
        tung20.backgroundColor = UIColor.blue
        tung20.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung18.snp.left).offset(-20 * scale)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.bottom.equalTo(tung19.snp.top).offset( -(lHeight + vSpace) / 3.0)
        }
        
        let tung21 = sp_getLabel(text: "21栋", view: self.baseView1,tag: 21)
        tung21.backgroundColor = UIColor.blue
        tung21.snp.makeConstraints { (maker) in
            maker.right.equalTo(tung20.snp.right).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.top.equalTo(tung17.snp.bottom).offset((lHeight + vSpace) / 3.0)
        }
        
        let tung22 = sp_getLabel(text: "22栋", view: self.baseView1,tag: 22)
        tung22.backgroundColor = UIColor.blue
        tung22.snp.makeConstraints { (maker) in
           maker.left.equalTo(tung18.snp.right).offset(20 * scale)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung20.snp.centerY).offset(0)
        }
        
        let tung23 = sp_getLabel(text: "23栋", view: self.baseView1,tag: 23)
        tung23.backgroundColor = UIColor.blue
        tung23.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung22.snp.left).offset(0)
            maker.width.equalTo(lWidth)
            maker.height.equalTo(lHeight)
            maker.centerY.equalTo(tung21.snp.centerY).offset(0)
        }
        let singleRoadSpace = 4 * scale
        let doubleRoadSpace = 2  * singleRoadSpace
        let roadAndTungSpace = 6 * scale
        let road1 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road1.snp.makeConstraints { (maker) in
            maker.right.equalTo(parkLu2.snp.left).offset(-2 * scale)
            maker.height.equalTo(doubleRoadSpace)
            maker.top.equalTo(tung1.snp.bottom).offset(roadAndTungSpace)
            maker.left.equalTo(tung1.snp.left).offset(-greenSpace)
        }
        
        let road2 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road2.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(road1).offset(0)
            maker.height.equalTo(doubleRoadSpace)
            maker.bottom.equalTo(tung12.snp.top).offset(-roadAndTungSpace)
        }
        
        let road3 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road3.snp.makeConstraints { (maker) in
            maker.top.equalTo(road1.snp.bottom).offset(0)
            maker.bottom.equalTo(road2.snp.top).offset(0)
            maker.width.equalTo(doubleRoadSpace)
            maker.left.equalTo(tung16.snp.right).offset(roadAndTungSpace)
        }
        
        let road4 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road4.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.left.equalTo(tung21.snp.right).offset(roadAndTungSpace)
        }
        
        let road5 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road5.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.right.equalTo(tung23.snp.left).offset(-roadAndTungSpace)
        }
        
        let road6 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road6.snp.makeConstraints { (maker) in
            maker.top.bottom.width.equalTo(road3).offset(0)
            maker.right.equalTo(tung6.snp.left).offset(-roadAndTungSpace)
        }
        
        let road7 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road7.snp.makeConstraints { (maker) in
            maker.right.equalTo(parkLu2.snp.left).offset(0)
            maker.height.equalTo(doubleRoadSpace + doubleRoadSpace)
            maker.width.equalTo(doubleRoadSpace + doubleRoadSpace)
            maker.top.equalTo(tung6.snp.bottom).offset((lHeight + space - doubleRoadSpace - doubleRoadSpace) / 2.0)
        }
        
        let road8 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road8.snp.makeConstraints { (maker) in
            maker.right.equalTo(road1.snp.right).offset(0)
            maker.top.equalTo(road1.snp.bottom).offset(0)
            maker.width.equalTo(doubleRoadSpace)
            maker.bottom.equalTo(road7.snp.top).offset(0)
        }
        
        let road9 = sp_getView(color: UIColor.white, supView: self.baseView1)
        road9.snp.makeConstraints { (maker) in
            maker.top.equalTo(road7.snp.bottom).offset(0)
            maker.bottom.equalTo(road2.snp.top).offset(0)
            maker.width.equalTo(doubleRoadSpace)
            maker.right.equalTo(road2.snp.right).offset(0)
        }
        
        let tung24 = sp_getLabel(text: "商铺1", view: self.baseView1)
        tung24.backgroundColor = UIColor.orange
        tung24.snp.makeConstraints { (maker) in
            maker.left.equalTo(leisure1.snp.right).offset(0)
            maker.top.equalTo(parkLu1.snp.bottom).offset(0)
            maker.bottom.equalTo(leisure2.snp.top).offset(0)
            maker.width.equalTo(20  * scale)
        }
        let tung25 = sp_getLabel(text: "商铺2",view: self.baseView1)
        tung25.backgroundColor = UIColor.orange
        tung25.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung24.snp.right).offset(0)
            maker.bottom.equalTo(leisure2.snp.top).offset(0)
            maker.right.equalTo(parkLu2.snp.left).offset(0)
            maker.height.equalTo(20 * scale)
        }
        
     
        
        for i in 1...23 {
            let view = self.baseView1.viewWithTag(i + K_TUNF_TAG)
            if let v = view {
                sp_setupGreenView(reference: v, position: 0,stretchSpace: greenSpace)
                sp_setupGreenView(reference: v, position: 1)
                sp_setupGreenView(reference: v, position: 2,stretchSpace: greenSpace)
                sp_setupGreenView(reference: v, position: 3)
               
                
            }
        }
        sp_setupGreenView(reference: road1, position: 0)
        sp_setupGreenView(reference: road1, position: 2)
        sp_setupGreenView(reference: road2, position: 0)
        sp_setupGreenView(reference: road2, position: 2)
        sp_setupGreenView(reference: road3, position: 1)
        sp_setupGreenView(reference: road3, position: 3)
        sp_setupGreenView(reference: road4, position: 1)
        sp_setupGreenView(reference: road4, position: 3)
        sp_setupGreenView(reference: road5, position: 1)
        sp_setupGreenView(reference: road5, position: 3)
        sp_setupGreenView(reference: road6, position: 1)
        sp_setupGreenView(reference: road6, position: 3)
        sp_setupGreenView(reference: road8, position: 3)
        sp_setupGreenView(reference: road9, position: 3)
        sp_setupGreenView(reference: road7, position: 3)
        sp_setupGreenView(reference: tung24, position: 1)
        for i in 1...23 {
            let view = self.baseView1.viewWithTag(i + K_TUNF_TAG)
            if let v = view {
                sp_setupSidewalkView(reference: v, position: 0, stretchSpace: sidewalkSpace + greenSpace, space: greenSpace, size: sidewalkSpace)
                sp_setupSidewalkView(reference: v, position: 1, stretchSpace: sidewalkSpace, space: greenSpace, size: sidewalkSpace)
                sp_setupSidewalkView(reference: v, position: 2, stretchSpace: sidewalkSpace + greenSpace, space: greenSpace, size: sidewalkSpace)
                sp_setupSidewalkView(reference: v, position: 3, stretchSpace: sidewalkSpace, space: greenSpace, size: sidewalkSpace)
            }
        }
        sp_setupSidewalkView(reference: road1, position: 0, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road1, position: 2, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road2, position: 0, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road2, position: 2, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road3, position: 1, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road3, position: 3, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road4, position: 1, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road4, position: 3, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road5, position: 1, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road5, position: 3, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road6, position: 1, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
        sp_setupSidewalkView(reference: road6, position: 3, stretchSpace: 0, space: greenSpace, size: sidewalkSpace)
    }
 
    
    /// 设置绿化的地方  0 参照位置上方 1 参照位置右 2 参照位置下 3 参照位置
    ///
    /// - Parameters:
    ///   - reference: 参照view
    ///   - position:  0 参照位置上方 1 参照位置右 2 参照位置下 3 参照位置
    ///   - stretchSpace: 是否往外伸
    fileprivate func sp_setupGreenView(reference : UIView, position : Int,stretchSpace : CGFloat = 0){
        let greenSpace = 1.5 * scale
        let greenView = sp_getView(color: sp_getGreenViewColor(), supView: self.baseView1)
        greenView.snp.makeConstraints { (maker) in
            if position == 0 || position == 2 {
                maker.height.equalTo(greenSpace)
                maker.left.equalTo(reference).offset(-stretchSpace)
                maker.right.equalTo(reference).offset(stretchSpace)
                if position == 0 {
                    maker.bottom.equalTo(reference.snp.top).offset(0)
                }else{
                    maker.top.equalTo(reference.snp.bottom).offset(0)
                }
            }else{
                maker.width.equalTo(greenSpace)
                maker.top.equalTo(reference).offset(-stretchSpace)
                maker.bottom.equalTo(reference).offset(stretchSpace)
                if position == 1 {
                    maker.left.equalTo(reference.snp.right).offset(0)
                }else{
                    maker.right.equalTo(reference.snp.left).offset(0)
                }
            }
        }
        self.baseView1.sendSubview(toBack: greenView)
    }
    /// 创建路  0 参照位置上方 1 参照位置右 2 参照位置下 3 参照位置
    ///
    /// - Parameters:
    ///   - reference: 参照view
    ///   - position:  0 参照位置上方 1 参照位置右 2 参照位置下 3 参照位置
    ///   - stretchSpace: 伸缩距离
    ///   - space: 距离参照位置的距离
    ///   - size: 宽度或高度
    fileprivate func sp_setupSidewalkView(reference : UIView,position : Int,stretchSpace : CGFloat = 0,space : CGFloat,size : CGFloat){
        let view = sp_getView(color: UIColor.yellow, supView: self.baseView1)
        view.snp.makeConstraints { (maker) in
            if position == 0 || position == 2{
                maker.height.equalTo(size)
                maker.left.equalTo(reference).offset(-stretchSpace)
                maker.right.equalTo(reference).offset(stretchSpace)
                if position == 0 {
                    maker.bottom.equalTo(reference.snp.top).offset(-space)
                }else{
                    maker.top.equalTo(reference.snp.bottom).offset(space)
                }
            }else{
                maker.width.equalTo(size)
                maker.top.equalTo(reference).offset(-stretchSpace)
                maker.bottom.equalTo(reference).offset(stretchSpace)
                if position == 1 {
                    maker.left.equalTo(reference.snp.right).offset(space)
                }else{
                    maker.right.equalTo(reference.snp.left).offset(-space)
                }
            }
        }
         self.baseView1.sendSubview(toBack: view)
    }
    //MARK: - office
    fileprivate func sp_setupOfficeSubView(){
        let maSpace = 4 * scale
        let malu1 = sp_getOfficeLabel(text: "一条马路")
        malu1.backgroundColor = UIColor.blue
        malu1.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.officeView).offset(0)
            maker.top.equalTo(self.officeView).offset(0)
            maker.height.equalTo(maSpace)
        }
        let malu2 = sp_getOfficeLabel(text: "一条马路")
        malu2.backgroundColor = UIColor.blue
        malu2.snp.makeConstraints { (maker) in
            maker.top.bottom.right.equalTo(self.officeView).offset(0)
            maker.width.equalTo(maSpace)
        }
        let malu3 = sp_getOfficeLabel(text: "一条马路")
        malu3.backgroundColor = UIColor.blue
        malu3.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.officeView).offset(0)
            maker.height.equalTo(maSpace)
        }
        
        let tung1 = sp_getOfficeLabel(text: "宿舍")
        tung1.backgroundColor = UIColor.blue
        tung1.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.officeView).offset(6 * scale)
            maker.top.equalTo(malu1.snp.bottom).offset(8 * scale)
            maker.width.equalTo(20 * scale)
            maker.height.equalTo(50  * scale)
        }
        
        let office1 = sp_getOfficeLabel(text: "办公楼1")
        office1.backgroundColor = UIColor.blue
        office1.snp.makeConstraints { (maker) in
            maker.left.equalTo(tung1.snp.left).offset(0)
            maker.right.equalTo(malu2.snp.left).offset(-12 * scale)
            maker.top.equalTo(tung1.snp.bottom).offset(20 * scale)
            maker.bottom.equalTo(malu3.snp.top).offset(-12 * scale)
        }
        
        let office2 = sp_getOfficeLabel(text: "办公楼2")
        office2.backgroundColor = UIColor.blue
        office2.snp.makeConstraints { (maker) in
            maker.top.equalTo(tung1.snp.top).offset(0)
            maker.right.equalTo(office1.snp.right).offset(0)
            maker.bottom.equalTo(office1.snp.top).offset(0)
            maker.left.equalTo(tung1.snp.right).offset(10 * scale)
        }
    }
    fileprivate func sp_getGreenViewColor()->UIColor{
        return UIColor.green
    }
    
    fileprivate func sp_getLabel(text : String,view : UIView? = nil,tag : Int = 0)-> UILabel{
        let label = UILabel()
        label.text = text
        label.font = sp_getFontSize(size: 6)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.tag = K_TUNF_TAG + tag
        label.isUserInteractionEnabled = true
        if let v = view {
            v.addSubview(label)
        }else{
             self.baseView.addSubview(label)
        }
       
        return label
    }
    fileprivate func sp_getView(color : UIColor = UIColor.white,supView : UIView? = nil)->UIView{
        let view = UIView()
        view.backgroundColor = color
        if let v = supView {
            v.addSubview(view)
        }else{
             self.baseView.addSubview(view)
        }
       
        return view
    }
    
    fileprivate func sp_getOfficeLabel(text : String)-> UILabel{
        let label = UILabel()
        label.text = text
        label.font = sp_getFontSize(size: 6)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        self.officeView.addSubview(label)
        return label
    }
    
    
    
    
    @objc fileprivate func sp_clickTap(){
        SPLog("点击保存图片")
//        let img = UIImage.sp_img(of: self.scrollView)
//        SPLog(img?.size)
//        if let i = img {
//            UIImageWriteToSavedPhotosAlbum(i, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
//        }
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
    {
        if let e = error as NSError?
        {
            print(e)
        }
        else
        {
            UIAlertController.init(title: nil,
                                   message: "保存成功！",
                                   preferredStyle: UIAlertControllerStyle.alert).show(self, sender: nil);
        }
    }
}
