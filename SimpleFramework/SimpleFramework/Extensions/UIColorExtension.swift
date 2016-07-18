//
//  UIColorExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public extension UIColor {
    //将十六进制颜色转RGB颜色(#RRGGBB)
    public class func simpleColorWithHex(hexStr:String,alpha:CGFloat?)->UIColor {
        //#RRGGBB
        guard hexStr.hasPrefix("#") else {
            print("hexStr(\(hexStr)) not hasPrefix #")
            return UIColor.clear()
        }
        
        let rgbIndex = hexStr.index(after: hexStr.startIndex)
        //RRGGBB
        let rgb = hexStr.substring(from: rgbIndex)
        
        
        guard rgb.characters.count == 6 else {
            print("hexStr(\(rgb) count:\(rgb.characters.count)) error!")
            return UIColor.clear()
        }
        
        if let rStr = rgb.simpleSubString(from:0,length:2), let gStr = rgb.simpleSubString(from:2,length:2), let bStr = rgb.simpleSubString(from:4,length:2) {
            var r:UInt32 = 0
            var g:UInt32 = 0
            var b:UInt32 = 0
            
            Scanner(string: rStr.uppercased()).scanHexInt32(&r)
            Scanner(string: gStr.uppercased()).scanHexInt32(&g)
            Scanner(string: bStr.uppercased()).scanHexInt32(&b)
            
            if let _ = alpha {
                return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha!)
            } else {
                return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
            }
        }
        return UIColor.clear()
    }
}
