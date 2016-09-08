//
//  SimpleControllerAnimation.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

//MARK:- 过场动画
open class SimpleControllerAnimatedTransitioning:NSObject,UIViewControllerAnimatedTransitioning {
    public var duration:TimeInterval = 0.4
    
    public init(duration:TimeInterval) {
        super.init()
        self.duration = duration
    }
    
    // 指定转场动画持续的时间
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 实现转场动画的具体内容
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //使用containerView获取到当前的containerView, 将要执行动画的view都在这个containerView上进行
        let containerView = transitionContext.containerView
        
        guard getToController(transitionContext: transitionContext) != nil else {
            print("toController is nil")
            transitionContext.completeTransition(true)
            return
        }
        
        //
        _ = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        // 目标视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        containerView.addSubview(toView)
        
        // 为目标视图的展现添加动画
        toView.alpha = 0.0
        UIView.animate(withDuration: duration,
                                   animations: {
                                    toView.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    public func getToController(transitionContext:UIViewControllerContextTransitioning)->SimpleController? {
        
        var toController:SimpleController?
        
        if let naviCtl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController {
            if naviCtl.viewControllers.count > 0 {
                guard let ctl = naviCtl.viewControllers[naviCtl.viewControllers.count - 1] as? SimpleController else {
                    print("toController is not SimpleController")
                    return nil
                }
                toController = ctl
            }
        } else if let tabBarCtl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UITabBarController {
            guard let ctl = tabBarCtl.selectedViewController as? SimpleController else {
                print("toController is not SimpleController")
                return nil
            }
            toController = ctl
        } else {
            if let ctl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SimpleController {
                toController = ctl
            }
        }
        return toController
    }
}
