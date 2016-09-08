//
//  AppNetwork.swift
//  SimpleFramework
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

public enum AppHttpRequest {
    case reqLineSid(search:String)
}

public enum AppHttpResponse {
    case respLineSid(sid:String?)
}

protocol AppHttpRequestProtocol {
    func setupRequest()
    func request(completionHandler:@escaping (AppHttpResponse) -> ())
}

class AppNetwork: NSObject {
    class func request(request:AppHttpRequest, completionHandler:@escaping (_ resp:AppHttpResponse)->()) {
        switch request {
        case let .reqLineSid(search):
            LineSidRequest(search: search).request(completionHandler: { (resp) in
                completionHandler(resp)
            })
        }
    }
    
}

//MARK:- Convert http response data
class AppNetworkDataConvert {
    class func ToSid(data:Data?)->String? {
        guard let d = data else {
            print("AppNetworkDataConvert failed, data is nil")
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let dict = json as? Dictionary<String,AnyObject> else {
                print("AppNetworkDataConvert failed, can't convert data to json as Dictionary")
                return nil
            }
            
            guard let sid = dict["sid"] as? String else {
                return nil
            }
            
            return sid
        } catch _ {
            print("AppNetworkDataConvert failed, can't convert data to json")
            return nil
        }
        
    }
}
