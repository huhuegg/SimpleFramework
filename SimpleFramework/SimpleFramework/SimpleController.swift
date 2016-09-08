//
//  SimpleController.swift
//  SimpleFramework
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public protocol SimpleControllerBroadcastProtocol {
    //callFromHandler
    func callFromHandler(dict:Dictionary<String,AnyObject>?)
}

open class SimpleController:UIViewController {
    //MARK:- Property
    public var handler:SimpleHandler?
    
    //Controller切换类型
    public var fromType:ControllerShowType = .present
    
    //Controller切换动画
    public var transitioning:UIViewControllerAnimatedTransitioning?
    
    //定义navigationControllerDelegate后右划手势返回失效，此处手动添加右划手势
    public var interactiveNaviTransition: UIPercentDrivenInteractiveTransition?
    
    //初始化数据
    public var data:Dictionary<String,AnyObject>?
    //Controller返回时需要带的数据
    public var needSendBackData:Dictionary<String,AnyObject>?
    //Controller返回收到的数据
    public var receiveBackData:Dictionary<String,AnyObject>?
    
    //Controller状态，Present/Dismiss动画使用
    public var isShowing:Bool = false

    //MARK:- ViewController Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        handler?.addController(controller: self)
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("handler:\(handler) controllers:\(handler?.controllers)")
        
        //print("\(self.className()) viewWillAppear: \(self)")
//        if let _ = receiveBackData {
//            print("\(self): viewWillAppear, data:\(data) receiveBackData:\(receiveBackData)")
//        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        if fromType == .push {
            //检测NavigationController返回按钮点击，右滑切换Controller
            if let navi = self.navigationController {
                if self.navigationController?.viewControllers.index(of: self) == nil {
                    print("统一处理NavigationController返回 **POP** \(self.className())")
                    if navi.viewControllers.count > 0 {
                        if let popToController = navi.viewControllers[navi.viewControllers.count - 1] as? SimpleController {
                            //返回数据
                            //print("set \(self.className()).needSendBackData => \(popToController.className()).receiveBackData")
                            popToController.receiveBackData = self.needSendBackData
                        }
                    }
                }
            }
        }
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        //Change controller status -> false
        self.isShowing = false
        
        if fromType == .push && self.navigationController == nil {
            print("``````````````````````````\(self.className())[\(fromType)] viewDidDisappear: \(self.navigationController)")
            handler!.removeController(controller: self)
        }
        super.viewDidDisappear(animated)
        
    }

//    deinit {
//        print("~~~ \(self.className()) deinit ~~~")
//    }
    
    
    //MARK:- Function
    public func className() ->String {
        //return String(self.classForCoder)
        return NSStringFromClass(self.classForCoder)
    }
    
    //View初始化
    open func initView() {
        self.view.backgroundColor = UIColor.white
        clearColorNavigationBarBackground()
    }

    public func setNavigationTransitioning(transitioning:UIViewControllerAnimatedTransitioning?) {
        print("\(self.className()) setNavigationTransitioning: \(transitioning)")
        if let _ = transitioning {
            self.navigationController?.delegate = self
            self.transitioning = transitioning
        }
    }
    
    public func addRecognizerOnNavigationController() {
        let naviRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SimpleController.handleNaviRecognizer(recognizer:)))
        naviRecognizer.edges = .left
        self.navigationController?.view.addGestureRecognizer(naviRecognizer)
    }
    
    public func handleNaviRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        // 获取手势在屏幕横屏范围的滑动百分比，并控制在0.0 - 1.0之间
        var progress = recognizer.translation(in: self.view).x / self.view.bounds.width
        progress = min(1.0, max(0.0, progress))
        
        switch recognizer.state {
        case .began:    // 开始滑动：初始化UIPercentDrivenInteractiveTransition对象，并开启导航pop
            interactiveNaviTransition = UIPercentDrivenInteractiveTransition()
            
            self.navigationController!.popViewController(animated: true)
        case .changed:  // 滑动过程中，根据在屏幕上滑动的百分比更新状态
            interactiveNaviTransition?.update(progress)
        case .ended, .cancelled:    // 滑动结束或取消
            //向右滑动超过50%宽度时pop,否则取消
            if progress > 0.5 {
                interactiveNaviTransition?.finish()
            } else {
                interactiveNaviTransition?.cancel()
            }
            interactiveNaviTransition = nil
        default:
            break
        }
    }

}

//MARK:- UIViewControllerTransitioningDelegate (Present/Dismiss过场动画)
extension SimpleController: UIViewControllerTransitioningDelegate {
    func setPresentTransitioning(transitioning:UIViewControllerAnimatedTransitioning?)->UIViewControllerAnimatedTransitioning? {
        print("\(self.className()) setPresentTransitioning: \(transitioning)")
        if let _ = transitioning {
            self.transitioning = transitioning
            self.transitioningDelegate = self
        }
        return transitioning
    }
    
    //UIViewControllerAnimatedTransitioning: 这个协议中提供了接口, 遵守这个协议的对象实现动画的具体内容
    public func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(self.className()) animationController forPresentedController:\(transitioning)")
        self.isShowing = true
        return transitioning
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(self.className()) animationController forDismissedController:\(transitioning)")
        self.isShowing = false
        return transitioning
    }
}

//MARK:- UINavigationControllerDelegate (Push/Pop过场动画)
extension SimpleController:UINavigationControllerDelegate  {
    
    //UIViewControllerInteractiveTransitioning: 这个协议中提供了手势交互动画的接口
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveNaviTransition
    }
    
    //UIViewControllerAnimatedTransitioning: 这个协议中提供了接口, 遵守这个协议的对象实现动画的具体内容
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("navigationController animationControllerFor from->to")
        return transitioning
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //print("navigationController willShow")
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //print("navigationController didShow")
    }
}

//MARK:- UITabBarController自定义转场动画
extension SimpleController:UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitioning
    }
}
