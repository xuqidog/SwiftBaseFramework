//
//  NString+Extension.swift
//  HappyHelp
//
//  Created by 徐其东 on 2019/6/5.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit

extension String {
    
    /// 返回字符串的高度
    func getStrHeight(strWith: CGFloat, strFont: UIFont, lineSpacing: CGFloat) -> CGFloat {
        var size = CGRect()
        let size2 = CGSize(width: strWith, height: CGFloat(MAXFLOAT))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        let dict = [NSAttributedString.Key.font:strFont, NSAttributedString.Key.paragraphStyle:paraStyle]
        size = self.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return size.height
    }
    
    /// 行间距
    func lineSpacing(_ lineSpacing: CGFloat, _ font: UIFont) -> NSAttributedString {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// 更改某段字符串颜色
    func changeColor(changeColor: UIColor , changeString: String) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string:self)
        // 2. 创建正则表达式对象
        let regex = try? NSRegularExpression(pattern: changeString, options: [])
        // 3. 匹配字符串中内容
        let results =  regex!.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        // 4.遍历数组,获取结果[NSTextCheckingResult]
        for result in results {
            let wordRange = result.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: changeColor, range: wordRange)
        }
        return attributedString
        
    }
    
}


/// 字符串 加减乘除 取余
extension String {
    /// 将字符串转成Float
    func toFloat() -> Float {
        return self.isEmpty ? 0 : NSDecimalNumber.init(string: self).floatValue
    }
    /// 将字符串转成Float scale：保留小数位 roundingMode：取舍类型 （3.4  5.55  5.0）
    func toFloat(_ scale: Int, roundingMode: NSDecimalNumber.RoundingMode) -> Float {
        let numberHandler = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimalNumber = NSDecimalNumber.init(string: self)
        let resultNumber = decimalNumber.rounding(accordingToBehavior: numberHandler)
        return resultNumber.floatValue
    }
    /// 将字符串转成Int
    func toInt() -> Int {
        return self.isEmpty ? 0 : NSDecimalNumber.init(string: self).intValue
    }
    /// 加
    func add(_ num: String) -> String {
        let number1 = NSDecimalNumber(string: self)
        let number2 = NSDecimalNumber(string: num)
        let summation = number1.adding(number2)
        return summation.stringValue
    }
    /// 减
    func minus(_ num: String) -> String {
        let number1 = NSDecimalNumber(string: self)
        let number2 = NSDecimalNumber(string: num)
        let summation = number1.subtracting(number2)
        return summation.stringValue
    }
    /// 乘
    func multiplying(_ num: String) -> String {
        let number1 = NSDecimalNumber(string: self)
        let number2 = NSDecimalNumber(string: num)
        let summation = number1.multiplying(by: number2)
        return summation.stringValue
    }
    /// 除
    func dividing(_ num: String) -> String {
        let number1 = NSDecimalNumber(string: self)
        let number2 = NSDecimalNumber(string: num)
        let summation = number1.dividing(by:number2)
        return summation.stringValue
    }
    
    enum RoundingType : UInt {
        case plain//取整
        case down//只舍不入
        case up//只入不舍
        case bankers//四舍五人
    }
    /// num 保留几位小数 type 取舍类型
    func numType(num : Int , type : NSDecimalNumber.RoundingMode) -> String {
        let roundUp = NSDecimalNumberHandler(roundingMode: type, scale:Int16(num), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        let discount = NSDecimalNumber(string: self)
        let subtotal = NSDecimalNumber(string: "0")
        // 加 保留 2 位小数
        let total = subtotal.adding(discount, withBehavior: roundUp).stringValue
        var mutstr = String()
        
        if total.contains(".") {
            let float = total.components(separatedBy: ".").last!;
            if float.count == Int(num) {
                mutstr .append(total);
                return mutstr
            } else {
                mutstr.append(total)
                let all = num - float.count
                for _ in 1...all {
                    mutstr += "0"
                }
                return mutstr
            }
        } else {
            mutstr.append(total)
            mutstr.append(".")
            if num == 0 {
            } else {
                for _ in 1...num {
                    mutstr += "0"
                }
            }
            return mutstr
        }
        // 加 保留 2 位小数
    }
    
    /// 添加千分位的函数实现
    func addMicrometerLevel() -> String {
        // 判断传入参数是否有值
        if self.count != 0 {
            /**
             创建两个变量
             integerPart : 传入参数的整数部分
             decimalPart : 传入参数的小数部分
             */
            var integerPart:String?
            var decimalPart = String.init()
            
            // 先将传入的参数整体赋值给整数部分
            integerPart =  self
            // 然后再判断是否含有小数点(分割出整数和小数部分)
            if self.contains(".") {
                let segmentationArray = self.components(separatedBy: ".")
                integerPart = segmentationArray.first
                decimalPart = segmentationArray.last!
            }
            
            /**
             创建临时存放余数的可变数组
             */
            let remainderMutableArray = NSMutableArray.init(capacity: 0)
            // 创建一个临时存储商的变量
            var discussValue:Int32 = 0
            
            /**
             对传入参数的整数部分进行千分拆分
             */
            repeat {
                let tempValue = integerPart! as NSString
                // 获取商
                discussValue = tempValue.intValue / 1000
                // 获取余数
                let remainderValue = tempValue.intValue % 1000
                // 将余数一字符串的形式添加到可变数组里面
                let remainderStr = String.init(format: "%d", remainderValue)
                remainderMutableArray.insert(remainderStr, at: 0)
                // 将商重新复制
                integerPart = String.init(format: "%d", discussValue)
            } while discussValue>0
            
            // 创建一个临时存储余数数组里的对象拼接起来的对象
            var tempString = String.init()
            
            // 根据传入参数的小数部分是否存在，是拼接“.” 还是不拼接""
            let lastKey = (decimalPart.count == 0 ? "":".")
            /**
             获取余数组里的余数
             */
            for i in 0..<remainderMutableArray.count {
                // 判断余数数组是否遍历到最后一位
                let  param = (i != remainderMutableArray.count-1 ?",":lastKey)
                tempString = tempString + String.init(format: "%@%@", remainderMutableArray[i] as! String,param)
            }
            //  清楚一些数据
            integerPart = nil
            remainderMutableArray.removeAllObjects()
            // 最后返回整数和小数的合并
            return tempString as String + decimalPart
        }
        return self
    }
    
    // MARK : 获取字符串的长度
    func length() -> Int {
        /**
         另一种方法：
         let tempStr = self as NSString
         return tempStr.length
         */
        return self.count
    }
    
    /// 千米
    func kilometer() -> String {
        let m = self.toFloat()
        if m >= 1000 {
            return m.dividing(1000).numType(num: 1, type: .up) + "km"
        }else{
            return self + "m"
        }
    }
    
}
