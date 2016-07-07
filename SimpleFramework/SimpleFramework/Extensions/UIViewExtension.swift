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
    func imageFromView(v:UIView)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(v.bounds.size, v.isOpaque, 0.0)
        v.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
