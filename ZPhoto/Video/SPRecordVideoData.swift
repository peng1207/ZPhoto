//
//  SPRecordVideoData.swift
//  ZPhoto
//
//  Created by okdeer on 2018/3/8.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//

import Foundation
import CoreFoundation
import AVFoundation
import AVKit

class SPRecordVideoData : NSObject {
    fileprivate var filterList : Array<SPFilterModel>? = nil
    
    override init() {
        super.init()
        initFilterData()
    }
    deinit {
        filterList = nil
    }
    /**
     获取滤镜数据
     */
    func getFilterList () ->  Array<SPFilterModel>? {
        return filterList
    }
    func setup(inputImage:CIImage?, complete:(()->Void)?) {
        guard let list = filterList else {
            return
        }
        guard let image = inputImage else{
            return
        }
        
        for model in list{
            model.inputImage = image
        }
        guard let com = complete else {
            return
        }
        com()
       
    }
    /**
     初始化 滤镜数据
     */
    fileprivate func  initFilterData(){
        if filterList == nil {
            filterList = Array()
        }
        filterList?.append(SPFilterModel())
        for filteEnum in SPFilterPhoto.allValues {
            let model = SPFilterModel()
            model.filteEnum = filteEnum
            filterList?.append(model)
        }
    }
    
}
