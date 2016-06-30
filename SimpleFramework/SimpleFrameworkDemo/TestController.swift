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

    //MARK:- 初始化
    override func initView() {
        self.view.backgroundColor = UIColor.white()
        clearColorNavigationBarBackground()
    }
    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TestController.viewDidLoad: initView")
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


//MARK:- IBAction and private functions
private extension TestController {

    @IBAction func pushToTest1(_ sender: AnyObject) {
        (handler as! TestHandler).pushToTest1(from: self, data: ["key":"pushFromTestController"])
    }
    
    @IBAction func presentToTest3(_ sender: AnyObject) {
        (handler as! TestHandler).presentToTest3(from: self, data: ["key":"presentFromTestController"])
    }

}

