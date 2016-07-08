//
//  UIViewExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/7/7.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    //指定xib
    public class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    //截图
    public class func imageFromView(v:UIView)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(v.bounds.size, v.isOpaque, 0.0)
        v.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
