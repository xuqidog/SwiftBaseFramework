//
//  KKBaseModel.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/2.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit

typealias KKModelCallback = (_ model:KKBaseModel?, _ error: NSError?) -> Void

enum KKModelState {
    case Error
    case Ready
    case Loading
    case Finished
}
enum KKModelMode {
    case load
    case reload
    case loadMore
}

@objc protocol KKModelDelegate:NSObjectProtocol {
    func modelDidStart(model:KKBaseModel!)
    func modelDidFinish(model:KKBaseModel!)
    func modelDidFail(model:KKBaseModel!, error:NSError!)
}

@objcMembers
class KKBaseModel: NSObject, KKRequestDelegate {
    
    //MARK: override相关
    public func dataParams() -> Dictionary<String, Any>? {
        return nil;
    }
    public func urlPath() -> String? {
        return nil;
    }
    public func parseResponse(object:Any?, error: inout NSError?) -> Array<AnyObject>? {
        return nil;
    }
    @objc public func prepareForLoad() -> Bool {
        return true;
    }
    public func prepareParseResponse(object:Any?, error: inout NSError?) -> Bool {
        return true;
    }
    public func headerParams() -> Dictionary<String, String>? {
        return nil;
    }
    public func useCache() -> Bool {
        return false;
    }
    public func useAuth() -> Bool {
        return false;
    }
    public func isUploadImage() -> Bool {
        return false;
    }
    public func uploadImage() -> UIImage? {
        return nil;
    }
    public func needManualLogin() -> Bool {
        return true;
    }
    public func apiCacheTimeOutSeconds() -> TimeInterval {
        return TimeInterval(CGFloat.greatestFiniteMagnitude);
        
    }
    public func customRequestClassName() -> String! {
        return "HHRequest";
    }
    public func bodyData() -> Dictionary<String, Any>? {
        return nil;
    }
    public func usePost() -> Bool {
        return false
    }
    
    private(set) var state:KKModelState = .Ready
    
    private(set) var mode:KKModelMode = .load
    
    weak var delegate:KKModelDelegate?
    
    var requestCallback:KKModelCallback?
    
    var request:KKRequest!
    
    var itemList:KKBaseItemList! = KKBaseItemList.init()
    var item:AnyObject?
    var error:NSError?
    var key:String! {
        get {
            return NSString.init(utf8String: object_getClassName(self))! as String;
        }
    }
    var isFromCache:Bool = false
    var responseObject:Any?
    var responseString:String?
    var parsedResponse:[AnyObject]?
    var cacheKey:String?
    
    func load() {
        self.mode = .load;
        self.reset();
        
        if self._prepareForload() {
            self.loadInternal();
        }
        
    }
    func load(completion: @escaping KKModelCallback) {
        self.requestCallback = completion;
        self.load();
    }
    func reload() {
        self.mode = .reload;
        self.reset();
        if self._prepareForload() {
            self.loadInternal();
        }
    }
    func reload(completion: @escaping KKModelCallback) {
        self.requestCallback = completion;
        self.reload();
    }
    func loadMore() {
        self.mode = .loadMore;
        if self.state != .Loading {
            self.loadInternal();
        }
    }
    func reset() {
        if self.state == .Loading {
            self.cancel();
        }
        self.itemList?.reset();
    }
    func _prepareForload() -> Bool {
        if self.urlPath() != nil {
            if self.state == .Loading {
                self.cancel();
            }
            return self.prepareForLoad();
        } else {
            let error:NSError = NSError.init(domain: "domain", code: 999, userInfo:[NSLocalizedDescriptionKey: "缺少方法名"]);
            self.requestDidFailWithError(error: error);
            return false;
        }
    }
    func cancel() {
        if self.request != nil {
            self.request.cancel();
            self.request = nil;
            self.state = .Ready;
        }
    }
    
    //MARK: private
    func loadInternal() {
        self.error = nil;
        let dataParams = self.dataParams();
        self.request = KKAFRequest();
        self.request.useAuth = self.useAuth();
        self.request.useCache = self.mode == KKModelMode.load && self.useCache();
        self.request.delegate = self;
        self.request.usePost = self.usePost();
        self.request.isUploadImage = self.isUploadImage()
        self.request.uploadImage = self.uploadImage()
        self.request.apiCacheTimeOutSeconds = self.apiCacheTimeOutSeconds();
        self.request.mode = self.mode;
        
        self.request.setup(baseUrl: self.urlPath())
        if dataParams != nil {
            _ = self.request.addParams(params:dataParams, forKey: "data");
        }
        self.request.addHeaderParams(params: self.headerParams());
        
        if self.usePost() {
            self.request.addBodyData(data: self.bodyData(), forKey: "file");
        }
        
        DispatchQueue.global(qos:.default).async {
            self.request.load()
        }
    }
    func requestDidStartLoad(request: KKRequest!) {
        self.state = .Loading;
        if self.delegate != nil {
            self.delegate?.modelDidStart(model: self);
        }
    }
    func requestDidFinish(JSON: Any!) {
        self.isFromCache = self.request.isFromCache;
        
        self.state = .Finished;
        
        self.responseObject = self.request.responseObject;
        self.responseString = self.request.responseString;
        self.cacheKey = self.request.cacheKey;
        
        if self.parse(JSON) {
            self.delegate?.modelDidFinish(model: self);
            
            if self.requestCallback != nil {
                self.requestCallback!(self, nil);
                self.requestCallback = nil;
            }
        }
    }
    func requestDidFailWithError(error: NSError?) {
        self.isFromCache = self.request.isFromCache;
        self.state = .Error;
        self.error = error;
        
        self.responseString = self.request.responseString;
        self.responseObject = self.request.responseObject;
        self.delegate?.modelDidFail(model: self, error: error);
        if self.requestCallback != nil {
            self.requestCallback!(self, error);
            self.requestCallback = nil;
        }
    }
    func parse(_ JSON:Any?) -> Bool {
        var error:NSError? = nil;
        if !self.prepareParseResponse(object: JSON, error: &error) && (error != nil) {
            self.requestDidFailWithError(error: error);
            return false;
        }
        
        self.parsedResponse = self.parseResponse(object: JSON, error: &error);
        if error != nil {
            self.requestDidFailWithError(error: error);
            return false;
        } else {
            self.itemList?.addObjectFromArray(otherArray: self.parsedResponse);
            return true;
        }
    }
    func isLoading() -> Bool {
        return self.state == .Loading;
    }
}

