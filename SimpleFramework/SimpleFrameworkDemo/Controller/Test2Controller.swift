//
//  Test2Controller.swift
//  SimpleFramework
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test2Controller: SimpleController {
    
    //MARK:- 初始化
    override func initView() {
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test2Controller.viewDidLoad: initView")
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- handler call controller func
extension Test2Controller {
    func callWithHandler() {
        print("\(self) callWithHandler")
    }
}

//MARK:- IBAction and private functions
private extension Test2Controller {
    
    @IBAction func presentToTest3(_ sender: AnyObject) {
        (handler as! Test2Handler).presentToTest3(from: self, data: ["key":"presentFromTest2Controller" as AnyObject])
    }
    
    @IBAction func dismissToTest1(_ sender: AnyObject) {
        needSendBackData = ["key":"DismissFromTest2Controller" as AnyObject]
        
        (handler as! Test2Handler).dismissToTest1(from: self)
    }
}
