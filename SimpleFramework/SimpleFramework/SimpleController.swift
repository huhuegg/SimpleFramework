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
    
    //Controller切换类型
    public var fromType:SimpleControllerFrom = .present
    
    //Controller切换动画
    public var transitioning:UIViewControllerAnimatedTransitioning?
    
    //初始化数据
    public var data:Dictionary<String,AnyObject>?
    //Controller返回时需要带的数据
    public var needSendBackData:Dictionary<String,AnyObject>?
    //Controller返回收到的数据
    public var receiveBackData:Dictionary<String,AnyObject>?
    
    //Controller状态，Present/Dismiss动画使用
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

    
    //初始化
    public func initView() {
        print("TestController initView")
        self.view.backgroundColor = UIColor.white()
        clearColorNavigationBarBackground()
    }
    
    
}

//MARK:- UIViewControllerTransitioningDelegate (Present/Dismiss过场动画)
extension SimpleController: UIViewControllerTransitioningDelegate {
    func setPresentTransitioning(transitioning:UIViewControllerAnimatedTransitioning?)->UIViewControllerAnimatedTransitioning? {
        print("\(self.className()) setPresentTransitioning: \(transitioning)")
        if let _ = transitioning {
            self.transitioning = transitioning
            self.transitioningDelegate = self
        }
        return transitioning
    }
    
    public func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(String(self.classForCoder)) animationController forPresentedController:\(transitioning)")
        self.isShowing = true
        return transitioning
    }
    
    public func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("\(String(self.classForCoder)) animationController forDismissedController:\(transitioning)")
        self.isShowing = false
        return transitioning
    }
}

//MARK:- UINavigationControllerDelegate (Push/Pop过场动画)
extension SimpleController:UINavigationControllerDelegate  {
    func setNavigationTransitioning(transitioning:UIViewControllerAnimatedTransitioning?) {
        print("\(self.className()) setNavigationTransitioning: \(transitioning)")
        self.navigationController!.delegate = self
        self.transitioning = transitioning
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("navigationController animationControllerFor from->to")
        return transitioning
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("navigationController willShow")
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController didShow")
    }
}

