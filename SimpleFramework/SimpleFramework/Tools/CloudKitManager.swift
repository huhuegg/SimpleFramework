//
//  CloudKitManager.swift
//  SimpleFramework
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import CloudKit

public enum CloudKitResult {
    case success(AnyObject?)
    case failure(AnyObject?)
    case cloudKitPermission(CKAccountStatus)
}

public class CloudKitManager: NSObject {
    private static let cloudKitInstance = CloudKitManager()
    
    public static let instance:CloudKitManager = {
        return cloudKitInstance
    }()
    
    
    let container:CKContainer
    let publicDB:CKDatabase
    let privateDB:CKDatabase
    
    override init() {
        // defaultContainer()代表的是在iCloud功能栏里制定的那个容器
        container = CKContainer.default()
        // publicCloudDatabase则是应用上的所有用户共享的数据
        publicDB = container.publicCloudDatabase
        // privateCloudDatabase是你个人的私密数据
        privateDB = container.privateCloudDatabase
    }
    
    /**
     检查用户iCloud账号是否登陆
     */
    public func isIcloudAvailable() -> Bool {
        //ubiquityIdentityToken is a new thing introduced by Apple to allow apps to check if the user is logged into icloud
        if let _ = FileManager.default.ubiquityIdentityToken{
            print("icloud avaliable")
            return true
        } else {
            print("icloud unavaliable")
            return false
        }
    }
    
    /**
     检查CloudKit权限
    */
    public func checkCloudKitAvailability(completionCallback:@escaping (_ accountStatus:CKAccountStatus,_ error:NSError?)->()) {
        container.accountStatus { (accountStatus, error) in
            completionCallback(accountStatus, error as NSError?)
        }
    }
    
    
}
