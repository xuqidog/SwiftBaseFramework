//
//  KKTools.swift
//  Swift_demo
//
//  Created by xuqidong on 2018/7/5.
//  Copyright © 2018 xuqidong. All rights reserved.
//

import UIKit

/// 返回包名
func getAppName() -> String {
    return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
}
/// 返回App版本号
func getAppVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
}
/// 返回App版本号
func getAppShortVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}
/// 延迟操作
func kk_dispatch_after(execution:@escaping () -> Void, delaySeconds:TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(delaySeconds * TimeInterval(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: execution);
}

/// 计算周期
func getWeekStr(_ list: Array<Int>)->String{
    let weeks = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    if(list.count == 7){
        return "周一至周日"
    }else{
        var finalWeeks = [String]()
        for weekIndex in list{
            finalWeeks.append(weeks[weekIndex - 1])
        }
        return finalWeeks.joined(separator: ",")
    }
}
/// 吊起系统电话
func callPhone(_ phoneNo: String) {
    //let phoneNo = phone
    let phoneUrlString = "tel:" + phoneNo
    let phoneUrl = URL(string: phoneUrlString)
    if(phoneUrl != nil){
        DispatchQueue.main.async(execute: {
            if(UIApplication.shared.canOpenURL(phoneUrl!)){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(phoneUrl!, options: [:], completionHandler: { (success) in
                        debugPrint("OpenSuccess=\(success)")
                    })
                } else {
                    let str = "telprompt://\(phoneNo)"
                    UIApplication.shared.openURL(URL(string: str)!)
                    
                }
            }
        })
    }
}
/// 精准 Log
func KKLog<T>(message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    
    #endif
}
