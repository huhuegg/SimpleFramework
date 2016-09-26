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
    func setupController(data:Dictionary<String,AnyObject>?)->SimpleController?
}

public enum SimpleRouterError:Error {
    case fromControllerNil
    case toHandlerNil
    case toControllerNil
    case naviNil
    case naviViewControllersCountError
    case naviViewControllersLastNotMatch
    case presentBackControllerNil
}

open class SimpleRouter: NSObject {
    ///创建Handler
    public class func create(name:String)->SimpleHandler {
        print("SimpleRouter create -> \(name)")
        let handler = createHandler(name: name)
        handler.name = name
        
        return handler
    }
    
    private class func createHandler(name:String)->SimpleHandler {
        let handlerName = name + "Handler"
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let className = "_TtC\(appName.characters.count)\(appName)\(handlerName.characters.count)\(handlerName)"
        
        let handlerClass = NSClassFromString(className) as! SimpleHandler.Type
        //SimpleHandler的init()需要加上required修饰符
        return  handlerClass.init()
    }

    /**
        跳转至下一个Controller
     
        - Parameter type: push / present / present一个NavigationController
        - Parameter fromController: 当前SimpleController
        - Parameter toHandler: 目标Handler
        - Parameter animated: 是否有切换动画
        - Parameter transitioning: 自定义过场动画
        - Parameter data: 可选的传递数据
     
        - Returns: Void
    */
    public class func show(type:ControllerShowType,fromController:SimpleController,toHandler:SimpleHandler,animated:Bool,transitioning:UIViewControllerAnimatedTransitioning?,data:Dictionary<String,AnyObject>?) throws {

        guard let toController = toHandler.setupController(data: data) else {
            print("toController setup failed")
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
            
//            guard naviCtl.viewControllers[naviCtl.viewControllers.count - 1] == fromController else {
//                print("naviCtl.viewControllers.last is not self, FAILED!")
//                throw SimpleRouterError.naviViewControllersLastNotMatch
//            }
            
            //NavigationController自定义过场动画
            if let _ = transitioning {
                //NavigationControll过场动画的delegate在发起Push的Controller上 (fromController)
                fromController.setNavigationTransitioning(transitioning: transitioning)
            }
            naviCtl.pushViewController(toController, animated: animated)
        case .present:
            //ViewControll过场动画的delegate在被Present的Controller上 (toController)
            let _ = toController.setPresentTransitioning(transitioning: transitioning)
            fromController.present(toController, animated: animated, completion: {
            })
        case .presentNavi:
            let navi = UINavigationController()
            navi.viewControllers = [toController]
            
            //ViewControll过场动画的delegate在被Present的Controller上 (toController)
            let _ = toController.setPresentTransitioning(transitioning: transitioning)
            fromController.present(navi, animated: animated, completion: {
            })
        }

    }

    /**
     返回上一个Controller
     
     - Parameter type: push / present / present一个NavigationController
     - Parameter fromController: 当前SimpleController
     - Parameter animated: 是否有过场动画

     - Returns: Void
     */
    public class func close(fromController:SimpleController,animated:Bool) throws {

        let willCloseControllerName = String(describing: fromController.classForCoder)
        switch fromController.fromType {
        case .push:
            guard let naviCtl = fromController.navigationController else {
                print("Can't find naviCtl, POP failed!")
                throw SimpleRouterError.naviNil
            }
            guard naviCtl.viewControllers.count > 1 else {
                print("Only one controller, can't POP!")
                throw SimpleRouterError.naviViewControllersCountError
            }
            
//            guard naviCtl.viewControllers[naviCtl.viewControllers.count - 1] == fromController else {
//                print("naviCtl.viewControllers.last is not self, FAILED!")
//                throw SimpleRouterError.naviViewControllersLastNotMatch
//            }
            guard let popToController = naviCtl.viewControllers[naviCtl.viewControllers.count - 2] as? SimpleController else {
                print("can't find popToController")
                throw SimpleRouterError.naviViewControllersCountError
            }
            
            print("**POP** \(willCloseControllerName) -> \(String(describing: popToController.classForCoder))")

//            popToController.receiveBackData = fromController.needSendBackData
            
            naviCtl.popViewController(animated: animated)
            //Navigation leftButton返回和手势右滑不会调用此方法,部分操作需要在viewDidDisappear执行
            //  popToController.receiveBackData = data
            
            //fromController.handler?.removeController(controller: fromController)


            
        case .present,.presentNavi:
            if let navi = fromController.presentingViewController as? UINavigationController { ////发起present的是UINavigationController
                guard navi.viewControllers.count > 0 else {
                    print("Is present from navigation,but navigation.viewControllers is empty")
                    throw SimpleRouterError.naviViewControllersCountError
                }
                guard let backController = navi.viewControllers[navi.viewControllers.count - 1] as? SimpleController else {
                    print("Is present from navigation,but last is not SimpleController")
                    throw SimpleRouterError.naviViewControllersLastNotMatch
                }
                backController.receiveBackData = fromController.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(describing: backController.classForCoder))")
                fromController.dismiss(animated: animated, completion: {
                    print("dismiss to naviCtl")
                    fromController.handler?.removeController(controller: fromController)
                })

            } else if let tabBarCtl = fromController.presentingViewController as? UITabBarController { //发起present的是UITabBarController
                guard let backController = tabBarCtl.selectedViewController as? SimpleController else {
                    print("PresentBackController is nil")
                    throw SimpleRouterError.presentBackControllerNil
                }
                backController.receiveBackData = fromController.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(describing: backController.classForCoder))")
                fromController.dismiss(animated: animated, completion: {
                    print("dismiss to tabBarCtl")
                    fromController.handler?.removeController(controller: fromController)
                })
            } else {
                guard let backController = fromController.presentingViewController as? SimpleController else {
                    print("PresentBackController is nil")
                    throw SimpleRouterError.presentBackControllerNil
                }
                backController.receiveBackData = fromController.needSendBackData
                print("**DISMISS** \(willCloseControllerName) -> \(String(describing: backController.classForCoder))")
                fromController.dismiss(animated: animated, completion: {
                    print("dismiss to ctl")
                    fromController.handler?.removeController(controller: fromController)
                })
            }

        }

    }
}
