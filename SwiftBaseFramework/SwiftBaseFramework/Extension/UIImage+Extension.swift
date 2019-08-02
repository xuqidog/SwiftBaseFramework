//
//  UIImage+Extension.swift
//  HappyHelp
//
//  Created by 徐其东 on 2019/6/5.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit

/*
 
 1.将颜色转成图片
 
 */


func KKIMAGE(_ image: String) -> UIImage {
    return UIImage.init(named: image)!
}

extension UIImage {
    
    /// 将颜色转成图片
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
}


