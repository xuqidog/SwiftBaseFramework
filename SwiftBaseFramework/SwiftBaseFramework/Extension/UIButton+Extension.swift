//
//  UIButton+Extension.swift
//  HappyHelp
//
//  Created by 徐其东 on 2019/6/10.
//  Copyright © 2019 zl. All rights reserved.
//


import UIKit
/*
 
 1.设置：字颜色、字号、
 2.设置：图片和标题的位置
 3.设置：图片、图片样式
 4.设置：
 
 */




//MARK: -定义button相对label的位置
enum YWButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}

extension UIButton {
    
    /// 设置文字和图片的样式
    func layoutButton(style: YWButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
//        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        if Double(version) >= 8.0 {
//            labelWidth = self.titleLabel?.intrinsicContentSize.width
//            labelHeight = self.titleLabel?.intrinsicContentSize.height
//        }else{
//            labelWidth = self.titleLabel?.frame.size.width
//            labelHeight = self.titleLabel?.frame.size.height
//        }
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .Top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
            break;
            
        case .Left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
            break;
            
        case .Bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .Right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
    /// 获取文字宽度
    func getTitleWidth() -> CGFloat {
        return (self.titleLabel?.intrinsicContentSize.width)!
    }
    func getImgWidth() -> CGFloat {
        let imageWidth = self.imageView?.frame.size.width
        return imageWidth!
    }
    
    
    /// 添加事件 移除之前的所有事件
    func removeAfterAddTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        // 移除之前的所有事件
        let actions = self.actions(forTarget: target, forControlEvent: .touchUpInside)
        if let T = actions {
            for name in T {
                if !name.hasPrefix("_") { //过滤系统方法
                    self.removeTarget(target, action: NSSelectorFromString(name), for: .touchUpInside)
                }
            }
        }
        // 添加当前事件
        super.addTarget(target, action: action, for: controlEvents)
    }
    
}
