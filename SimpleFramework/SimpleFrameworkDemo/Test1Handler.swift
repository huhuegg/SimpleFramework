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

}

extension SimpleRouterProtocol where Self:Test1Handler {
    
    func popToTest() {
        AppRouter.instance.close(handler: self, animated: true)
    }
    
    func presentToTest2(_ data:Dictionary<String,AnyObject>?) {
        AppRouter.instance.show(routerId: AppRouterID.test2, type: ControllerShowType.present, fromHandler: self,animated: true, data: data)
    }
}
