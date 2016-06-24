//
//  Test3Handler.swift
//  SimpleFramework
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class Test3Handler: SimpleHandler {

}

extension SimpleRouterProtocol where Self:Test3Handler {
    
    func dismiss() {
        AppRouter.instance.close(handler: self, animated: true)
    }
}
