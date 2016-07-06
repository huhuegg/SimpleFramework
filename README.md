[![Twitter: @huhuegg1](https://img.shields.io/badge/contact-@huhuegg1-blue.svg?style=flat)](https://twitter.com/huhuegg1)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoadocs.org/docsets/SwiftForms)
[![Language: Swift](https://img.shields.io/badge/lang-Swift-yellow.svg?style=flat)](https://developer.apple.com/swift/)
[![Language: Swift](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://opensource.org/licenses/MIT)

# SimpleFramework

SimpleFramework is an app framework for iOS written in Swift3.


## Features

- [x] Network
- [x] Notification
- [x] CoreData
- [x] Animation


## Setup

- Xcode8.0 beta (8S128d)
- iOS 10

## Usage
参考SimpleFrameworkDemo工程

如工程中使用Swift Framework，遇到“cannot find swift declaration for this class”错误情况，请检查Build Settings -> BuildOptions -> Embedded Content Contains Swift Code  是否已经被设置为Yes
### AppDelegate
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main().bounds)
        let status = AppRouter.instance.start(firstRouterId:AppRouterID.test,type: AppRootViewControllerType.tabbarController,data: nil)
        print("AppRouter setup: \(status == true ? "success":"failed")")
        
        self.window?.makeKeyAndVisible()
        return status

    }
```

### AppRouter
使用SimpleFrameworkDemo工程中的AppRouter.swift作为模版

添加使用的ControllerID
```swift
enum AppRouterID {
    case test
    case test1
    case test2
    case test3
}
```

定义并初始化所有handler
```swift
private func initHandlers() {
    testHandler = SimpleRouter.create(name: "Test") as! TestHandler
    test1Handler = SimpleRouter.create(name: "Test1") as! Test1Handler
    test2Handler = SimpleRouter.create(name: "Test2") as! Test2Handler
    test3Handler = SimpleRouter.create(name: "Test3") as! Test3Handler
}
    
private func getHandler(routerId:AppRouterID)->SimpleHandler? {
    switch routerId {
    case .test:
        return testHandler
    case .test1:
         return test1Handler
    case .test2:
        return test2Handler
    case .test3:
        return test3Handler
   }
}
```

如果起始Controller类型为TarBarController,实现setupTarBar
```swift
private func setupTabBar(data:Dictionary<String,AnyObject>?)->Array<UIViewController> {
    let (_,eduCtl) = setupToHandler(routerId: .test, data: nil)
    let (_,newsCtl) = setupToHandler(routerId: .test1, data: nil)
    let (_,giftCtl) = setupToHandler(routerId: .test2, data: nil)
    let (_,homeCtl) = setupToHandler(routerId: .test3, data: nil)
    
    eduCtl!.tabBarItem = UITabBarItem(title: "教育", image: UIImage(named: "edu"), tag: 0)
    newsCtl!.tabBarItem = UITabBarItem(title: "新闻", image: UIImage(named: "news"), tag: 0)
    giftCtl!.tabBarItem = UITabBarItem(title: "礼物", image: UIImage(named: "gift"), tag: 0)
    homeCtl!.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "home"), tag: 0)
    return [eduCtl!,newsCtl!,giftCtl!,homeCtl!]
}
```

###Handler
```swift
import SimpleFramework

class TestHandler: SimpleHandler {
    //MARK:- Controller call handler func

}

//MARK:- Setup controller
extension SimpleRouterProtocol where Self:TestHandler {
    //不使用SimpleHandler的setupController
    func setupController(data:Dictionary<String,AnyObject>?)->SimpleController? {
        let storyboardName = "Main"
        let controllerIdentifier = name + "Controller"
        
        let bundle = Bundle.main()
        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let ctl = sb.instantiateViewController(withIdentifier: controllerIdentifier) as? TestController else {
            print("setupController error!")
            return nil
        }
        //print("\(self.className()): setupController, identifier:\(controllerIdentifier)")
        
        ctl.handler = self
        ctl.data = data
        
        return ctl
    }

}

//MARK:- Router
extension TestHandler {
    func pushToTest1(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        //let transitioning:UIViewControllerAnimatedTransitioning? = nil
        let transitioning = SimpleControllerAnimatedTransitioning(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test1, type: ControllerShowType.push, fromController: from, animated: true, transitioning:transitioning, data: data)
    }
    
    func presentToTest3(from:SimpleController, data:Dictionary<String,AnyObject>?) {
        let transitioning = PresentControllerBoxAnimation(duration: 1)
        AppRouter.instance.show(routerId: AppRouterID.test3, type: ControllerShowType.present, fromController: from, animated: true, transitioning:transitioning,data: data)
    }
}

//MARK:- Broadcast to controllers
extension TestHandler {
    
    func broadcast() {
        for ctl in controllers {
            if let c = ctl as? TestController {
                //c.callWithHandler()
            }
        }
    }
}

//MARK:- Private handler func
private extension TestHandler {
    

}

```
###Controller
```swift
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
```
