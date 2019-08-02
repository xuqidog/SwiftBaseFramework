//
//  KKEnum.swift
//  LeBang
//
//  Created by 徐其东 on 2019/6/25.
//  Copyright © 2019 zl. All rights reserved.
//

import UIKit
import HandyJSON

// 服务类型
enum SERVICE_TYPE: Int, HandyJSONEnum {
    case GO_SHOP = 1 //上门
    case ARRIVE_SHOP = 2 //到店
    case ALL = 3 //均可
}

// 订单状态
enum ORDER_STATUS_TYPE: Int, HandyJSONEnum {
    case WAIT_PAY = 1 //待支付
    case WAIT_ACCEPT = 2 //待接单
    case WAIT_SERVICE = 3 //待服务
    case SERVICING = 4 //服务中
    case SUCCESS = 5 //服务成功 待评价
    case FAIL = -1; //失效
}

// 退款状态
enum REFUND_STATUS_TYPE: Int, HandyJSONEnum{
    case NEW = 0 // 申请中
    case ACCEPT = 1 //接受
    case SUCCESS = 2 //成功
    case DENY = -1 //拒绝
}
// 退款发起方
enum REFUND_FROM_TYPE: Int, HandyJSONEnum{
    case user = 1 // 用户
    case shop = 2 //商家
}



// 订单详情底部按钮
let 联系客服: String = "联系客服"
let 追加支付: String = "追加支付"
let 再来一单: String = "再来一单"
let 去支付: String = "去支付"
let 取消订单: String = "取消订单"
let 确认完成: String = "确认完成"
let 提醒接单: String = "提醒接单"
let 开始服务: String = "开始服务"
let 部分退款: String = "部分退款"
let 立即处理: String = "立即处理"
let 接单: String = "接单"
let 拒单: String = "拒单"
let 退款详情: String = "退款详情"
let 去评价: String = "去评价"
let 申请退款: String = "申请退款"

