//
//  SimpleNetwork.swift
//  SimpleFramework
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public enum SimpleHttpResult {
    case Success(Data?)
    case Failure(NSError?)
}

open class SimpleHttpRequest: NSObject {
    public var request:URLRequest?

    public func doRequest(completionHandler:@escaping (_ result:SimpleHttpResult)->()) {
        print("doRequest")
        
        guard request != nil else {
            completionHandler(SimpleHttpResult.Failure(nil))
            return
        }
        
        let config = URLSessionConfiguration.default
        //config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)

        
        let task = urlSession.dataTask(with: request!) { (data, response, error) in
            if error != nil {
                completionHandler(SimpleHttpResult.Failure(error as NSError?))
                return
            }
            completionHandler(SimpleHttpResult.Success(data))
        }
        task.resume()
    }

    public func className()->String {
        return String(describing: self.classForCoder)
    }
}

extension SimpleHttpRequest:URLSessionDelegate,URLSessionTaskDelegate {
    //处理重定向请求，直接使用nil来取消重定向请求
    @nonobjc public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

