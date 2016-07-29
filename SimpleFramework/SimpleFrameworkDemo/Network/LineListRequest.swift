//
//  LineListRequest.swift
//  SimpleFramework
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 egg. All rights reserved.
//

import SimpleFramework

class LineListRequest: SimpleHttpRequest {
    var lineList:Array<String> = Array()
    
    override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        let url = URL(string: "http://shanghaicity.openservice.kankanews.com/public/bus")
        
        let req = NSMutableURLRequest(url: url!)
        req.httpMethod = "GET"
        //req.setValue("shanghaicity.openservice.kankanews.com", forHTTPHeaderField: "Cookie")
        //req.setValue("ansoecdxc=oY1pTw1R0Nhy7b_Z2A78eRuc8_sc", forHTTPHeaderField: "Cookie")
        self.request = req as URLRequest
    }
    
    func request(completionHandler:(Array<String>) -> ()) {
        doRequest { (data, error) in
            //print("data:\(data)")
            self.lineList = self.convertData(data: data!)
            completionHandler(self.lineList)
        }
    }
    
    private func convertData(data:Data)->Array<String> {
        guard let str = String(data: data, encoding: String.Encoding.utf8) else {
            return Array()
        }
        for l in str.components(separatedBy: "\n") {
            //print("l:\(l)")
            let cleanText = l.replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\t", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ";", with: "")
            .replacingOccurrences(of: "'", with: "\"")
            if cleanText.hasPrefix("vardata=[") {
                //print("varData:\(cleanText)")
                if let s = cleanText.components(separatedBy: "=").last {
                    //print("s:\(s)")
                    if let d = s.data(using: String.Encoding.utf8) {
                        let json = JSON(data: d)
                        print(json)
                    }
                    
                    let json = JSON(s)
                    
                    if let arr = json.arrayObject as? Array<String> {
                        return arr
                    }
                }
            }
            
        }
        return Array()
    }
}
