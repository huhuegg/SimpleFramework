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
        //req.setValue("shanghaicity.openservice.kankanews.com", forHTTPHeaderField: "Cookie")
        //req.setValue("ansoecdxc=oY1pTw1R0Nhy7b_Z2A78eRuc8_sc", forHTTPHeaderField: "Cookie")
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
        func cheanText(str:String)->String {
            return str.replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\t", with: "")
                .replacingOccurrences(of: " ", with: "")
        }
        func findDiv(on:XMLElement, className:String,fromRoot:Bool)->Array<XMLElement> {
            var arr:Array<XMLElement> = Array()
            let search = fromRoot == true ? "//div":".//div"
            
            for divNode in (on.xpath(search)) {
                if divNode.className == className {
                    //print("== \(className) ==")
                    arr.append(divNode)
                }
            }
            return arr
        }
        
        func pText(on:XMLElement)->String {
            var str = ""
            
            for pNode in (on.xpath(".//p")) {
                if let text = pNode.text {
                    str += cheanText(str: text)
                }
            }
            return str
        }
        
        func spanText(on:XMLElement,className:String?)->String {
            //print("spanText:\(on.className)")
            var str = ""
            
            if let cName = className {
                for spanNode in (on.xpath(".//span")) {
                    if spanNode["class"] == cName {
                        if let text = spanNode.text {
                            str = cheanText(str: text)
                        }
                    }
                }
            } else {
                for spanNode in (on.xpath(".//span")) {
                    if let text = spanNode.text {
                        str += cheanText(str: text)
                    }
                }

            }
            return str
        }
        
        func emText(on:XMLElement,className:String)->String {
            var str = ""
            for emNode in (on.xpath(".//em")) {
                if emNode["class"] == className {
                    if let text = emNode.text {
                        str = cheanText(str: text)
                    }
                }
            }
            return str
        }
        
        let doc = HTML(html: data, encoding: String.Encoding.utf8)

        guard let bodyNode = doc?.body else {
            print("html body not found")
            return nil
        }
        
        let divArr = findDiv(on: bodyNode, className: "busDirection",fromRoot: false)
        if let busDirectionNode = divArr.first {
            
            let upDivArr = findDiv(on: busDirectionNode, className: "upgoing cur",fromRoot: false)
            if let upNode = upDivArr.first {
                let upLine = pText(on: upNode)
                let startTime = emText(on: upNode, className: "s")
                let endTime = emText(on: upNode, className: "m")
                
                print("upLine:\(upLine) startTime:\(startTime) endTime:\(endTime)")
            }
            
            let downDivArr = findDiv(on: busDirectionNode, className: "downgoing ",fromRoot: false)
            if let downNode = downDivArr.first {
                let downLine = pText(on: downNode)
                let startTime = emText(on: downNode, className: "s")
                let endTime = emText(on: downNode, className: "m")
                
                print("downLine:\(downLine) startTime:\(startTime) endTime:\(endTime)")
            }
            
            let stationDivArr = findDiv(on: busDirectionNode, className: "station",fromRoot: true)
            for stationNode in stationDivArr {
                let stationNum = spanText(on: stationNode, className: "num")
                let stationName = spanText(on: stationNode, className: "name")
                print("stationNum:\(stationNum) stationName:\(stationName)")
            }
        }

        return nil
    }
 }
