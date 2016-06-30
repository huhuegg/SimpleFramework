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
    
    //MARK:- 初始化
    override func initView() {
        self.view.backgroundColor = UIColor.yellow()
        self.transitioningDelegate = self
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

//MARK:- IBAction and private functions
private extension Test3Controller {
    
    @IBAction func dismiss(_ sender: AnyObject) {
        needSendBackData = ["key":"DissmissFromTest3"]
        (handler as! Test3Handler).dismiss(from: self)
    }
}

