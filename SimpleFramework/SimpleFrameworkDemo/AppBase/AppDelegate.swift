//
//  AppDelegate.swift
//  SimpleFrameworkDemo
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //获取设备名称
        let name = UIDevice.current.name
        //获取设备的型号
        let modelName = UIDevice.current.modelName
        
        print("name:\(name) modelName:\(modelName)")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let status = AppRouter.instance.start(firstRouterId:AppRouterID.test,type: AppRootViewControllerType.tabbarController,data: nil)
        print("AppRouter setup: \(status == true ? "success":"failed")")
        
        self.window?.makeKeyAndVisible()
        
        
        
        AppNetwork.request(request: AppHttpRequest.reqLineSid(search: "46")) { (resp) in
            //            if let _ = .respLineSid(sid:sid) {
            //                print("\(sid)")
            //            }
            switch resp {
            case let .respLineSid(sid: sid):
                print("sid:\(sid!)")
                //default:
                //    print("resp error")
            }
        }
        
        return status
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    func checkCloud() {
        CloudKitManager.instance.checkCloudKitAvailability { (accountStatus, error) in
            switch accountStatus {
            case .available:
                print("CloudKit available. ")
            case .restricted:
                print("iCloud is not available due to restrictions")
            case .noAccount:
                print("There is no CloudKit account setup.\nYou can setup iCloud in the Settings app.")
            default:
                if let _ = error {
                    print("unknown error:\(error)")
                } else {
                    print("unknown error")
                }
            }
        }
        CloudKitManager.instance.checkCloudKitAvailability { (accountStatus) in
            
        }
    }
}
