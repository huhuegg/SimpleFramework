//
//  SimpleController.swift
//  SimpleFramework
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public protocol SimpleControllerProtocol {
    func initView()
}

public enum SimpleControllerFrom {
    case present
    case push
}

public class SimpleController:UIViewController,SimpleControllerProtocol {
    public var handler:SimpleHandler?
    
    public var fromType:SimpleControllerFrom = .present
    
    public var data:Dictionary<String,AnyObject>?
    public var needSendBackData:Dictionary<String,AnyObject>?
    public var receiveBackData:Dictionary<String,AnyObject>?
    
    public func className() ->String {
        return String(self.classForCoder)
    }

    private func saveFromType() {
        if let navi = self.navigationController {
            if navi.viewControllers.count > 0 {
                if navi.viewControllers[navi.viewControllers.count - 1] == self {
                    fromType = .push
                }
            }
        }
        switch fromType {
        case .push:
            print("\(self.className()) is from PUSH")
        case .present:
            print("\(self.className()) is from PRESENT")
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        saveFromType()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = receiveBackData {
            //print("\(self): viewWillAppear, data:\(data) receiveBackData:\(receiveBackData)")
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        if fromType == .push {
            //检测NavigationController返回按钮点击，右滑切换Controller
            if let navi = self.navigationController {
                if self.navigationController?.viewControllers.index(of: self) == nil {
                    print("统一处理NavigationController返回 **POP** \(self.className())")
                    if navi.viewControllers.count > 0 {
                        if let popToController = navi.viewControllers[navi.viewControllers.count - 1] as? SimpleController {
                            //返回数据
                            //print("set \(self.className()).needSendBackData => \(popToController.className()).receiveBackData")
                            popToController.receiveBackData = self.needSendBackData
                        }
                    }
                }
            }
        }
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    deinit {
        if let _ = handler {
            print("~~~ \(self.className()) deinit ~~~")
        }
    }
}

extension SimpleControllerProtocol where Self:SimpleController{
    public func initView() {
        print("SimpleController initView")
    }

}
