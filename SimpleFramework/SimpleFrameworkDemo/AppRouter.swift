//
//  AppRouter.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

enum AppRootViewControllerType {
    case navigationController
    case tabbarController
    case viewController
}

enum AppRouterID {
    case test
    case test1
    case test2
    case test3
}

class AppRouter: NSObject {
    private static let appRouterInstance = AppRouter()
    var window:UIWindow!

    var tabbarCtl:UITabBarController = UITabBarController()
    var naviCtl:UINavigationController = UINavigationController()
    
    
    //MARK: Add Handler Here
    var testHandler:TestHandler!
    var test1Handler:Test1Handler!
    var test2Handler:Test2Handler!
    var test3Handler:Test3Handler!
    
    //MARK:- Function
    static let instance:AppRouter = {
        return appRouterInstance
    }()
    
    //Start AppRouter
    func start(type:AppRootViewControllerType)->Bool {
        guard let appDelegate = UIApplication.shared().delegate as? AppDelegate  else {
            print("AppDelegate is nil")
            return false
        }
        
        func startWithViewController(controller:UIViewController) {
            print("startWithViewController")
            appDelegate.window!.rootViewController = controller
        }
        
        func startWithNavigationController(controllers:Array<UIViewController>) {
            print("startWithNavigationController")
            naviCtl.viewControllers = controllers
            appDelegate.window!.rootViewController = naviCtl
        }
        
        func startWithTabBarController() {
            print("startWithTabBarController")
            let controllers = setupTabBar()
            tabbarCtl.viewControllers = controllers
            appDelegate.window!.addSubview(tabbarCtl.view)
            appDelegate.window!.rootViewController = tabbarCtl
        }
        
        func setupTabBar()->Array<UIViewController> {
            let eduCtl = setupController(handler: testHandler!)
            let newsCtl = setupController(handler: test1Handler!)
            let giftCtl = setupController(handler: test2Handler!)
            let homeCtl = setupController(handler: test3Handler!)
            eduCtl!.tabBarItem = UITabBarItem(title: "教育", image: UIImage(named: "edu"), tag: 0)
            newsCtl!.tabBarItem = UITabBarItem(title: "新闻", image: UIImage(named: "news"), tag: 0)
            giftCtl!.tabBarItem = UITabBarItem(title: "礼物", image: UIImage(named: "gift"), tag: 0)
            homeCtl!.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "home"), tag: 0)
            return [eduCtl!,newsCtl!,giftCtl!,homeCtl!]
        }
        
        initHandlers()
        let handler = testHandler
        
        switch type {
        case .navigationController:
            guard let firstController = setupController(handler: handler!) else {
                print("initRouters failed")
                return false
            }
            print("firstController is \(String(firstController.classForCoder))")
            startWithNavigationController(controllers: [firstController])
            return true
        case .tabbarController:
            startWithTabBarController()
            return true
        case .viewController:
            guard let firstController = setupController(handler: handler!) else {
                print("initRouters failed")
                return false
            }
            print("firstController is \(String(firstController.classForCoder))")
            startWithViewController(controller: firstController)
            return true
        }

        return false
    }


    func initHandlers() {
        testHandler = SimpleRouter.create(name: "Test") as! TestHandler
        test1Handler = SimpleRouter.create(name: "Test1") as! Test1Handler
        test2Handler = SimpleRouter.create(name: "Test2") as! Test2Handler
        test3Handler = SimpleRouter.create(name: "Test3") as! Test3Handler

    }
    
    func setupController(handler:SimpleHandler)->SimpleController? {
        //setupRoot
        handler.setupController(data: ["key":"value"])
        return handler.activeController
    }
    
    
}

extension AppRouter {
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
    
    func show(routerId:AppRouterID,type:ControllerShowType, fromHandler:SimpleHandler, animated:Bool, transitioning:UIViewControllerAnimatedTransitioning?,data:Dictionary<String,AnyObject>?) {
        
        
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
        
        try? SimpleRouter.show(type: type, fromHandler: fromHandler, toHandler: toHandler, animated: animated,transitioning:transitioning, data: data)
    }
    
    func close(handler:SimpleHandler,animated:Bool) {
        try? SimpleRouter.close(handler: handler,animated: true)
    }
}
