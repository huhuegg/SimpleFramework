//
//  Test3Handler.swift
//  SimpleFramework
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test3Handler: SimpleHandler {
    //MARK:- Controller call handler func
    
}

//MARK:- Setup controller
extension SimpleRouterProtocol where Self:Test3Handler {
    //使用SimpleHandler的setupController
    
}

//MARK:- Router
extension Test3Handler {
    
    func dismiss(from:SimpleController) {
        AppRouter.instance.close(fromController: from, animated: true)
    }
}

//MARK:- Broadcast to controllers
extension Test3Handler {
    
    func broadcast() {
        for ctl in controllers {
            if let c = ctl as? Test3Controller {
                //c.callWithHandler()
            }
        }
    }
}

//MARK:- Private handler func
private extension Test3Handler {
    
}
