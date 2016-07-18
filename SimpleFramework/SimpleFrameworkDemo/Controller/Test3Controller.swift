//
//  Test3Controller.swift
//  SimpleFramework
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test3Controller: SimpleController {
    @IBOutlet weak var testButton: UIButton!
    
    //MARK:- IBAction
    @IBAction func dismiss(_ sender: AnyObject) {
        needSendBackData = ["key":"DissmissFromTest3"]
        (handler as! Test3Handler).dismiss(from: self)
    }
    
    //MARK:- 初始化
    override func initView() {
        self.view.backgroundColor = UIColor.yellow()
        self.transitioningDelegate = self
        
        testButton.addTarget(self, action: .testButtonClicked, for: UIControlEvents.touchUpInside)
    }
    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test3Controller.viewDidLoad: initView")
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Selector
private extension Selector {
    static let testButtonClicked = #selector(Test3Controller.testButtonTest)
}

//MARK:- SimpleControllerBroadcastProtocol
extension Test3Controller:SimpleControllerBroadcastProtocol {
    func callFromHandler(dict: Dictionary<String, AnyObject>?) {
        print("callFromHandler:\(dict)")
    }
}

//MARK:- Private function
private extension Test3Controller{
    @objc func testButtonTest() {
        print("testButtonTest")
//        (handler as! Test3Handler).getTestDataList()
        (handler as! Test3Handler).pushToTest4(from: self, data: nil)
    }
}


