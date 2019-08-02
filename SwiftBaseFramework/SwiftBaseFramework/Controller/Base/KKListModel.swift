//
//  KKListModel.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/2.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit

class KKListModel: KKBaseListModel {
    override func headerParams() -> Dictionary<String, String>? {
        var ret:Dictionary<String, String> = [:];
        let timestamp = ceil(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970);
        ret["bsb-Timestamp"] = "\(Int64(timestamp) * 1000)";
        ret["User-Agent"] = "ios\(UIDevice.current.systemVersion)/Version\(getAppVersion())"
        return ret;
    }
    override func prepareParseResponse(object: Any?, error: inout NSError?) -> Bool {
        let response:[String: Any] = object as! [String: Any];
        
        print("\n\n- API -\n" + self.urlPath()! + "\n")
        print(self.dataParams() as Any)
        print("\nResponse\n" + "\(response)" + "\n\n")
        
        let success = response["success"] as? Bool;
        if success != nil && success! {
            return true;
        } else {
            let code = response["code"] as? String
            let codeNum = Int(code ?? "-1")
            let msg = response["msg"] as? String;
            error = NSError(domain: "domain", code: codeNum ?? -1 , userInfo: [NSLocalizedDescriptionKey: msg ?? "服务器错误，请稍后重试"]);
            return false;
        }
    }
}
