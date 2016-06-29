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
    public var duration = 1.0
    
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
                transitionContext.completeTransition(true)
        })
    }
}


