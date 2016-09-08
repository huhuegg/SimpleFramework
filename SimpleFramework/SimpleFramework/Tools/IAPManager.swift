//
//  IAPManager.swift
//  speedup
//
//  Created by admin on 15/9/7.
//  Copyright (c) 2015年 admin. All rights reserved.
//

import UIKit
import StoreKit

class Product:NSObject {
    var id:String = ""
    var title:String = ""
    var desc:String = ""
    var price:String = ""
}

private let iapManagerShareInstance = IAPManager()
class IAPManager: NSObject,SKProductsRequestDelegate,SKRequestDelegate,SKPaymentTransactionObserver {
    
    let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
    let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    var productsDict:Dictionary<String,SKProduct> = Dictionary()

    var isAddTranscationObserver:Bool = false
    
    static var instance:IAPManager = {
        return iapManagerShareInstance
    }()
   
    func requestProductsList(_ productIdArray:Array<String>) {
        let str = (productIdArray as NSArray).componentsJoined(by: ",")
        print("尝试获取商品列表:\(str)")
        let s = NSSet(array: productIdArray)
        let r = SKProductsRequest(productIdentifiers: s as! Set<String>)
        r.delegate = self
        r.start()
        if isAddTranscationObserver == false {
            SKPaymentQueue.default().add(self)
            isAddTranscationObserver = true
        }
    }
    
    func buy(_ productId:String) -> Bool {
        if !SKPaymentQueue.canMakePayments() {
            print("============不支持内购功能")
            return false //不支持内购
        } else {
            if let product = productsDict[productId] {
                print("购买 productId:\(productId)")
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
                return true
            } else {
                print("productId:\(productId) 不存在")
                return false
            }
            
        }
    }
    
    
    //MARK: - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products:[Product] = []
        
        for invalidProductId in response.invalidProductIdentifiers {
            print("[失效商品]id:\(invalidProductId)")
        }

        if response.products.count == 0 {
            print("无法获取可选产品信息")
        } else {
            print("==商品列表==")
            for product in response.products {
                print("[可选商品] title:\(product.localizedTitle) description:\(product.localizedDescription) price:\(product.price) id:\(product.productIdentifier)")
                let p = Product()
                p.id = product.productIdentifier
                p.title = product.localizedTitle
                p.desc = product.localizedDescription
                p.price = "\(product.price)"
                products.append(p)
                productsDict[product.productIdentifier] = product
                
            }
            
        }
        
        //Notification IAPProductsListCompleted
//        Async.main { () -> Void in
//            AppNotification.send(AppNotificationType.IAPProductsListCompleted, userInfo: ["products":products])
//        }
        
        
    }
    
    //MARK: - SKRequestDelegate
//    func request(request: SKRequest!, didFailWithError error: NSError!) {
//        
//    }
//    
//    func requestDidFinish(request: SKRequest!) {
//        
//    }
    
    //MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // 调试
        for transaction in transactions {
            // 如果小票状态是购买完成
            if (SKPaymentTransactionState.purchased == transaction.transactionState) {
                // 更新界面或者数据，把用户购买得商品交给用户
                print("支付成了＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                // 验证购买凭据
                self.verifyPruchase(sandbox: false)
                
                // 将交易从交易队列中删除
                SKPaymentQueue.default().finishTransaction(transaction )
                
            }
            else if(SKPaymentTransactionState.failed == transaction.transactionState){
                print("支付失败＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                SKPaymentQueue.default().finishTransaction(transaction )
            }
        }
    }
    
    func verifyPruchase(sandbox:Bool){
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = try? Data(contentsOf: receiptURL!)
        // 发送网络POST请求，对购买凭据进行验证
        var url:URL?
        if sandbox {
            url = URL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        } else {
            url = URL(string:VERIFY_RECEIPT_URL)
        }
        
        // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
        let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
        // 传输的是BASE64编码的字符串
        /**
        BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
        BASE64是可以编码和解码的
        */
        let encodeStr = receiptData?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
        
        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}")
        print(payload)
        let payloadData = payload.data(using: String.Encoding.utf8.rawValue)
        
        request.httpBody = payloadData;
        
        // 提交验证请求，并获得官方的验证JSON结果
        let result = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
        
        DispatchQueue.main.async { 
            // 官方验证结果为空
            if (result == nil) {
                //验证失败
                print("验证失败")
//                AppNotification.send(AppNotificationType.IAPPaymentCompleted, userInfo: ["status":false,"message":"验证失败"])
            } else {
                let dict: AnyObject? = try! JSONSerialization.jsonObject(with: result!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
                if (dict != nil) {
                    // 比对字典中以下信息基本上可以保证数据安全
                    // bundle_id&application_version&product_id&transaction_id
                    // 验证成功
                    
                    
                    if let status = dict!.object(forKey: "status") {
                        if String(describing: status) == "0" {
                            print("[\(url!.absoluteString)]验证成功:\(dict)")
//                            AppNotification.send(AppNotificationType.IAPPaymentCompleted, userInfo: ["status":true,"message":"验证成功"])
                        } else if String(describing: status) == "21007" { //沙盒
                            print("需要在沙盒环境下重新验证")
                            self.verifyPruchase(sandbox: true)
                        } else {
//                            AppNotification.send(AppNotificationType.IAPPaymentCompleted, userInfo: ["status":false,"message":"验证失败"])
                        }
                    } else {
                        print("status 不存在")
                    }
                    
                } else {
//                    AppNotification.send(AppNotificationType.IAPPaymentCompleted, userInfo: ["status":false,"message":"验证返回数据解析失败"])
                }
            }
        }

        
    }
//    func restorePurchase(){
//        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
//    }

}
