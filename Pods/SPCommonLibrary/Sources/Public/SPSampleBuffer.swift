//
//  SPSampleBuffer.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/8/2.
//

import Foundation
import UIKit
import AVFoundation
public class SPSampleBuffer {
    
    /// 获取亮度
    /// - Parameter sampleBuffer: 视频流
    public class func sp_brightness(sampleBuffer : CMSampleBuffer)->CGFloat{
        let metadataDic =  CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let metadata = NSDictionary.init(dictionary: metadataDic as! [AnyHashable : Any], copyItems: true)
        let exifMetadata:NSDictionary = NSDictionary.init(dictionary: metadata.object(forKey: kCGImagePropertyExifDictionary as String) as! [AnyHashable : Any], copyItems: true)
        if  let brightnessValue:CGFloat = exifMetadata[kCGImagePropertyExifBrightnessValue] as? CGFloat {
            return brightnessValue
        }
        return 0
    }
    /// 视频流转图片
    /// - Parameter sampleBuffer: 视频流
    public class func sp_image(sampleBuffer : CMSampleBuffer)->UIImage?{
        if  let imgBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
             let ciImg = CIImage(cvImageBuffer: imgBuffer)
            return UIImage(ciImage: ciImg)
        }
        return nil
    }
    
}
