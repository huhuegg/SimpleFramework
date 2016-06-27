//
//  ViewController.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class TestController: SimpleController {

    @IBOutlet weak var returnButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushToTest1(_ sender: AnyObject) {
        //print("\(handler?.className())")
        (handler as! TestHandler).pushToTest1(["key":"pushFromTestController"])
    }

    @IBAction func presentToTest3(_ sender: AnyObject) {
        (handler as! TestHandler).presentToTest3(["key":"presentFromTestController"])
    }
}

extension SimpleControllerProtocol where Self:TestController {
    func initView() {
        print("TestController initView")
        self.view.backgroundColor = UIColor.white()
        clearColorNavigationBarBackground()
    }
}

