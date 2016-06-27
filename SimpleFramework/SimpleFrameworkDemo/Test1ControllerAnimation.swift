//
//  Test1ControllerAnimation.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test1ControllerAnimation: SimpleControllerAnimation {
    override func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    override func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
//        // 得到容器视图
//        let containerView = transitionContext.containerView()
//        
//        var toController:SimpleController?
//        
//        if let naviCtl = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? UINavigationController {
//            if naviCtl.viewControllers.count > 0 {
//                if let ctl = naviCtl.viewControllers[naviCtl.viewControllers.count - 1] as? SimpleController {
//                    toController = ctl
//                }
//            }
//        } else {
//            if let ctl = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? SimpleController {
//                toController = ctl
//            }
//        }
//        
//        guard let _ = toController else {
//            print("toController is not SimpleController")
//            transitionContext.completeTransition(true)
//            return
//        }
//        
//        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
//        let toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
//        
//        if toController!.isShowing {
//            print("present")
//            containerView.addSubview(toView)
//            
//            // 为Present添加动画
//            toView.frame = CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
//            UIView.animate(withDuration: duration,
//                           animations: {
//                            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
//                            
//                }, completion: { _ in
//                    transitionContext.completeTransition(true)
//            })
//        } else {
//            print("dismiss")
//            containerView.insertSubview(toView, belowSubview: fromView)
//            
//            
//            // 为dismiss添加动画
//            fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
//            UIView.animate(withDuration: duration,
//                           animations: {
//                            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
//                }, completion: { _ in
//                    transitionContext.completeTransition(true)
//            })
//            
//        }
//        
//        
//        
//        
//        
//        
    }
}
