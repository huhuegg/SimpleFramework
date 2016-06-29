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
    //MARK:- Handler
    
    //MARK:- Router
    func dismiss() {
        AppRouter.instance.close(handler: self, animated: true)
    }
}

extension SimpleRouterProtocol where Self:Test3Handler {
    //使用SimpleHandler的setupController
    
}


private extension Test3Handler {
    
}
