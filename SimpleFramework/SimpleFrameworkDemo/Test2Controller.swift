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

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentToTest3(_ sender: AnyObject) {
        (handler as! Test2Handler).presentToTest3(["key":"presentFromTest2Controller"])
    }

    @IBAction func dismissToTest1(_ sender: AnyObject) {
        needSendBackData = ["key":"DismissFromTest2Controller"]
        
        (handler as! Test2Handler).dismissToTest1()
    }
}


extension SimpleControllerProtocol where Self:Test2Controller {
    func initView() {
        print("Test2Controller initView")
        self.view.backgroundColor = UIColor.white()
    }
}

