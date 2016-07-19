//
//  LineSidRequest.swift
//  SimpleFramework
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 egg. All rights reserved.
//

import SimpleFramework


class LineSidRequest:SimpleHttpRequest {
    var search:String = ""
    
    init(search:String) {
        super.init()
        self.search = search
        self.setup()
    }
    
    private func setup() {
        let url = URL(string: "http://shanghaicity.openservice.kankanews.com/public/bus/get")
        
        //postData
        let postData = "idnum=\(self.search)路".data(using: String.Encoding.utf8)
        
        let req = NSMutableURLRequest(url: url!)
        req.httpMethod = "POST"
        req.httpBody = postData
        req.setValue("ansoecdxc=oY1pTw1R0Nhy7b_Z2A78eRuc8_j8", forHTTPHeaderField: "Cookie")
        
        self.request = req as URLRequest
    }
    
    func request(completionHandler:(String?) -> ()) {
        doRequest { (data, error) in
            if let _ = data {
                let sid = self.convertData(data: data!)
                completionHandler(sid)
            }
        }
    }
    
    private func convertData(data:Data)->String? {
        let json = JSON(data: data)
        return json["sid"].string
    }
}
