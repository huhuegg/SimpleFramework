//
//  LineContentRequest.swift
//  SimpleFramework
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 egg. All rights reserved.
//

import SimpleFramework

class LineContentRequest: SimpleHttpRequest {
    var sid:String = ""
    
    init(sid:String) {
        super.init()
        self.sid = sid
        self.setup()
    }
    
    private func setup() {
        let url = URL(string: "http://shanghaicity.openservice.kankanews.com/public/bus/mes/sid/\(sid)")
        
        let req = NSMutableURLRequest(url: url!)
        req.httpMethod = "GET"
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
        let doc = HTML(html: data, encoding: String.Encoding.utf8)
        let bodyNode = doc?.body
        
        // Search for nodes by XPath
        for node in (bodyNode?.xpath("//div", namespaces: ["class" : "busDirection"]))! {
            //print(node.toHTML)
            
            for subnode in (node.xpath("//span")) {
                print(subnode.toHTML)
            }
        }
        
//        if let inputNodes = bodyNode?.findChildTags("a") {
//            for node in inputNodes {
//                println(node.contents)  //取得内容
//                println(node.getAttributeNamed("href")) //取得属性值
//                
//            }
//        }
        return nil
    }
 }
