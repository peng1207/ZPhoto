//
//  SPVideoSplicingHelp.swift
//  ZPhoto
//
//  Created by 黄树鹏 on 2019/9/9.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import AVFoundation
import SPCommonLibrary
class SPVideoSplicingHelp {
    
    /// 视频拼接
    ///
    /// - Parameters:
    ///   - videoModelList: video 数组
    ///   - type: 类型
    ///   - outputPath: 新的视频路径
    ///   - complete: 回调
    class func sp_splicing(videoModelList : [SPVideoModel]?,type : SPVideoSplicingType,outputPath : String,complete:@escaping SPExportSuccess){
        guard let list = videoModelList else {
            sp_dealComplete(asset: nil, filePath: "", complete: complete)
            return
        }
        guard list.count > 1 else {
            let model = list.first
            sp_dealComplete(asset: model?.asset, filePath: sp_getString(string: model?.url?.path), complete: complete)
            return
        }
        sp_remove(path: outputPath)
        var assetList = [AVAsset]()
        for model in list {
            if let asset = model.asset {
                assetList.append(asset)
            }
        }
        switch type {
        case .none:
            SPVideoHelp.sp_mergeVideos(videoAsset: assetList, outputPath: outputPath, exportSuuccess: complete)
            
        default:
            sp_videoSplicing(videoAssets: assetList, outputPath: outputPath, type: type, complete: complete)
        }
    }
    
    struct SPVideoReaderStruct {
        var assetReader : AVAssetReader?
        var readerOutput : AVAssetReaderTrackOutput?
        var lastBuffer : CMSampleBuffer?
    }
    
    
    private class func sp_videoSplicing(videoAssets : [AVAsset],outputPath : String,type : SPVideoSplicingType,complete: @escaping SPExportSuccess){
        let size = sp_screenPixels()
        let videoPath = "\(kVideoTempDirectory)/videoTemp.mp4"
        
        sp_remove(path: videoPath)
        
