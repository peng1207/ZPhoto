//
//  SPVideoEditVC.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/12.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class  SPVideoEditVC : SPBaseVC {
    lazy fileprivate var scheduleView : SPVideoScheduleView! = {
        let view = SPVideoScheduleView()
        return view
    }()
    lazy fileprivate var filter : CIFilter! = {
        return CIFilter.photoEffectNoir()
    }()
    lazy fileprivate var  showImage : UIImageView = {
        return UIImageView()
    }()
    
     var videoModel : SPVideoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.showImage)
        self.showImage.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.view).offset(0)
        }
    
    }
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    self.reader()
    }
    func reader(){
        let asserReader = try! AVAssetReader(asset: (videoModel?.asset)!)
        let videoTrack = videoModel?.asset?.tracks(withMediaType: AVMediaType.video)[0]
        let outputSettings :[String:Any] =  [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        
        let trackOutput = AVAssetReaderTrackOutput(track: videoTrack!, outputSettings: outputSettings)
        if asserReader.canAdd(trackOutput) {
            asserReader.add(trackOutput)
        }
        asserReader.startReading()
        var  nominalFrameRate : Int = 0
          var samples: [CMSampleBuffer] = []
      
//            while let sample = trackOutput.copyNextSampleBuffer() {
//                samples.append(sample)
//                SPLog("\(nominalFrameRate)")
//                nominalFrameRate = nominalFrameRate + 1
//            }
    
            while let sample = trackOutput.copyNextSampleBuffer() {
                SPLog("读取中")
//                var outputImage =  CIImage(cvPixelBuffer: CMSampleBufferGetImageBuffer(sample)!)
//                self.filter.setValue(outputImage, forKey: kCIInputImageKey)
//                outputImage = self.filter.outputImage!
//                SPLog(outputImage)
                Thread.sleep(forTimeInterval: 0.01) 
                samples.append(sample)
                CMSampleBufferInvalidate(sample)
            }
     
       
       
//        while asserReader.status == AVAssetReaderStatus.reading && (videoTrack?.nominalFrameRate)! > nominalFrameRate {
//            autoreleasepool{
//                let videoBuffer = trackOutput.copyNextSampleBuffer()
//
////                var outputImage =  CIImage(cvPixelBuffer: CMSampleBufferGetImageBuffer(videoBuffer!)!)
////                self.filter.setValue(outputImage, forKey: kCIInputImageKey)
////                outputImage = self.filter.outputImage!
////                 CMSampleBufferInvalidate(videoBuffer!)
////                sp_dispatchMainQueue {
////                    self.showImage.image = UIImage(ciImage: outputImage)
////                }
//
//            }
//        }
        asserReader.cancelReading()
        SPLog("读取结束")
    }
    
    deinit {
        
    }
}
// MARK: -- action
extension SPVideoEditVC {
    
    func  playVideo(videoModel:SPVideoModel){
         let videoPalyVC = SPVideoPlayVC()
        videoPalyVC.videoModel = videoModel
        self.navigationController?.pushViewController(videoPalyVC, animated: true)
    }
}
// MARK: -- 通知 观察者
extension SPVideoEditVC {
    
}
// MARK: -- delegate
extension SPVideoEditVC  {
    
}
// MARK: -- UI
extension SPVideoEditVC {
    
}
