//
//  SPEnum.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 huangshupeng. All rights reserved.
//
// 枚举类
import Foundation

/// 日期格式
enum SPTimeFormat: String {
    ///  年月日 时分秒
    case default_time   = "yyyy-MM-dd HH:mm:ss"
    ///  年月日 时分 （取后两位 年）
    case yyMdHm         = "yy-MM-dd HH:mm"
    /// 年月日 时分
    case yyyyMdHm       = "yyyy-MM-dd HH:mm"
    /// 年月日
    case yMd            = "yyyy-MM-dd"
    ///  月日 时分秒
    case MdHms          = "MM-dd HH:mm:ss"
    /// 时分秒
    case Hms            = "HH:mm:ss"
    /// 时分
    case Hm             = "HH:mm"
    /// 月日
    case Md             = "MM:dd"
    /// 年月日 (取后两位 年)
    case yyMd           = "yy-MM-dd"
}

///  颜色十六进制
enum SPHexColor : String {
    case color_333333   = "#333333"
    case color_000000   = "#000000"
    case color_c11f2f   = "#c11f2f"
    case color_b31f3f   = "#B31F3F"
    case color_ffffff   = "#ffffff"
    case color_8e8e8e   = "#8e8e8e"
    case color_666666   = "#666666"
    case color_999999   = "#999999"
    case color_eeeeee   = "#eeeeee"
    case color_97a959   = "#97A959"
    case color_ff9600   = "#FF9600"
    case color_dddddd   = "#DDDDDD"
    case color_1981fa   = "#1981fa"
    case color_0c95f5   = "#0c95f5"
    case color_ce6a00   = "#ce6a00"
    case color_e57d00   = "#e57d00"
    case color_e74540   = "#e74540"
    case color_f7f7f7   = "#f7f7f7"
    case color_eee000   = "#eee000"
    case color_189cdd   = "#189cdd"
    case color_1599da   = "#1599da"
    case color_00a1fe   = "#00a1fe"
    case color_01b5da   = "#01b5da"
    case color_2a96fd   = "#2a96fd"
    case color_ff3300   = "#ff3300"
}

///  按钮点击事件
public enum SPButtonClickType : Int {
    /// 点击完成
    case done
    /// 点击取消\返回
    case cance
    ///  点击闪光灯
    case flash
    /// 点击切换镜头
    case change
    /// 点击滤镜
    case filter
    /// 剪切
    case shear
    /// 点击编辑
    case edit
    /// 点击关闭
    case close
    /// 选择
    case select
    /// 布局
    case layout
    /// 分享
    case share
    /// 保存
    case save
}

///  图片布局类型
enum SPPictureLayoutType  {
    /// 外面传的point数组
    case point
    /// 矩形
    case rectangle
    /// 圆
    case circular
    /// 椭圆
    case ellipse
    /// 菱形
    case diamond
    /// 心形
    case heart
    /// 水滴
    case waterDrop
    ///  矩形 中带有圆角 圆形朝外
    enum RectangleCorner {
        /// 左边圆角 半径为高度一半
        case left
        /// 右边圆角 半径为高度一半
        case right
        /// 上边圆角 半径为宽度一半
        case top
        /// 下边圆角 半径为宽度一半
        case bottom
        ///  左上圆角 半径为高度
        case left_top
        /// 左下圆角 半径为高度
        case left_bottom
        /// 右上圆角 半径为高度
        case right_top
        /// 右下圆角 半径为高度
        case right_bottom
        
    }
    case rectangleCorner(type:RectangleCorner,radius:Float)
    /// 矩形 中带用圆角 圆形朝内
    enum RectangleCornerInner {
        
        /// 左边圆角 半径为高度一半
        case left
        /// 右边圆角 半径为高度一半
        case right
        /// 上边圆角 半径为宽度一半
        case top
        /// 下边圆角 半径为宽度一半
        case bottom
        ///  左上圆角 半径为高度
        case left_top
        /// 左下圆角 半径为高度
        case left_bottom
        /// 右上圆角 半径为高度
        case right_top
        /// 右下圆角 半径为高度
        case right_bottom
        /// 左右 两个半圆 半径为高度一半
        case horizontal
        ///  上下 两个半圆 半径为高度一半
        case vertical
    }
    case rectangleCornerInner(type:RectangleCornerInner)
    ///  多边形
    enum Polygon {
        /// 六边形
        case six
        /// 七边形
        case eight
    }
    case polygon(polygon : Polygon)
    /// 三角形
    enum Triangle : Int {
        /// 顶角在左边
        case left
        /// 顶角在右边
        case right
        /// 顶角在上边
        case top
        /// 顶角在下边
        case bottom
        /// 左上斜角
        case left_top
        /// 左右斜角
        case left_bottom
        /// 右上斜角
        case right_top
        /// 右下斜角
        case right_bottom
    }
    case triangle(triangle : Triangle)
    /// 齿轮
    enum Gear : Int{
        /// 三角形
        case triangle
        /// 圆形
        case corner
    }
    case gear(type:Gear)
    
}
/// 图片拼接类型
enum SPPhotoSPlicingType {
    case one(tyep : SPPictureLayoutType)
    
    enum TwoType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
    }
    /// 两张图片拼接
    case two(type : TwoType)
    enum ThreeType {
        case one
        case two
        case three
        case four
        case five
        case six
  
    }
     /// 三张图片拼接
    case three(type : ThreeType)
    enum FourType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
        case thirteen
        case fourteen
        case fifteen
        case sixteen
        case seventeen
        case eighteen
    }
     /// 四张图片拼接
    case four(type : FourType)
    enum FiveType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
        case thirteen
        case fourteen
        case fifteen
        case sixteen
        case seventeen
        case eighteen
    }
     /// 五张图片拼接
    case five(type : FiveType)
    enum SixType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
    }
     /// 六张图片拼接
    case six(type : SixType)
    enum SevenType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
         
    }
     /// 七张图片拼接
    case seven(tyep : SevenType)
    enum EightType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
    }
    /// 八张图片拼接
    case eight(type : EightType)
    
    enum NineType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
    }
     /// 九张图片拼接
    case nine(nineType:NineType)
}
/// 方向
enum SPDirection {
    /// 垂直
    case vertical
    /// 水平
    case horizontal
}


/// 动画类型
enum SPAnimationType {
    /// 没有动画
    case none
    /// 淡出
    case fadeOut
    /// 推出
    case push
    /// 覆盖
    case cover
    /// 翻书
    case toBook
    /// 打洞
    case hole
}
///  拍照或者录制 布局类型
enum SPVideoLayoutType {
    /// 没有布局
    case none
    /// 二等分
    case bisection
    /// 四等分
    case quadrature
    /// 六等分
    case sextant
    /// 九等分
    case nineEqualparts
}
/// 视频拼接类型
enum SPVideoSplicingType {
    case none
    case two_vertical
    case two_cover
    case three_top
    case three_bottom
    case four
    case five
    case six
    case six_pyramid
    case seven
    case eight
    case nine
}
