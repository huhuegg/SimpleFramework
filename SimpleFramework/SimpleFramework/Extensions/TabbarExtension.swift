//
//  TabbarExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/7/5.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public extension UITabBarController {
    //为tabBarButton添加点击事件和动画效果
    public func addTargetForTabBarButtonClicked(animated:Bool) {
        for subview in self.view.subviews {
            if let tabBar = subview as? UITabBar {
                for tabBarSubview in tabBar.subviews {
                    if let tabBarButton = tabBarSubview as? UIControl {
                        tabBarButton.addTarget(self, action: #selector(UITabBarController.tabBarButtonClicked(tabBarButton:animated:)), for: UIControlEvents.touchUpInside)
                    }
                }
            }
        }
    }
    
    public func tabBarButtonClicked(tabBarButton:UIControl, animated:Bool) {
        if animated {
            addAnimatedOnTabBarButtonClicked(tabBarButton: tabBarButton)
        }
    }
    
    fileprivate func addAnimatedOnTabBarButtonClicked(tabBarButton:UIControl) {
        for view in tabBarButton.subviews {
            if String(describing: view.classForCoder) == "UITabBarSwappableImageView" {
                let animation = SimpleKeyframeAnimation.tabBarAnimation()
                //添加layer动画
                view.layer.add(animation, forKey: nil)
            }
        }
    }
}

public extension UITabBarItem {
    //自定义显示方式及修改相对位置
    public func customSetup(renderingMode:UIImageRenderingMode,selectImage:UIImage?,selectRenderingMode:UIImageRenderingMode?,customImageInsets:UIEdgeInsets?)->UITabBarItem {
        guard let normalImage = image else {
            return self
        }
        //设置默认图片的显示方式
        image = normalImage.withRenderingMode(renderingMode)
        
        //设置选中的图片和图片的显示方式
        if let _ = selectImage {
            if let _ = selectRenderingMode {
                selectedImage = selectImage!.withRenderingMode(selectRenderingMode!)
            } else {
                selectedImage = selectImage!
            }
        }
        
        //修改相对位置
        if let _ = customImageInsets {
            imageInsets = customImageInsets!
        }
        return self
    }
}
