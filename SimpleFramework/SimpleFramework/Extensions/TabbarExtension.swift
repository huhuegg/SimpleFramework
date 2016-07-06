//
//  TabbarExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/7/5.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

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
