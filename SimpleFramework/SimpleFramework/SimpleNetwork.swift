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

public class SimpleHttpRequest: NSObject {
    public var request:URLRequest?

    public func doRequest(completionHandler:(result:SimpleHttpResult)->()) {
        print("doRequest")
        
        guard request != nil else {
            completionHandler(result: SimpleHttpResult.Failure(nil))
            return
        }
        
        let config = URLSessionConfiguration.default()
        //config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)

        
        let task = urlSession.dataTask(with: request!) { (data, response, error) in
            if error != nil {
                completionHandler(result: SimpleHttpResult.Failure(error))
                return
            }
            completionHandler(result: SimpleHttpResult.Success(data))
        }
        task.resume()
    }

    public func className()->String {
        return String(self.classForCoder)
    }
}

extension SimpleHttpRequest:URLSessionDelegate,URLSessionTaskDelegate {
    //处理重定向请求，直接使用nil来取消重定向请求
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

