//
//  UserNotificationsManager.swift
//  SimpleFramework
//
//  Created by admin on 15/9/7.
//  Copyright (c) 2015年 admin. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationManager {
	private static let shareInstance = UserNotificationManager()

	var deviceToken:Data?

	static var instance:UserNotificationManager = {
		return shareInstance
	}()

	//权限检查
	func requestAuthorization(callback:(status:Bool)->()) {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    		if granted {
        		// 用户允许进行通知
				// 向 APNs 请求 token
        		UIApplication.shared.registerForRemoteNotifications()
    		} else {
				if let error = error {
                    UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
                }
			}
			callback(granted)
		}
	}


	func saveDeviceToken(tokenData:Data?) {
		deviceToken = tokenData
	}
}

