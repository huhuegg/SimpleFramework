//
//  SimpleController.swift
//  SimpleFramework
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public enum SimpleControllerFrom {
    case present
    case push
}

public class SimpleController:UIViewController {
    //MARK:- Property
    public var handler:SimpleHandler?
    
    public var fromType:SimpleControllerFrom = .present
    
    public var data:Dictionary<String,AnyObject>?
    public var needSendBackData:Dictionary<String,AnyObject>?
    public var receiveBackData:Dictionary<String,AnyObject>?
    
    //Controller Animation
    public var controllerAnimatedTransitioning:UIViewControllerAnimatedTransitioning?
    
    //Controller Status
    public var isShowing:Bool = false
    
    
    
    //MARK:- ViewController Life Cycle
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
        //Change controller status -> false
        self.isShowing = false
    }

    deinit {
        if let _ = handler {
            print("~~~ \(self.className()) deinit ~~~")
        }
    }
    
    
    //MARK:- Function
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

    //过场动画
    public func setControllerAnimation(transitioning:UIViewControllerAnimatedTransitioning?) {
        if let _ = transitioning {
            self.transitioningDelegate = self
            self.controllerAnimatedTransitioning = transitioning
            
            if fromType == .present {
                self.modalPresentationStyle = UIModalPresentationStyle.custom
            }
        }
    }
    
    //初始化
    public func initView() {
        print("TestController initView")
        self.view.backgroundColor = UIColor.white()
        clearColorNavigationBarBackground()
    }
    
    
}



