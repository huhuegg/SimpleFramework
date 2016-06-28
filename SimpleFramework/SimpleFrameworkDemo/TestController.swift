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

    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //初始化
    override func initView() {
        print("TestController initView")
        self.view.backgroundColor = UIColor.white()
        
        setupNavigation()
    }
}


//MARK:- IBAction and private functions
private extension TestController {

    @IBAction func pushToTest1(_ sender: AnyObject) {
        //print("\(handler?.className())")
        (handler as! TestHandler).pushToTest1(["key":"pushFromTestController"])
    }
    
    @IBAction func presentToTest3(_ sender: AnyObject) {
        (handler as! TestHandler).presentToTest3(["key":"presentFromTestController"])
    }

}

extension UINavigationControllerDelegate where Self:TestController {
    //设置Navigation
    func setupNavigation() {
        print("TestController setupNavigation")
        self.navigationController!.delegate = self
        clearColorNavigationBarBackground()
        setupAnimation()
    }
    
    func setupAnimation() {
        //过场动画
        let t = SimpleControllerAnimatedTransitioning(duration:0.7)
        self.setControllerAnimation(transitioning: t)
    }
    
}

