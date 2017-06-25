//
//  UIView+extension.swift
//  ZPhoto
//
//  Created by huangshupeng on 2017/6/25.
//  Copyright © 2017年 huangshupeng. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    func sp_x() -> CGFloat{
        return self.frame.origin.x
    }
    func sp_y() -> CGFloat{
        return self.frame.origin.y
    }
    func sp_width() ->  CGFloat{
        return self.frame.size.width
    }
    func sp_height() ->  CGFloat{
        return self.frame.size.height
    }
    func sp_MaxX() -> CGFloat{
        return self.sp_x() + self.sp_width()
    }
    func sp_MaxY() ->  CGFloat{
        return self.sp_y() + self.sp_height()
    }
    
    
    
}

