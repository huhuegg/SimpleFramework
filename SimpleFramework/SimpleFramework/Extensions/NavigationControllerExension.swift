//
//  NavigationExension.swift
//  SimpleFramework
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

//MARK:- NavigationController扩展
extension SimpleController {
    
    //MARK:- 设置状态栏样式
    public func changeStatusBarStyle(_ statusBarStyle:UIStatusBarStyle) {
        //动态修改状态栏样式必须在Info.plist中将View controller-based status bar appearance设置为NO

        UIApplication.shared().setStatusBarStyle(statusBarStyle, animated: false)
        //当某页面已经显示的时候需要动态地更改状态栏样式
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK:- 修改标题颜色
    public func changeTitleColor(_ titleColor:UIColor) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:titleColor]
    }
    
    //MARK:- 修改导航栏背景颜色
    public func changeBackgroundColor(_ tintColor:UIColor) {
        self.navigationController?.navigationBar.barTintColor = tintColor
    }
    
    //MARK:- 设置NavigationBar透明
    public func clearColorNavigationBarBackground() {
        //setBackgroundImage实际是设置ImageView子视图
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //导航栏下的细线
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}