        let videoData = sp_assetWirter(size: size, outputPath: videoPath,isVideo: true,isAudio: false)
        if let videoAssetWriter = videoData.assetWriter {
            sp_sync(queueName: "VideoSplicingQueue") {
                var sampleBufferList = [SPVideoSampleBuffer]()
                var selectTime = 0
                var lastCount = 0
                var i = 0
                var lastSecond : Float64 = 0
                
                
                var assetReaderList = [SPVideoReaderStruct]()
                
                for asset in videoAssets {
                    let assetReader = try! AVAssetReader(asset: asset)
                    if let videoTrack = asset.tracks(withMediaType: .video).first {
                        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)])
                        if assetReader.canAdd(readerOutput){
                            assetReader.add(readerOutput)
                            let s = SPVideoReaderStruct(assetReader: assetReader, readerOutput: readerOutput, lastBuffer: nil)
                            assetReaderList.append(s)
                            assetReader.startReading()
                            if lastSecond <  CMTimeGetSeconds(asset.duration) {
                                lastSecond = CMTimeGetSeconds(asset.duration)
                                selectTime = i
                            }
                        }
                    }
                    i = i + 1
                    //
                    //
                    //                    let data = SPVideoHelp.sp_videoBuffer(asset: asset)
                    //                    sampleBufferList.append(data)
                    //                    if lastCount < sp_count(array: data.videoBuffers) {
                    //                        lastCount = sp_count(array: data.videoBuffers)
                    //                        selectTime = i
                    //                    }
                    //
                }
                videoAssetWriter.startWriting()
                videoAssetWriter.startSession(atSourceTime: CMTime.zero)
                var index = 0
                autoreleasepool {
                    
                }
                while true {
                    
                    var imageList = [UIImage]()
                    var time = CMTime(value: 0, timescale: 0)
                    var outIndex : Int = 0
                    var j = 0
                    var canCopy : Bool = false
                    for readerStruct in assetReaderList {
                        if let assetReader = readerStruct.assetReader , let readerOutput = readerStruct.readerOutput {
                            var sampleBuffer : CMSampleBuffer?
                            if let buffer = readerOutput.copyNextSampleBuffer(){
                                canCopy = true
                                sampleBuffer = buffer
                                var tmpReaderStruct = readerStruct
                                tmpReaderStruct.lastBuffer = buffer
                                assetReaderList[j] = tmpReaderStruct
                            }else{
                                sampleBuffer = readerStruct.lastBuffer
                                assetReader.cancelReading()
                            }
                            if let buffer = sampleBuffer {
                                if j == selectTime {
                                    time = CMSampleBufferGetPresentationTimeStamp(buffer)
                                }
                                if let imageBuffer = CMSampleBufferGetImageBuffer(buffer){
                                    let outputImg = CIImage(cvPixelBuffer: imageBuffer)
                                    if let ciImg = UIImage.sp_picRotating(imgae: outputImg){
                                        imageList.append( UIImage(ciImage: ciImg))
                                    }
                                }
                            }
                        }
                        j = j + 1
                    }
                    if !canCopy {
                        break
                    }
                    
                    
                    //                    for dataBuffer in sampleBufferList {
                    //                        if index < sp_count(array: dataBuffer.videoBuffers), let buffer = dataBuffer.videoBuffers?[index]{
                    //                            if let imageBuffer = CMSampleBufferGetImageBuffer(buffer) {
                    //                                let outputImg = CIImage(cvPixelBuffer: imageBuffer)
                    //                                if let ciImg = UIImage.sp_picRotating(imgae: outputImg){
                    //                                    imageList.append( UIImage(ciImage: ciImg))
                    //                                }
                    //                            }
                    //                            if selectTime == j {
                    //                                time = CMSampleBufferGetPresentationTimeStamp(buffer)
                    //                            }
                    //                        }else{
                    //                            if let buffer = dataBuffer.videoBuffers?.last{
                    //                                if let imageBuffer = CMSampleBufferGetImageBuffer(buffer) {
                    //                                    let outputImg = CIImage(cvPixelBuffer: imageBuffer)
                    //                                    if let ciImg = UIImage.sp_picRotating(imgae: outputImg){
                    //                                        imageList.append( UIImage(ciImage: ciImg))
                    //                                    }
                    //                                }
                    //                                if selectTime == j {
                    //                                    time = CMSampleBufferGetPresentationTimeStamp(buffer)
                    //                                }
                    //                            }
                    //                            outIndex = outIndex + 1
                    //                        }
                    ////                        if index < sp_count(array: dataBuffer.audioBuffers), let buffer = dataBuffer.audioBuffers?[index]{
                    ////                            audioSampleBuffer.append(buffer)
                    ////                        }
                    //                        j = j + 1
                    //                    }
                    //                    if outIndex == sampleBufferList.count {
                    //                        break
                    //                    }
                    
                    let newImg = sp_draw(images: imageList, size: size, type: type)
                    if let cgImg = newImg?.cgImage {
                        if let videoWriterInput = videoData.videoWirterInput , let videoAdaptor = videoData.videoPixelBufferAdaptor {
                            var newPiexlBuffer = UIImage.sp_pixelBuffer(fromImage: cgImg, pixelBufferPool: nil, pixelFormatType: kCVPixelFormatType_32BGRA, pixelSize: size)
                            sp_writer(video: videoWriterInput, bufferAdaptor: videoAdaptor, pixelBuffer: newPiexlBuffer, time: time)
                            newPiexlBuffer = nil
                        }
                    }
                    
                    index = index + 1
                }
                
