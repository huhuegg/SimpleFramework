//
//  AppNetwork.swift
//  SimpleFramework
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework


typealias lineSid = String?


class AppNetwork: NSObject {
    class func lineSidRequest(search:String, completionHandler: (String?) -> ()) {
        LineSidRequest(search: search).request { (sid) in
            completionHandler(sid)
            LineContentRequest(sid: sid!).request(completionHandler: { (html) in
                
            })
        }
    }
    
}



