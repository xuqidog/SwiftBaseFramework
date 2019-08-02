//
//  Float+Extension.swift
//  LeBang
//
//  Created by 徐其东 on 2019/6/28.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit

class Float_Extension: NSObject {

}

/*
 
 1.Float转String
 2.保留几位小数点
 3.加 减 乘 除
 4.小数点后始终保留几位小数点
 5.金钱格式逗号 20,000,000
 
 */

/*

 */


extension Float {
    /// 将Float转成String
    func toString() -> String {
        return String(self)
    }
    /// 将字符串转成Float scale：保留小数位 roundingMode：取舍类型 （3.4  5.55  5.0）
    func toFloat(_ scale: Int, roundingMode: NSDecimalNumber.RoundingMode) -> Float {
        let numberHandler = NSDecimalNumberHandler.init(roundingMode: .plain, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimalNumber = NSDecimalNumber.init(value: self)
        let resultNumber = decimalNumber.rounding(accordingToBehavior: numberHandler)
        return resultNumber.floatValue
    }
    /// 加
    func add(_ num: Float) -> String {
        let number1 = NSDecimalNumber(value: self)
        let number2 = NSDecimalNumber(value: num)
        let summation = number1.adding(number2)
        return summation.stringValue
    }
    /// 减
    func minus(_ num: Float) -> String {
        let number1 = NSDecimalNumber(value: self)
        let number2 = NSDecimalNumber(value: num)
        let summation = number1.subtracting(number2)
        return summation.stringValue
    }
    /// 乘
    func multiplying(_ num: Float) -> String {
        let number1 = NSDecimalNumber(value: self)
        let number2 = NSDecimalNumber(value: num)
        let summation = number1.multiplying(by: number2)
        return summation.stringValue
    }
    /// 除
    func dividing(_ num: Float) -> String {
        let number1 = NSDecimalNumber(value: self)
        let number2 = NSDecimalNumber(value: num)
        let summation = number1.dividing(by:number2)
        return summation.stringValue
    }
    /// num 保留几位小数 type 取舍类型
    func numType(num : Int , type : NSDecimalNumber.RoundingMode) -> String {
        let roundUp = NSDecimalNumberHandler(roundingMode: type, scale:Int16(num), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        let discount = NSDecimalNumber(value: self)
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
            if num == 0 {
            } else {
                mutstr.append(".")
                for _ in 1...num {
                    mutstr += "0"
                }
            }
            return mutstr
        }
        // 加 保留 2 位小数
    }
    
    /// 乘100
    func hundred() -> Float {
        return self.multiplying(HUNDERD).toFloat()
    }
    /// 除100
    func penny() -> Float {
        return self.dividing(HUNDERD).toFloat()
    }
    /// 保留整数
    func toInt() -> String {
        
        let total = self.numType(num: 2, type: .up)
        if total.contains(".") {
            let float = total.components(separatedBy: ".").last!
            if float == "00" {
                return total.components(separatedBy: ".").first!.addMicrometerLevel()
            }
        }
        return self.numType(num: 2, type: .up).addMicrometerLevel()
    }
    
    
}
