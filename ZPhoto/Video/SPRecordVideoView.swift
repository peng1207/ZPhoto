//
//  SPRecordVideoView.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/9/3.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SPRecordVideoView : UIView{
    
    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}



