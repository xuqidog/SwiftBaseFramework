//
//  UIView+Extension.swift
//  HappyHelp
//
//  Created by 徐其东 on 2019/6/10.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit


/*
 
 1.加载loadXib
 2.将当前视图转为 UIImage
 3.裁剪圆角 特定角
 4.描边框
 5.画虚线
 6.渐变色
 7.阴影
 
 */



extension UIView {
    
    /// 加载xib
    func loadXib() -> UIView {
        let className = type(of:self)
        let bundle = Bundle(for:className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    /// 将当前视图转为 UIImage
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.width, height: bounds.height), false, UIScreen.main.scale)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            layer.render(in: context)
            //            context.restoreGState()
            let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return theImage
        }
    }
    
    // MARK:- 裁剪圆角
    func clipCorner(direction: UIRectCorner, radius: CGFloat) {
        if direction == .allCorners {
            self.layer.cornerRadius = radius
            self.clipsToBounds = true
            return
        }
        let cornerSize = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.addSublayer(maskLayer)
        self.layer.mask = maskLayer
    }
    
    /// 描边
    func border(radius: CGFloat, width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
    }
    
    /// 阴影
    func addShadow(shadowColor:UIColor,shadowOpacity:CGFloat,shadowRadius:CGFloat,shadowOffset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = Float(shadowOpacity)
    }
    
    ///  虚线
    func line(_ view: UIView, _ frame: CGRect, _ color: UIColor) {
        let lineView:UIView = UIView(frame: frame)
        view.addSubview(lineView)
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = lineView.bounds
        
        shapeLayer.position = CGPoint(x: lineView.frame.width / 2, y: lineView.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 3), NSNumber(value: 3)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.frame.width, y: 0))
        shapeLayer.path = path
        
        lineView.layer.addSublayer(shapeLayer)
    }
    enum GradientPoint {
        case leftTop, center, leftDown, rightTop, rightDown, leftCenter, rightCenter
        var point: CGPoint {
            switch self {
            case .leftTop: return CGPoint(x: 0, y: 1)
            case .leftCenter: return CGPoint(x: 0, y: 0.5)
            case .leftDown: return CGPoint(x: 0, y: 0)
            case .center: return CGPoint(x: 0.5, y: 0.5)
            case .rightTop: return CGPoint(x: 1, y: 1)
            case .rightCenter: return CGPoint(x: 1, y: 0.5)
            case .rightDown: return CGPoint(x: 1, y: 0)
            }
        }
    }
    /// 渐变色
    func gradientColor(startColor: UIColor, startPoint: GradientPoint, endColor: UIColor, endPoint: GradientPoint) {
        let gradientLayer = CAGradientLayer()
        let color1 = startColor.cgColor
        let color2 = endColor.cgColor
        gradientLayer.colors = [color1,color2]
        //gradientLayer.locations = [0.5]
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func gradientColors(startPoint: GradientPoint, endPoint: GradientPoint, colors: Array<Any>) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        //gradientLayer.locations = [0.5]
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}


