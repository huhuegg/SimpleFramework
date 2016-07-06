//
//  TestData.swift
//  SimpleFramework
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

struct TestData {
    let title:String!
    
    init(title t:String) {
        title = t
    }
}

struct TestDataList {
    var data:Array<TestData>=Array()
    
    mutating func appendData(appendData:Array<TestData>) {
        data += appendData
    }
    
    mutating func clearData() {
        data = Array()
    }
}
