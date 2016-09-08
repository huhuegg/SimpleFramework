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
    //MARK:- Controller call handler func

}

//MARK:- Setup controller
extension SimpleRouterProtocol where Self:TestHandler {
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

//MARK:- Router
extension TestHandler {
    func pushToTest1(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        //let transitioning:UIViewControllerAnimatedTransitioning? = nil
        let transitioning = SimpleControllerAnimatedTransitioning(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test1, type: ControllerShowType.push, fromController: from, animated: true, transitioning:transitioning, data: data)
    }
    
    func presentToTest3(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        let transitioning = PresentControllerBoxAnimation(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test3, type: ControllerShowType.present, fromController: from, animated: true, transitioning:transitioning,data: data)
    }
}

//MARK:- Private handler func
private extension TestHandler {
    

}
