//
//  SimpleRouter.swift
//  SimpleFramework
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
//重要的事情说三遍：public public public

public protocol SimpleRouterProtocol {
    func setupController(data:Dictionary<String,AnyObject>?)
}

public enum SimpleRouterError:ErrorProtocol {
    case fromControllerNil
    case toHandlerNil
    case toControllerNil
    case naviNil
    case naviViewControllersCountError
    case naviViewControllersLastNotMatch
    case presentBackControllerNil
}

public class SimpleRouter: NSObject {

    public class func create(name:String)->SimpleHandler {
        print("SimpleRouter create -> \(name)")
        let handler = createHandler(name: name)
        handler.name = name
        
        return handler
    }
    
    private class func createHandler(name:String)->SimpleHandler {
        let handlerName = name + "Handler"
        
        let appName = Bundle.main().objectForInfoDictionaryKey("CFBundleName") as! String
        let className = "_TtC\(appName.characters.count)\(appName)\(handlerName.characters.count)\(handlerName)"
        
        let handlerClass = NSClassFromString(className) as! SimpleHandler.Type
        //SimpleHandler的init()需要加上required修饰符
        return  handlerClass.init()
    }

    public class func show(type:ControllerShowType,fromHandler:SimpleHandler,toHandler:SimpleHandler,animated:Bool,transitioning:UIViewControllerAnimatedTransitioning?,data:Dictionary<String,AnyObject>?) throws {

        guard let fromController = fromHandler.activeController else {
            print("show need fromHandler activeController")
            throw SimpleRouterError.fromControllerNil
        }

        guard let toController = toHandler.activeController else {
            print("toHandler.activeController is nil")
            throw SimpleRouterError.toControllerNil
        }
        toController.receiveBackData = nil
        toController.needSendBackData = nil
        toController.fromType = type
        
        switch type {
        case .push:
            guard let naviCtl = fromController.navigationController else {
                print("Can't find naviCtl, Push failed!")
                throw SimpleRouterError.naviNil
            }
            guard naviCtl.viewControllers.count > 0 else {
                print("FromController is not in naviCtl.viewControllers, can't Push!")
                throw SimpleRouterError.naviViewControllersCountError
            }
            
            guard naviCtl.viewControllers[naviCtl.viewControllers.count - 1] == fromController else {
                print("naviCtl.viewControllers.last is not self, FAILED!")
                throw SimpleRouterError.naviViewControllersLastNotMatch
            }
            
            //NavigationController自定义过场动画
            if let _ = transitioning {
                //NavigationControll过场动画的delegate在发起Push的Controller上 (fromController)
                fromController.setNavigationTransitioning(transitioning: transitioning)
                //添加滑动返回手势
                toController.addPopRecognizer()
            }
            
            naviCtl.pushViewController(toController, animated: animated)
        case .present:
            //ViewControll过场动画的delegate在被Present的Controller上 (toController)
            toController.setPresentTransitioning(transitioning: transitioning)
            fromController.present(toController, animated: animated, completion: {
            })
        }

    }

    public class func close(handler:SimpleHandler,animated:Bool) throws {
        guard let controller = handler.activeController else {
            print("show need fromHandler activeController")
            throw SimpleRouterError.fromControllerNil
        }
        
        let willCloseControllerName = String(controller.classForCoder)
        switch controller.fromType {
        case .push:
            guard let naviCtl = controller.navigationController else {
                print("Can't find naviCtl, POP failed!")
                throw SimpleRouterError.naviNil
            }
            guard naviCtl.viewControllers.count > 1 else {
                print("Only one controller, can't POP!")
                throw SimpleRouterError.naviViewControllersCountError
            }
            
            guard naviCtl.viewControllers[naviCtl.viewControllers.count - 1] == controller else {
                print("naviCtl.viewControllers.last is not self, FAILED!")
                throw SimpleRouterError.naviViewControllersLastNotMatch
            }
            guard let popToController = naviCtl.viewControllers[naviCtl.viewControllers.count - 2] as? SimpleController else {
                print("can't find popToController")
                throw SimpleRouterError.naviViewControllersCountError
            }
            
            print("**POP** \(willCloseControllerName) -> \(String(popToController.classForCoder))")

            popToController.receiveBackData = controller.needSendBackData
            
            naviCtl.popViewController(animated: animated)
            //Navigation leftButton返回和手势右滑不会调用此方法,部分操作需要在viewDidDisappear执行
            //  popToController.receiveBackData = data


            
        case .present:
            if let navi = controller.presentingViewController as? UINavigationController { ////发起present的是UINavigationController
                guard navi.viewControllers.count > 0 else {
                    print("Is present from navigation,but navigation.viewControllers is empty")
                    throw SimpleRouterError.naviViewControllersCountError
                }
                guard let backController = navi.viewControllers[navi.viewControllers.count - 1] as? SimpleController else {
                    print("Is present from navigation,but last is not SimpleController")
                    throw SimpleRouterError.naviViewControllersLastNotMatch
                }
                backController.receiveBackData = controller.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(backController.classForCoder))")
                controller.dismiss(animated: animated, completion: {
                })

            } else if let tabBarCtl = controller.presentingViewController as? UITabBarController { //发起present的是UITabBarController
                guard let backController = tabBarCtl.selectedViewController as? SimpleController else {
                    print("PresentBackController is nil")
                    throw SimpleRouterError.presentBackControllerNil
                }
                backController.receiveBackData = controller.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(backController.classForCoder))")
                backController.dismiss(animated: animated, completion: {
                })
            } else {
                guard let backController = controller.presentingViewController as? SimpleController else {
                    print("PresentBackController is nil")
                    throw SimpleRouterError.presentBackControllerNil
                }
                backController.receiveBackData = controller.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(backController.classForCoder))")
                controller.dismiss(animated: animated, completion: {
                })
            }

        }

    }
}
