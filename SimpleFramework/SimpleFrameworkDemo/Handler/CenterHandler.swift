//
//  CenterHandler.swift
//  SimpleFramework
//
//  Created by admin on 16/7/5.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class CenterHandler: SimpleHandler {

}

//MARK:- Setup controller
extension SimpleRouterProtocol where Self:CenterHandler {
    //不使用默认的SimpleHandler.setupController时需要定义
    func setupController(data:Dictionary<String,AnyObject>?)->SimpleController? {
        let storyboardName = "Main"
        let controllerIdentifier = name + "Controller"
        
        let bundle = Bundle.main
        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let ctl = sb.instantiateViewController(withIdentifier: controllerIdentifier) as? TestController else {
            print("setupController error!")
            return nil
        }
        //print("\(self.className()): setupController, identifier:\(controllerIdentifier)")
        
        ctl.handler = self
        ctl.data = data

        return ctl
    }
    
}
