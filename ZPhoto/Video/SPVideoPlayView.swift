//
//  SPVideoPlayView.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/4.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SPVideoPlayView : UIView{
    
    fileprivate var videoPlayer : AVPlayer?
    fileprivate var videoPlayerItem : AVPlayerItem?
    //定时器
    fileprivate var link : CADisplayLink?
    fileprivate var canRun : Bool = false
    lazy fileprivate var buttonView :SPVideoPlayButtonView? = {
        let button = SPVideoPlayButtonView()
        return button
    }()
    var videoModel : SPVideoModel? {
        didSet{
            videoPlayerItem = AVPlayerItem(asset: (videoModel?.asset)!)
            videoPlayer = AVPlayer(playerItem: videoPlayerItem)
            let layer = self.layer as! AVPlayerLayer
            layer.player = videoPlayer
            layer.videoGravity = AVLayerVideoGravityResize
            
            let second = CMTimeGetSeconds((videoModel?.asset?.duration)!)
            buttonView?.timeLabel.text = formatPlayTime(seconds: second)
            buttonView?.progressView.maximumValue = Float(second)
            self.addVideoObserver()
            self.addAction()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       try!AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        removeObserver()
    }
    override class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
}
// MARK: -- UI
fileprivate extension SPVideoPlayView {
    /**< 创建UI */
    fileprivate func setupUI(){
        self.addSubview(buttonView!)
        buttonView?.snp.makeConstraints({ (maker) in
            maker.left.bottom.right.equalTo(self).offset(0)
            maker.height.equalTo(40)
        })
    }
}
// MARK: -- action
extension SPVideoPlayView {
    /**< 添加事件 */
    fileprivate func addAction(){
        buttonView?.playButton.addTarget(self, action: #selector(playAction), for: UIControlEvents.touchUpInside)
        buttonView?.progressView.addTarget(self, action: #selector(change(silder:)), for: UIControlEvents.valueChanged)
        buttonView?.progressView.addTarget(self, action: #selector(changeEnd(silder:)), for: UIControlEvents.touchUpInside)
    }
    /**< 播放按钮点击事件  */
    @objc fileprivate func playAction(){
        if (buttonView?.playButton.isSelected)! {
            videoPlayer?.pause()
            canRun = false
        }else {
            videoPlayer?.play()
            canRun = true
        }
        buttonView?.playButton.isSelected = !(buttonView?.playButton.isSelected)!
    }
    /**< 滑块值改变的方法 */
    @objc fileprivate func change(silder:UISlider) {
        let seconds  = silder.value
        if seconds == 0.00000{
            videoPlayer?.seek(to: kCMTimeZero, completionHandler: { [weak self](finish : Bool) in
                self?.videoPlayer?.play()
            })
        }
         canRun = false
    }
    /**< 滑块滑动结束 */
    @objc fileprivate func changeEnd(silder:UISlider){
        let seconds  = silder.value
        let targetTime : CMTime = CMTimeMakeWithSeconds(Float64(seconds), 1)
        videoPlayer?.seek(to: targetTime, completionHandler: { [weak self] (finish : Bool) in
            if self?.videoPlayer?.rate == 0{
                self?.videoPlayer?.play()
            }
            self?.buttonView?.playButton.isSelected = true
            self?.canRun = true
        })
        
        
    }
}
// MARK: -- 私有方法
extension SPVideoPlayView{
    //将秒转成时间字符串的方法，因为我们将得到秒。
    fileprivate func formatPlayTime(seconds: Float64)->String{
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    //计算当前的缓冲进度
   fileprivate func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = videoPlayer?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        //本次缓冲时间范围
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)//本次缓冲起始时间
        let durationSecound = CMTimeGetSeconds(timeRange.duration)//缓冲时间
        let result = startSeconds + durationSecound//缓冲总长度
        return result
    }
    /**< 定时器执行 */
    @objc fileprivate func update(){
        if canRun {
            let currentTime = CMTimeGetSeconds((self.videoPlayerItem?.currentTime())!)
            self.buttonView?.progressView.setValue(Float(currentTime), animated: false)
        }
    }
    /**< 停止定时器  */
    func stopTime(){
       self.link?.invalidate()
    }
}

// MARK: -- delegate
extension SPVideoPlayView{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            
        }else if keyPath == "loadedTimeRanges" {
            
        }
    }
    
    
}
// MARK: -- 通知 观察者
extension SPVideoPlayView {
    /**< 播放结束的通知 */
    func playerDidReachEnd(){
        videoPlayer?.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        buttonView?.progressView.setValue(0, animated: true)
        buttonView?.playButton.isSelected = false
    }
    /**< 添加观察者  */
    func addVideoObserver(){
        videoPlayerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        videoPlayerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    /**< 去除观察者 */
    func removeObserver(){
        videoPlayerItem?.removeObserver(self, forKeyPath: "status")
        videoPlayerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayerItem)
        videoPlayerItem = nil
        videoPlayer = nil
    }
}

class SPVideoPlayButtonView : UIView{
    lazy var playButton : UIButton! = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("on", for: UIControlState.normal)
        button.setTitle("off", for: UIControlState.selected)
        return button
    }()
    lazy var timeLabel: UILabel! = {
        let label = UILabel()
        label.text = "00.00"
        label.font = fontSize(fontSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    lazy var progressView : UISlider! = {
        let progress = UISlider()
        let width = 16
        progress.setThumbImage(UIImage.image(color: UIColor.white, imageSize: CGSize(width: width, height: width))?.circle(), for: UIControlState.normal)
        
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**< 创建UI */
    fileprivate func setupUI(){
        self.addSubview(playButton)
        self.addSubview(timeLabel)
        self.addSubview(progressView)
        playButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(5)
            maker.width.equalTo(40)
            maker.height.equalTo(self.snp.height).offset(-10)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-5)
            maker.height.equalTo(self.snp.height).offset(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        progressView.snp.makeConstraints { (maker) in
            maker.left.equalTo(playButton.snp.right).offset(5)
            maker.right.equalTo(timeLabel.snp.left).offset(-5)
            maker.height.equalTo(5)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
    }
    
}
