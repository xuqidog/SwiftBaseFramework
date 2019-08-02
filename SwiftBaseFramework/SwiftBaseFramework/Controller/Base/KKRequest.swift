//
//  KKRequest.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/2.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit

protocol KKRequestDelegate:class {
    func requestDidStartLoad(request:KKRequest!)
    func requestDidFinish(JSON:Any!)
    func requestDidFailWithError(error:NSError?)
}

protocol KKRequest:class {
    var useAuth: Bool {get set}
    var useCache: Bool {get set}
    var usePost: Bool {get set}
    var isUploadImage: Bool {get set}
    var uploadImage: UIImage? {get set}
    var isFromCache: Bool {get set}
    var mode: KKModelMode {get set}
    var timeOutSeconds: TimeInterval {get  set}
    var apiCacheTimeOutSeconds: TimeInterval {get set}
    var delegate: KKRequestDelegate! {get set}
    
    var responseString: String? {get}
    var responseObject: Any? {get}
    var cacheKey: String? {get}
    
    /// 初始化
    ///
    /// - Parameter baseUrl: url
    func setup(baseUrl: String?)
    
    /// 增加HTTP请求参数
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - key: key
    func addParams(params: Dictionary<String, Any>?, forKey key: String) -> String?
    
    /// 增加HTTP请求头
    ///
    /// - Parameter params: 请求头
    func addHeaderParams(params: Dictionary<String, String>?)
    
    /// 增加HTTP请求的body
    ///
    /// - Parameters:
    ///   - data: body数据
    ///   - key: key
    func addBodyData(data: Dictionary<String, Any>?, forKey key: String)
    
    /// 发起请求
    func load()
    
    /// 取消请求
    func cancel()
}

