//
//  SimpleControllerAnimation.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

//MARK:- 过场动画
public class SimpleControllerAnimatedTransitioning:NSObject,UIViewControllerAnimatedTransitioning {
    public var duration:TimeInterval = 0.4
    
    public init(duration:TimeInterval) {
        super.init()
        self.duration = duration
    }
    
    // 指定转场动画持续的时间
    public func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 实现转场动画的具体内容
    public func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        //使用containerView获取到当前的containerView, 将要执行动画的view都在这个containerView上进行
        let containerView = transitionContext.containerView()
        
        guard let toController = getToController(transitionContext: transitionContext) else {
            print("toController is nil")
            transitionContext.completeTransition(true)
            return
        }
        
        //
        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
        // 目标视图
        let toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
        
        containerView.addSubview(toView)
        
        // 为目标视图的展现添加动画
        toView.alpha = 0.0
        UIView.animate(withDuration: duration,
                                   animations: {
                                    toView.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}

extension SimpleControllerAnimatedTransitioning {
    public func getToController(transitionContext:UIViewControllerContextTransitioning)->SimpleController? {
        
        var toController:SimpleController?
        
        if let naviCtl = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? UINavigationController {
            if naviCtl.viewControllers.count > 0 {
                guard let ctl = naviCtl.viewControllers[naviCtl.viewControllers.count - 1] as? SimpleController else {
                    print("toController is not SimpleController")
                    return nil
                }
                toController = ctl
            }
        } else if let tabBarCtl = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? UITabBarController {
            guard let ctl = tabBarCtl.selectedViewController as? SimpleController else {
                print("toController is not SimpleController")
                return nil
            }
            toController = ctl
        } else {
            if let ctl = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? SimpleController {
                toController = ctl
            }
        }
        return toController
    }
}

