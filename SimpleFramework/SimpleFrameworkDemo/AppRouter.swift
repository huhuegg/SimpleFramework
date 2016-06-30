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
    
    static let instance:AppRouter = {
        return appRouterInstance
    }()
    
    var window:UIWindow? = {
        if let appDelegate = UIApplication.shared().delegate as? AppDelegate {
            return appDelegate.window
        }
        return nil
    }()

    //容器
    var tabbarCtl:UITabBarController = UITabBarController()
    var naviCtl:UINavigationController = UINavigationController()

    
    //TODO:- 定义所有Handler
    var testHandler:TestHandler!
    var test1Handler:Test1Handler!
    var test2Handler:Test2Handler!
    var test3Handler:Test3Handler!

    private func initHandlers() {
        testHandler = SimpleRouter.create(name: "Test") as! TestHandler
        test1Handler = SimpleRouter.create(name: "Test1") as! Test1Handler
        test2Handler = SimpleRouter.create(name: "Test2") as! Test2Handler
        test3Handler = SimpleRouter.create(name: "Test3") as! Test3Handler

    }
    
    private func getHandler(routerId:AppRouterID)->SimpleHandler? {
        switch routerId {
        case .test:
            return testHandler
        case .test1:
            return test1Handler
        case .test2:
            return test2Handler
        case .test3:
            return test3Handler
        }
    }
    
    private func setupTabBar(data:Dictionary<String,AnyObject>?)->Array<UIViewController> {
        let (_,eduCtl) = setupToHandler(routerId: .test, data: nil)
        let (_,newsCtl) = setupToHandler(routerId: .test1, data: nil)
        let (_,giftCtl) = setupToHandler(routerId: .test2, data: nil)
        let (_,homeCtl) = setupToHandler(routerId: .test3, data: nil)
        
        eduCtl!.tabBarItem = UITabBarItem(title: "教育", image: UIImage(named: "edu"), tag: 0)
        newsCtl!.tabBarItem = UITabBarItem(title: "新闻", image: UIImage(named: "news"), tag: 0)
        giftCtl!.tabBarItem = UITabBarItem(title: "礼物", image: UIImage(named: "gift"), tag: 0)
        homeCtl!.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "home"), tag: 0)
        return [eduCtl!,newsCtl!,giftCtl!,homeCtl!]
    }

}

private extension AppRouter {
    //获取指定routeId的Handler，并初始化Controller
    func setupToHandler(routerId:AppRouterID, data: Dictionary<String, AnyObject>?)->(SimpleHandler?,SimpleController?) {
        
        let toHandler = getHandler(routerId: routerId)
        //Controller初始化
        let toController = toHandler?.setupController(data: data)
        return (toHandler,toController)
        
    }
}


//MARK:- 外部调用方法
extension AppRouter {
    //Start AppRouter
    func start(firstRouterId:AppRouterID,type:AppRootViewControllerType,data:Dictionary<String,AnyObject>?)->Bool {
        //初始化所有Handler
        initHandlers()
        
        //TODO:- 指定firstHandler
        guard let firstHandler = getHandler(routerId: firstRouterId) else {
            print("firstHandler not found")
            return false
        }
        
        
        switch type {
        case .navigationController:
            guard let firstController = firstHandler.setupController(data: data) else {
                print("firstController setup failed")
                return false
            }
            print("firstController is \(firstController.className())")
            startWithNavigationController(controllers: [firstController])
        case .tabbarController:
            startWithTabBarController(data: data)
        case .viewController:
            guard let firstController = firstHandler.setupController(data: data) else {
                print("firstController setup failed")
                return false
            }
            print("firstController is \(firstController.className())")
            startWithViewController(controller: firstController)
        }
        
        return true
    }
    
    func show(routerId:AppRouterID,type:ControllerShowType, fromController:SimpleController, animated:Bool, transitioning:UIViewControllerAnimatedTransitioning?,data:Dictionary<String,AnyObject>?) {
        
        if type == .push && fromController.navigationController == nil {
            print("==PUSH== can't push from \(fromController.className()), navigationCtl is nil")
            return
        }
        
        let (handler,controller) = setupToHandler(routerId: routerId, data: data)
        
        guard let toHandler = handler else {
            print("toHandler is nil")
            return
        }
        
        guard let toController = controller else {
            print("toController is nil")
            return
        }

        
        switch type {
        case .push:
            print("==PUSH== \(fromController.className()) -> \(toController.className())")
            
            try? SimpleRouter.show(type: type, fromController: fromController, toHandler: toHandler, animated: animated,transitioning:transitioning, data: data)
        case .present:
            print("==PRESENT== \(fromController.className()) -> \(toController.className())")
            
            try? SimpleRouter.show(type: type, fromController: fromController, toHandler: toHandler, animated: animated,transitioning:transitioning, data: data)
        }
    }
    
    func close(fromController:SimpleController,animated:Bool) {
        try? SimpleRouter.close(fromController: fromController,animated: true)
    }
}

//MARK:- 内部方法
private extension AppRouter {

    func startWithViewController(controller:UIViewController) {
        print("startWithViewController")
        window!.rootViewController = controller
    }
    
    func startWithNavigationController(controllers:Array<UIViewController>) {
        print("startWithNavigationController")
        naviCtl.viewControllers = controllers
        window!.rootViewController = naviCtl
    }
    
    func startWithTabBarController(data:Dictionary<String,AnyObject>?) {
        print("startWithTabBarController")
        let controllers = setupTabBar(data:data)
        
        tabbarCtl.viewControllers = controllers
        
        //TODO:- 此处修改默认选中的Controller
        tabbarCtl.selectedIndex = 1
        window!.rootViewController = tabbarCtl
    }

}
