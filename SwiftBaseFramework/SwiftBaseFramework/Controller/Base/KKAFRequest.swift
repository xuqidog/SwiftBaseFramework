//
//  KKAFRequest.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/2.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit
import AFNetworking


typealias LBAFSuccess = (URLSessionTask?, Any) -> Void
typealias LBAFFailure = (URLSessionDataTask?, Error) -> Void

class KKAFRequest: NSObject, KKRequest {
    var cacheKey: String?
    var useAuth: Bool = false
    var useCache: Bool = false
    var usePost: Bool = false
    var uploadImage:UIImage?
    var isUploadImage:Bool = false
    var isFromCache: Bool = false
    var mode: KKModelMode = .load
    var timeOutSeconds: TimeInterval = 0.0
    var apiCacheTimeOutSeconds: TimeInterval = 0.0
    weak var delegate: KKRequestDelegate!
    var responseString: String?
    var responseObject: Any?
    
    var manager:AFHTTPSessionManager?
    var requestOperation:URLSessionTask?
    var url:String?
    var queries:Dictionary<String, Any> = [:]
    var requestStartTimeStamp:Double! = 0
    var requestEndTimeStamp:Double! = 0
    
    //实现LBRequest代理方法
    func setup(baseUrl: String?) {
        assert(baseUrl != nil, "Model里的urlPath未指定");
        
        self.timeOutSeconds = 60.0;
        self.url = baseUrl;
        self.manager = AFHTTPSessionManager.init(baseURL: nil);
        self.manager?.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/javascript", "text/plain", "text/html"];
        self.manager?.requestSerializer.timeoutInterval = self.timeOutSeconds;
    }
    func addParams(params: Dictionary<String, Any>?, forKey key: String) -> String? {
        if params != nil {
            //TODO`\
            //let data:Data? = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted);
            let timestamp = ceil(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970);
            //            let quesries:String = data == nil ? "{}" : String.init(data: data!, encoding: String.Encoding.utf8)!;
            self.queries = params!;
            self.queries["t"] = "\(Int64(timestamp) * 1000)";
            
            let request = self.manager!.requestSerializer.request(withMethod: self.usePost ? "POST" : "GET", urlString: self.url!, parameters: self.queries, error: nil);
            return request.url?.absoluteString;
        }
        return nil;
    }
    func addHeaderParams(params: Dictionary<String, String>?) {
        self.requestStartTimeStamp = Date.timeIntervalBetween1970AndReferenceDate;
        let dic:Dictionary = self.HTTPHeaders();
        let nsDic:NSMutableDictionary = NSDictionary.init(dictionary: dic).mutableCopy() as! NSMutableDictionary;
        if params != nil {
            nsDic.addEntries(from: params!);
        }
        
        for (key, obj) in nsDic {
            self.manager?.requestSerializer.setValue(String(describing: obj), forHTTPHeaderField: String(describing: key));
        }
    }
    func addBodyData(data: Dictionary<String, Any>?, forKey key: String) {
        //TODO
    }
    func load() {
        DispatchQueue.main.sync {
            self.delegate?.requestDidStartLoad(request: self);
        }
        //        debugPrint("#LBAFRequest# HTTPAdditionalHeaders: \(self.manager?.requestSerializer.httpRequestHeaders.description ?? "")")
        
        let success:LBAFSuccess = {(task:URLSessionTask?, responseObj:Any) in
            self.responseObject = responseObj;
            self.responseString = String(describing: responseObj);
            
            //TODO:存cache相关
            
            //            print("#LBAFRequest# requestDidFinish：\(self.url ?? ""), \(self.responseString ?? "")")
            DispatchQueue.main.async {
                self.delegate?.requestDidFinish(JSON: responseObj);
            }
        }
        let failure:LBAFFailure = {(task:URLSessionDataTask?, error:Error) in
            self.responseString = task?.response?.description;
            print("\n\n#LBAFRequest# requestDidFailWithError：\(error.localizedDescription) \n\n");
            
            if error.localizedDescription != "已取消" {
                DispatchQueue.main.async {
                    let error = NSError.init(domain: NSCocoaErrorDomain, code: -999, userInfo: [NSLocalizedDescriptionKey: "网络有点慢…请重试"]);
                    self.delegate?.requestDidFailWithError(error: error);
                }
            }
        }
        //TODO:读cache相关
        self.isFromCache = false;
        if self.usePost {
            if self.isUploadImage{
                self.requestOperation = self.manager?.post(self.url!, parameters: self.queries, constructingBodyWith: { (formData) in
                    let imageData = self.uploadImage!.jpegData(compressionQuality: 0.6)
                    formData.appendPart(withFileData: imageData!, name: "file", fileName: "text.jpeg", mimeType: "image/jpeg")
                    //formData.appendPart(withForm: imageData!, name: "file")
                }, progress: nil, success: success, failure: failure)
            }else{
                self.requestOperation = self.manager?.post(self.url!, parameters: self.queries, progress: nil, success: success, failure: failure);
            }
            
        } else {
            self.requestOperation = self.manager?.get(self.url!, parameters: self.queries, progress: nil, success: success, failure: failure);
        }
        
    }
    func cancel() {
        self.requestOperation?.cancel();
    }
    
    
    func HTTPHeaders() -> Dictionary<String, String>! {
        return [:]
    }
}

