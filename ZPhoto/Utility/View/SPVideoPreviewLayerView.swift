//
//  SPVideoPreviewLayerView.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/2/26.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class SPVideoPreviewLayerView: UIView {
    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
