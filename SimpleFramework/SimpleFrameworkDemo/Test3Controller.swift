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

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismiss(_ sender: AnyObject) {
        needSendBackData = ["key":"DissmissFromTest3"]
        (handler as! Test3Handler).dismiss()
    }
}

extension SimpleControllerProtocol where Self:Test3Controller {
    func initView() {
        print("Test3Controller initView")
        self.view.backgroundColor = UIColor.white()
    }
}

