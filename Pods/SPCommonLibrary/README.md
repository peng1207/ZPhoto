# SPCommonLibrary

# swift package 管理
      .package(url: "https://github.com/peng1207/SPCommonLibrary.git", from: "0.0.1.28")

# 用pod管理
    source 'https://github.com/peng1207/huangshupengSpecs.git'
    source 'https://github.com/CocoaPods/Specs.git'
## 下载所有功能 
    pod  'SPCommonLibrary'
## 按需要功能下载
### 下载公共功能
    pod 'SPCommonLibrary/Public'
### 下载分享功能
    pod 'SPCommonLibrary/Share'
### 下载网络请求和网络监听功能
    pod 'SPCommonLibrary/Request'
### 下载从相册中选择图片和对图片裁剪功能
    pod 'SPCommonLibrary/ImageManager'
### 下载录音 文字转语音 语音转文字 音频转格式等功能
    pod 'SPCommonLibrary/Recording'
### 二维码、条形码管理
    pod 'SPCommonLibrary/CodeManager'

# 需要添加的权限
权限|描述
--|:--:
NSCameraUsageDescription|摄像头权限
NSMicrophoneUsageDescription|录音权限
NSPhotoLibraryAddUsageDescription|添加图片到相册权限
NSPhotoLibraryUsageDescription|相册权限
NSSpeechRecognitionUsageDescription|实时语音转文字的权限

# 功能使用
