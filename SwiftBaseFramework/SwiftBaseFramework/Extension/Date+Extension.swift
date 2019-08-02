//
//  Date+Extension.swift
//  LeBang
//
//  Created by 徐其东 on 2019/6/27.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit

class Date_Extension: NSObject {

}


/*
 
 1.时间戳转字符串
 2.字符串转时间戳
 3.前一天 后一天 加几天
 4.周几 上下午
 5.两个时间比较
 6.倒计时
 
 */

func nextTimeStamp(timeStamp: Double, pastTime: Double) -> Double {
    //timeStamp开始时间戳
    //pastTime过期时间戳
    
    //获取当前的时间戳
    let currentTime = Date().timeIntervalSince1970
    print(currentTime,   timeStamp, "sdsss")
    
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000) + pastTime
    //时间差
    let reduceTime : TimeInterval = timeSta - currentTime
    
    return reduceTime
}


func updateTimeToCurrennTime(timeStamp: Double) -> String {
    //获取当前的时间戳
    let currentTime = Date().timeIntervalSince1970
    print(currentTime,   timeStamp, "sdsss")
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    //时间差
    let reduceTime : TimeInterval = currentTime - timeSta
    //时间差小于60秒
    if reduceTime < 60 {
        return "刚刚"
    }
    //时间差大于一分钟小于60分钟内
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)分钟前"
    }
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        return "\(hours)小时前"
    }
    let days = Int(reduceTime / 3600 / 24)
    if days < 30 {
        return "\(days)天前"
    }
    //不满足上述条件---或者是未来日期-----直接返回日期
    let date = NSDate(timeIntervalSince1970: timeSta)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    return dfmatter.string(from: date as Date)
}




enum DATE_TYPE: String {
    case all = "yyyy-MM-dd HH:mm:ss"
    case minute = "yyyy-MM-dd HH:mm"
    case day = "yyyy-MM-dd"
}
/// 时间戳转字符串 yyyy-MM-dd HH:mm:ss
func timeStampToString(timeStamp: Double, format: DATE_TYPE?)->String {
    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    let date = NSDate(timeIntervalSince1970: timeSta)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    if let T = format {
        dfmatter.dateFormat = T.rawValue
    }else {
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    return dfmatter.string(from: date as Date)
}
