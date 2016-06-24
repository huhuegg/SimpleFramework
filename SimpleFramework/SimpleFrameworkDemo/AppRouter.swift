//
//  AppRouter.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

enum AppRouterID {
    case test
    case test1
    case test2
    case test3
}

class AppRouter: NSObject {
    private static let appRouterInstance = AppRouter()
    var window:UIWindow!

    //MARK: Add Handler Here
    var testHandler:TestHandler!
    var test1Handler:Test1Handler!
    var test2Handler:Test2Handler!
    var test3Handler:Test3Handler!
    
    //MARK:- Function
    static let instance:AppRouter = {
        return appRouterInstance
    }()
    
    func setup()->Bool {
        if let appDelegate = UIApplication.shared().delegate as? AppDelegate {
            if let firstController = initRouters() {
                print("firstController is \(String(firstController.classForCoder))")
                if let navi = appDelegate.window!.rootViewController as? UINavigationController {
                    navi.viewControllers = [firstController]
                } else {
                    let navi = UINavigationController(rootViewController: firstController)
                    appDelegate.window!.rootViewController = navi
                }
                
                window = appDelegate.window
                
                return true

            } else {
                return false
            }
        }
        return false
    }

    
    func initRouters()->UIViewController? {
        testHandler = SimpleRouter.create(name: "Test") as! TestHandler
        test1Handler = SimpleRouter.create(name: "Test1") as! Test1Handler
        test2Handler = SimpleRouter.create(name: "Test2") as! Test2Handler
        test3Handler = SimpleRouter.create(name: "Test3") as! Test3Handler
        
        
        //setupRoot
        testHandler.setupController(data: ["key":"value"])
        //return testHandler.activeController()
        return testHandler.activeController
    }
    
    func setupToHandler(routerId:AppRouterID, data: Dictionary<String, AnyObject>?)->SimpleHandler? {
        var toHandler:SimpleHandler?
        
        switch routerId {
        case .test:
            //Controller初始化
            testHandler.setupController(data: data)
            toHandler = testHandler
        case .test1:
            test1Handler.setupController(data: data)
            toHandler = test1Handler
        case .test2:
            test2Handler.setupController(data: data)
            toHandler = test2Handler
        case .test3:
            test3Handler.setupController(data: data)
            toHandler = test3Handler
        default:
            print("AppRouteID no defined")
        }

        return toHandler
    }
    
}

extension AppRouter {
    func show(routerId:AppRouterID,type:ControllerShowType, fromHandler:SimpleHandler, animated:Bool, data:Dictionary<String,AnyObject>?) {
        
        
        //guard let fromController = fromHandler.activeController() else {
        guard let fromController = fromHandler.activeController else {
            print("fromHandler.activeController is nil")
            return
        }
        
        guard let toHandler = setupToHandler(routerId: routerId, data: data) else {
            print("toHandler is nil")
            return
        }
        
        let toHandlerName = String(toHandler.className())
        let fromControllerName = String(fromController.classForCoder)
        let typeName = type == ControllerShowType.push ? "=PUSH=" : "=PRESENT="
        print("\(typeName) \(fromControllerName) -> \(toHandlerName)")
        
        try? SimpleRouter.show(type: type, fromHandler: fromHandler, toHandler: toHandler, animated: animated, data: data)
    }
    
    func close(handler:SimpleHandler,animated:Bool) {
        try? SimpleRouter.close(handler: handler,animated: true)
    }
}
