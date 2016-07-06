//
//  Test3ControllerAnimation.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework


//缩放
class PresentControllerBoxAnimation: SimpleControllerAnimatedTransitioning {
    override func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    override func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // 得到容器视图
        let containerView = transitionContext.containerView()
        
        guard let toController = getToController(transitionContext: transitionContext) else {
            print("toController is nil")
            transitionContext.completeTransition(true)
            return
        }
        
        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
        let toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
        
        if toController.isShowing {
            print("present")
            containerView.addSubview(toView)
            
            // 为Present添加动画
            let toViewFrame = toView.frame
            toView.frame = CGRect(origin: toView.center, size: CGSize(width: 0, height: 0))
            UIView.animate(withDuration: duration,
                           animations: {
                            toView.frame = toViewFrame
                            toView.layoutIfNeeded()
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })
        } else {
            print("dismiss")
            containerView.insertSubview(toView, belowSubview: fromView)
            
            
            // 为dismiss添加动画
            fromView.alpha = 0.8
            fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.size.width, height: fromView.frame.size.height)
            
            UIView.animate(withDuration: duration,
                           animations: {
                            fromView.alpha = 0
                            fromView.frame = CGRect(x: fromView.frame.size.width/2, y: fromView.frame.size.height/2, width: 0, height: 0)
                            fromView.layoutIfNeeded()
                            //print("animate:\(fromView.frame)")

                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })

        }

    }
}
