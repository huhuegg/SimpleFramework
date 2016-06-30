//
//  Test1Handler.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test1Handler: SimpleHandler {
    //MARK:- Handler
    
    //MARK:- Router
    func popToTest(from:SimpleController) {
        AppRouter.instance.close(fromController: from, animated: true)
    }
    
    func presentToTest2(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        let transitioning = SimpleControllerAnimatedTransitioning(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test2, type: ControllerShowType.present, fromController: from, animated: true, transitioning:transitioning,data: data)
        
    }
}

extension SimpleRouterProtocol where Self:Test1Handler {
    //使用SimpleHandler的setupController
}

private extension Test1Handler {
    
}
