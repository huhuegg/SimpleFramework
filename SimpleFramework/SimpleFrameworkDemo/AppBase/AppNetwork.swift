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
    func request(completionHandler:(AppHttpResponse) -> ())
}

class AppNetwork: NSObject {
    class func request(request:AppHttpRequest, completionHandler:(resp:AppHttpResponse)->()) {
        switch request {
        case let .reqLineSid(search):
            LineSidRequest(search: search).request(completionHandler: { (resp) in
                completionHandler(resp: resp)
            })
        }
    }
    
}

//MARK:- Convert http response data
class AppNetworkDataConvert {
    class func ToSid(data:Data?)->String? {
        guard let d = data else {
            return nil
        }
        let json = JSON(data: d)
        let sid = json["sid"].string
        return sid
    }
}
