//
//  HomeModel.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/2.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit

class HomeModel: KKListModel {

    var storeAuth = 0
    
    override func urlPath() -> String? {
        return ""
    }
    override func usePost() -> Bool {
        return true
    }
    override func parseResponse(object: Any?, error: inout NSError?) -> Array<AnyObject>? {
//        let response:Dictionary<String, Any> = object as! Dictionary<String, Any>;
//        let data:Dictionary<String, Any> = response["data"] as! Dictionary;
        return []
    }
}
