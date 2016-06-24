//
//  Test1Controller.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test1Controller: SimpleController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        print((handler as! Test1Handler).data)
        initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    @IBAction func popToTest(_ sender: AnyObject) {
        needSendBackData = ["key":"BackFromTest1Controller"]
        (handler as! Test1Handler).popToTest()
    }
    
    @IBAction func presentTest2(_ sender: AnyObject) {
        (handler as! Test1Handler).presentToTest2(["key":"presentFromTest1Controller"])
    }

}

extension SimpleControllerProtocol where Self:Test1Controller {
    func initView() {
        print("Test1Controller initView")
    }
}
