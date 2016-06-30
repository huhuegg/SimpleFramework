//
//  Test2Handler.swift
//  SimpleFramework
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test2Handler: SimpleHandler {
    //MARK:- Handler
    
    //MARK:- Router
    func dismissToTest1(from:SimpleController) {
        AppRouter.instance.close(fromController: from, animated: true)
    }
    
    func presentToTest3(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        let transitioning:UIViewControllerAnimatedTransitioning? = nil
        AppRouter.instance.show(routerId: AppRouterID.test3, type: ControllerShowType.present, fromController: from, animated: true, transitioning:transitioning,data: data)
    }
}

extension SimpleRouterProtocol where Self:Test2Handler {
    //使用SimpleHandler的setupController
    
}

private extension Test2Handler {
    
}
