//
//  ControllerAnimationExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

//MARK:- Controller过场动画

// Present or Dismiss
extension SimpleController: UIViewControllerTransitioningDelegate {
    
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


// Push or Pop
extension SimpleController:UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("navigationController animationControllerFor from->to")
        return controllerAnimatedTransitioning
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("navigationController willShow")
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController didShow")
    }
}
