//
//  StringExtension.swift
//  SimpleFramework
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public extension String {
    //截取字符串
    public func simpleSubString(from:Int,length:Int)->String? {
        guard from + length <= self.characters.count else {
            return nil
        }
        
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        let toIndex = self.index(self.startIndex, offsetBy: from + length)
        let range = fromIndex ..< toIndex
        
        return self[range]
    }

}
