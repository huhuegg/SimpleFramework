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

    //MARK:- 初始化
    override func initView() {
        self.view.backgroundColor = UIColor.green()
    }
    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test1Controller.viewDidLoad: initView")
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
    
    
}

//MARK:- IBAction and private functions
private extension Test1Controller {
    
    @IBAction func popToTest(_ sender: AnyObject) {
        needSendBackData = ["key":"BackFromTest1Controller"]
        (handler as! Test1Handler).popToTest(from: self)
    }
    
    @IBAction func presentTest2(_ sender: AnyObject) {
        (handler as! Test1Handler).presentToTest2(from: self, data: ["key":"presentFromTest1Controller"])
    }
    
    
}

