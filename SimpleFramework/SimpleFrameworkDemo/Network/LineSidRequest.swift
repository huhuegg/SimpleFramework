//
//  LineSidRequest.swift
//  SimpleFramework
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 egg. All rights reserved.
//

import SimpleFramework



class LineSidRequest:SimpleHttpRequest,AppHttpRequestProtocol {
    
    var search:String = ""
    
    //init
    init(search:String) {
        super.init()
        self.search = search
        self.setupRequest()
    }
    
    //初始化request
    internal func setupRequest() {
        let url = URL(string: "http://shanghaicity.openservice.kankanews.com/public/bus/get")
        
        //postData
        let postData = "idnum=\(self.search)路".data(using: String.Encoding.utf8)
        
        let req = NSMutableURLRequest(url: url!)
        req.httpMethod = "POST"
        req.httpBody = postData
        
        self.request = req as URLRequest
    }
    
    //doRequest
    internal func request(completionHandler: @escaping (AppHttpResponse) -> ()) {
        doRequest { (result) in
            //result
            var sid:String?
            
            switch result {
            case let .Success(data):
                sid = AppNetworkDataConvert.ToSid(data: data)
                break
            case let .Failure(error):
                print("\(self.className()) : \(error.debugDescription)")
                break
            }
            let resp = AppHttpResponse.respLineSid(sid: sid)
            completionHandler(resp)
        }
    }

}
