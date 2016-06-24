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

}

extension SimpleRouterProtocol where Self:Test2Handler {
    
    func dismissToTest1() {
        AppRouter.instance.close(handler: self, animated: true)
    }
    
    func presentToTest3(_ data:Dictionary<String,AnyObject>?) {
        AppRouter.instance.show(routerId: AppRouterID.test3, type: ControllerShowType.present, fromHandler: self,animated: true, data: data)
    }
}