                if let videoWriterInput = videoData.videoWirterInput {
                    videoWriterInput.markAsFinished()
                }
                let group = DispatchGroup()
                group.enter()
                videoAssetWriter.finishWriting {
                    sp_log(message: "视频错误 \(videoAssetWriter.error)")
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    let videoAsset = AVAsset(url: URL(fileURLWithPath: videoPath))
                    SPVideoHelp.sp_videoAsset(asset: videoAsset, audioAssets: videoAssets, outputPath: outputPath, complete: complete)
                    sp_log(message: "写入成功")
                }
            }
            
        }
    }
    private class func sp_draw(images: [UIImage],size : CGSize,type:SPVideoSplicingType)->UIImage?{
        guard images.count > 0 else {
            return  nil
        }
        UIGraphicsBeginImageContext(size)
        var index = 0
        switch type {
        case .two_vertical:
            for img in images{
                img.draw(in: CGRect(x: 0, y: size.height / 2.0 * CGFloat(index), width: size.width, height: size.height / 2.0 ))
                index = index + 1
            }
        case .two_cover:
            let img = images[0]
            img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let w = size.width / 4.0
            images.last?.draw(in: CGRect(x: size.width - w - 10, y: 10, width: w, height: w))
        case .three_top:
            for img in images {
                if index == 0 {
                    img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height / 2.0))
                }else{
                    img.draw(in: CGRect(x: size.width / 2.0 * CGFloat(index - 1), y: size.height / 2.0, width: size.width / 2.0, height: size.height / 2.0))
                }
                index = index + 1
            }
        case .three_bottom:
            for img in images {
                if index == 2 {
                    img.draw(in: CGRect(x: 0, y:  size.height / 2.0, width: size.width, height: size.height / 2.0))
                }else{
                    img.draw(in: CGRect(x: size.width / 2.0 * CGFloat(index - 1), y: 0 , width: size.width / 2.0, height: size.height / 2.0))
                }
                index = index + 1
            }
        case .four:
            let w = size.width / 2.0
            let h = size.height / 2.0
            for img in images {
                img.draw(in: CGRect(x: w *  CGFloat(index % 2), y: h * CGFloat(index / 2), width: w, height: h))
                index = index + 1
            }
        case .five:
            let w = size.width / 2.0
            let h = size.height / 2.0
            for i in 0..<4{
                let img = images[i]
                img.draw(in: CGRect(x: w *  CGFloat(i % 2), y: h * CGFloat(i / 2), width: w, height: h))
            }
            images.last?.draw(in: CGRect(x: (size.width - w) / 2.0, y: (size.height - w) / 2.0, width: w, height: w))
        case .six:
            let w = size.width / 2.0
            let h = size.height / 3.0
            for img in images{
                img.draw(in: CGRect(x: w * CGFloat(index % 2), y: h * CGFloat(index / 2), width: w, height: h))
                index = index + 1
            }
        case .six_pyramid:
            let h = size.height / 3.0
            for img in images {
                if index == 0 {
                    img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: h))
                }else if index < 3{
                    let w = size.width / 2.0
                    img.draw(in: CGRect(x: w * CGFloat(index - 1), y: h, width: w, height: h))
                }else{
                    let w = size.width / 3.0
                    img.draw(in: CGRect(x: w * CGFloat(index - 3), y: size.height - h, width: w, height: h))
                }
                index = index + 1
            }
        case .seven:
            let h = size.height / 3.0
            for img in images {
                if index < 4 {
                    let w = size.width / 2.0
                    img.draw(in: CGRect(x: w * CGFloat(index % 2), y: h * CGFloat(index / 2), width: w, height: h))
                }else {
                    let w = size.width / 3.0
                    img.draw(in: CGRect(x: w * CGFloat(index - 4), y: size.height - h, width: w, height: h))
                }
                index = index + 1
            }
        case .eight:
            let h = size.height / 3.0
            var w = size.width / 3.0
            for img in images {
                if index < 2 {
                    w = size.width / 2.0
                    img.draw(in: CGRect(x: w * CGFloat(index), y: 0, width: w, height: h))
                }else {
                    img.draw(in: CGRect(x: w * CGFloat( (index - 2) % 3), y: h + h * CGFloat( (index - 2) / 3), width: w, height: h))
                }
                index = index + 1
            }
        case .nine:
            let w = size.width / 3.0
            let h = size.height / 3.0
            for img in images{
                img.draw(in: CGRect(x: w * CGFloat(index % 3), y: h * CGFloat(index / 3), width: w, height: h))
                index = index + 1
            }
        default:
            sp_log(message: "")
        }
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    private class func sp_assetWirter(size : CGSize,outputPath : String,isVideo : Bool = true , isAudio : Bool = true)->(assetWriter : AVAssetWriter?,videoWirterInput : AVAssetWriterInput?,audioWriterInput : AVAssetWriterInput?,videoPixelBufferAdaptor : AVAssetWriterInputPixelBufferAdaptor?){
        
        do{
            let assetWriter = try AVAssetWriter(url: URL(fileURLWithPath: outputPath), fileType: isVideo ? AVFileType.mp4 : AVFileType.wav)
            var videoWriter : AVAssetWriterInput?
            var videoPixelBuffer : AVAssetWriterInputPixelBufferAdaptor?
            if isVideo {
                let videoOutputSettings : [String : Any]
                
                
                if #available(iOS 11.0, *) {
                    videoOutputSettings = [AVVideoCodecKey : AVVideoCodecHEVC,
                                           AVVideoWidthKey : size.width,
                                           AVVideoHeightKey : size.height,
                    ]
                } else {
                    // Fallback on earlier versions
                    videoOutputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                           AVVideoWidthKey : size.width,
                                           AVVideoHeightKey : size.height,
                    ]
                }
                let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
                videoWriterInput.expectsMediaDataInRealTime = false
                let sourcePixelBufferAttributesDictionary = [
                    String(kCVPixelBufferPixelFormatTypeKey) : kCVPixelFormatType_32BGRA,
                    String(kCVPixelBufferWidthKey) : size.width,
                    String(kCVPixelBufferHeightKey) : size.height ,
                    String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue
                    ] as [String : Any]
                let videoWriterInoutPixelBuffer = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
                
                
                if assetWriter.canAdd(videoWriterInput) {
                    videoWriter = videoWriterInput
                    videoPixelBuffer = videoWriterInoutPixelBuffer
                    assetWriter.add(videoWriterInput)
                }
                
            }
            var audioWriter : AVAssetWriterInput?
            if isAudio {
                //                let audioSetting: [String: AnyObject] = [
                //                    AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                //                    AVNumberOfChannelsKey: 1 as AnyObject,
                //                    AVSampleRateKey: 22050 as AnyObject
                //                ]
                
                let audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
                audioWriterInput.expectsMediaDataInRealTime = true
                if assetWriter.canAdd(audioWriterInput){
                    audioWriter = audioWriterInput
                    assetWriter.add(audioWriterInput)
                }
            }
            
            return (assetWriter,videoWriter,audioWriter,videoPixelBuffer)
            
        }catch _{
            return (nil,nil,nil,nil)
        }
    }
    /// 写入音频数据
    ///
    /// - Parameters:
    ///   - writerInput: 输入源
    ///   - sampleBuffer: 音频数据
    private class func sp_writer(audio writerInput : AVAssetWriterInput,sampleBuffer: CMSampleBuffer? ){
        sp_log(message: "进入写音频")
        if let buffer = sampleBuffer {
            while !writerInput.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.1)
            }
            writerInput.append(buffer)
        }
        sp_log(message: "退出写音频")
    }
    /// 写入视频数据
    ///
    /// - Parameters:
    ///   - writerInput: 输入源
    ///   - bufferAdaptor: 输入源
    ///   - pixelBuffer: 视频数据
    ///   - time: 时间
    private class func sp_writer(video writerInput : AVAssetWriterInput,bufferAdaptor: AVAssetWriterInputPixelBufferAdaptor,pixelBuffer:CVPixelBuffer?, time :CMTime?){
        
        guard let buffer = pixelBuffer else {
            return
        }
        guard let t = time else {
            return
        }
        
        while !writerInput.isReadyForMoreMediaData {
            Thread.sleep(forTimeInterval: 0.1)
        }
        bufferAdaptor.append(buffer, withPresentationTime: t)
        
    }
    /// 处理回调
    ///
    /// - Parameters:
    ///   - asset: 视频数据
    ///   - filePath: 导出路径
    ///   - complete: 回调
    fileprivate class func sp_dealComplete(asset : AVAsset?,filePath : String,complete:@escaping SPExportSuccess){
        sp_mainQueue {
            complete(asset,filePath)
        }
        
    }
    /// 删除文件
    ///
    /// - Parameter path: 文件路径
    private class func sp_remove(path : String){
        FileManager.sp_directory(createPath:kVideoTempDirectory)
        if FileManager.default.fileExists(atPath: path) {
            FileManager.remove(path: path)
        }
    }
}
