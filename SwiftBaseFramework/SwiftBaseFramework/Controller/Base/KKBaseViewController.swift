//
//  KKBaseViewController.swift
//  SwiftBaseFramework
//
//  Created by 徐其东 on 2019/8/1.
//  Copyright © 2019 xuqidong. All rights reserved.
//

import UIKit

class KKBaseViewController: UIViewController, KKModelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK: model delegate
    func modelDidStart(model: KKBaseModel!) {
        self.showLoading(model)
    }
    func modelDidFinish(model: KKBaseModel!) {
        self.didLoadModel(model);
        if self.canShowModel(model) {
            self.showModel(model);
        } else {
            self.showEmpty(model);
        }
    }
    func modelDidFail(model: KKBaseModel!, error: NSError!) {
        self.showError(error: error, model: model);
    }
    lazy var _modelDictInternal:Dictionary<String, KKBaseModel> = [:];
    
    func registerModel(_ model:KKBaseModel?) {
        if model != nil {
            assert(model?.key != nil, "model的key不能为空")
            model!.delegate = self;
            objc_sync_enter(self);
            self._modelDictInternal[model!.key] = model;
            objc_sync_exit(self);
        }
    }
    func unRegisterModel(_ model:KKBaseModel?) {
        if model != nil {
            objc_sync_enter(self);
            model!.delegate = nil;
            self._modelDictInternal[model!.key] = nil;
            objc_sync_exit(self);
        }
    }
    func load() {
        for (_, model) in self._modelDictInternal {
            model.load();
        }
    }
    func reload() {
        for (_, model) in self._modelDictInternal {
            model.reload();
        }
    }
    func loadMore() {
        
    }
//    func showHudDef(WithText text:String?, mode:MBProgressHUDMode, delay:TimeInterval) {
//        showHud(WithText: text, mode: mode)
//        hideHudWithDelay(delay: delay)
//    }
//    func showHud(WithText text:String?, mode:MBProgressHUDMode) {
//        self.hud?.dismiss();
//        self.hud = CKProgressHUD(text: text, mode: mode);
//        self.hud?.showIn(view: self.view);
//    }
//    func showFullScreenHud(WithText text:String?, mode:MBProgressHUDMode) {
//        DispatchQueue.main.async {
//            self.hud?.dismiss();
//            self.hud = CKProgressHUD(text: text, mode: mode);
//            self.hud?.showIn(view: UIApplication.shared.keyWindow!);
//        }
//    }
    
//    func hideHudWithDelay(delay:TimeInterval) {
//        MSUtil.dispatch_after(execution: {
//            self.hud?.dismiss();
//        }, delaySeconds: delay);
//    }
    deinit {
        objc_sync_enter(self);
        self._modelDictInternal.removeAll();
        objc_sync_exit(self);
    }
    //MARK: subclass override
    func didLoadModel(_ model:KKBaseModel!) {}
    func canShowModel(_ model:KKBaseModel!) -> Bool {
        return _modelDictInternal[model.key] != nil;
    }
    func showEmpty(_ model:KKBaseModel!) {}
    func showModel(_ model:KKBaseModel!) {}
    func showLoading(_ model:KKBaseModel!) {}
    func showError(error:NSError!, model:KKBaseModel!) {
//        self.showFullScreenHud(WithText: error.localizedDescription, mode: .text)
//        self.hideHudWithDelay(delay: kkDelay)
    }

}
