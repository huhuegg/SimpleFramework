//
//  SimpleNetwork.swift
//  SimpleFramework
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

public enum SimpleHttpNetworkResult<T> {
    case Success(T)
    case Failure(ErrorProtocol)
}

public class SimpleHttpNetwork: NSObject {

}
