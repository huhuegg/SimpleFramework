//
//  SimpleNetwork.swift
//  SimpleFramework
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit


public class SimpleHttpRequest: NSObject {
    public var request:URLRequest?
    
    
    

    public func doRequest(completionHandler:(Data?,ErrorProtocol?) -> ()) {
        guard request != nil else {
            completionHandler(nil,nil)
            return
        }
        NSURLConnection.sendAsynchronousRequest(request!, queue: OperationQueue.init()) { (response, data, error) in
            if error == nil {
                if let resp = response as? HTTPURLResponse {
                    print("code: \(resp.statusCode)")
                    completionHandler(data, nil)
                    return
//                    if let d = data {
//                        
////                        let s = String(data: d, encoding: String.Encoding.utf8)
////                        print("str:\(s)")
//                    }
                } else {
                    print("is not HTTPURLResponse:\(response)")
                }
            } else {
                print("error:\(error)")
            }
            completionHandler(nil, nil)
        }
    }
}

////        //cookie
//var dictCookie:Dictionary<String,String> = Dictionary()
//
////postData
//let postData = "idnum=46路".data(using: String.Encoding.utf8)
//
////request
//let req = NSMutableURLRequest(url: url!)
//req.httpMethod = "POST"
//req.httpBody = postData
//req.setValue("ansoecdxc=oY1pTw1R0Nhy7b_Z2A78eRuc8_j8", forHTTPHeaderField: "Cookie")
//
//NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue.main()) { (response, data, error) in
//    if error == nil {
//        if let resp = response as? HTTPURLResponse {
//            print("code: \(resp.statusCode)")
//            if let d = data {
//                let s = String(data: d, encoding: String.Encoding.utf8)
//                print("str:\(s)")
//            }
//        } else {
//            print("is not HTTPURLResponse:\(response)")
//        }
//    } else {
//        print("error:\(error)")
//    }
//}
