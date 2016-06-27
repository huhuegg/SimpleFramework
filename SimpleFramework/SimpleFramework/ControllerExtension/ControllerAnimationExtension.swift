//
//  ControllerAnimationExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

//MARK:- Controller过场动画
extension SimpleController: UIViewControllerTransitioningDelegate {
    public func setControllerAnimation(transitioning:UIViewControllerAnimatedTransitioning?) {
        if let _ = transitioning {
            self.transitioningDelegate = self
            self.controllerAnimatedTransitioning = transitioning
            if fromType == .present {
                self.modalPresentationStyle = UIModalPresentationStyle.custom
            }
        }
    }
    
    public func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(String(self.classForCoder)) animationController forPresentedController")
        self.isShowing = true
        return controllerAnimatedTransitioning
    }
    
    public func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(String(self.classForCoder)) animationController forDismissedController")
        self.isShowing = false
        return controllerAnimatedTransitioning
    }
}
