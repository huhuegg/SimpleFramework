//
//  SimpleHandler.swift
//  SimpleFramework
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public enum ControllerShowType {
    case push
    case present
    case presentNavi
}

open class SimpleHandler: NSObject,SimpleRouterProtocol {
    public var name:String!

    public var data:Dictionary<String,AnyObject>?
    
    public var controllers:Array<SimpleController?> = Array()
    
    //Any SimpleHandlerClass Init
    required override public init() {
        super.init()
    }

    public func className() ->String {
        return String(describing: self.classForCoder)
    }

    public func addController(controller:SimpleController) {
        for ctl  in controllers {
            if ctl == controller {
                return
            }
        }
        //print("handler:\(self) addController:\(controller)")
        controllers.append(controller)
    }
        
    public func removeController(controller:SimpleController) {
        
        for (idx,ctl)  in controllers.enumerated() {
            if ctl == controller {
                print("removeController:\(ctl)")
                controllers.remove(at: idx)
                return
            }
        }
    }
    
    /**
     向由当前handler创建的Controllers发送数据
     
     - Parameter data: 发送给Controller的数据
     
     - Returns: Void
     */
    public func broadcastControllers(data:Dictionary<String,AnyObject>?) {
        for ctl in controllers {
            if let c = ctl as? SimpleControllerBroadcastProtocol {
                print("broadcastController:\(c) data:\(data)")
                c.callFromHandler(dict: data)
            }
        }
    }
}

extension SimpleRouterProtocol where Self:SimpleHandler {
    /**
     自定义初始化Controller
     
     - Parameter data: Controller的初始化数据
     
     - Returns: SimpleController
     */
    public func setupController(data:Dictionary<String,AnyObject>?)->SimpleController? {
        let storyboardName = "Main"
        let controllerIdentifier = name + "Controller"
        
        let bundle = Bundle.main
        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let ctl = sb.instantiateViewController(withIdentifier: controllerIdentifier) as? SimpleController else {
            print("\(storyboardName).\(controllerIdentifier) setupController error!")
            return nil
        }
        
        ctl.handler = self
        //print("SimpleController: handler is \(ctl.handler)")
        
        ctl.data = data
        //print("\(ctl) data:\(ctl.data)")

        return ctl
    }
    
    
}
