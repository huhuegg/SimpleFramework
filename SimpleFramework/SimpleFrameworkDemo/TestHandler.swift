//
//  TestHandler.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class TestHandler: SimpleHandler {
    //MARK:- Handler
    
    //MARK:- Router
    func pushToTest1(_ data:Dictionary<String,AnyObject>?) {
        let transitioning = SimpleControllerAnimatedTransitioning(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test1, type: ControllerShowType.push, fromHandler: self, animated: true, transitioning:transitioning, data: data)
    }
    
    func presentToTest3(_ data:Dictionary<String,AnyObject>?) {
        let transitioning = PresentControllerBoxAnimation(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test3, type: ControllerShowType.present, fromHandler: self, animated: true, transitioning:transitioning,data: data)
    }
}

extension SimpleRouterProtocol where Self:TestHandler {
    //不使用SimpleHandler的setupController
    func setupController(data:Dictionary<String,AnyObject>?) {
        let storyboardName = "Main"
        let controllerIdentifier = name + "Controller"
        
        let bundle = Bundle.main()
        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let ctl = sb.instantiateViewController(withIdentifier: controllerIdentifier) as? TestController else {
            print("setupController error!")
            return
        }
        //print("\(self.className()): setupController, identifier:\(controllerIdentifier)")
        
        ctl.handler = self
        ctl.data = data
        
        self.activeController = ctl
    }

}

private extension TestHandler {
    

}
