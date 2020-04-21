//
//  SendEmail.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/11/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import AWSLambda


class lambdaApi {
    class func sendOrder(data:Data) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var success:Bool = false
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            debugPrint("seding object:",jsonObject)
            let lambdaInvoker = AWSLambdaInvoker(forKey: "APSE1")
            lambdaInvoker.invokeFunction("arn:aws:lambda:ap-southeast-1:277726656832:function:le-lapin-order-SubmitOrderFunction-13MH9P64NJKVL", jsonObject: jsonObject)
                .continueWith(block: {(task:AWSTask<AnyObject>) -> Any? in
                if( task.error != nil) {
                    print("Error: \(task.error!)")
                    return nil
                }
                    
                if let JSONDictionary = task.result as? NSDictionary {
//                    print("Result: \(JSONDictionary)")
//                    print("resultKey: \(JSONDictionary["resultKey"])")
                    if JSONDictionary["statusCode"] as! Int == 200 {
                        debugPrint("status code is 200")
                        success = true
                        semaphore.signal()
                    } else {
                        debugPrint(JSONDictionary["statusCode"])
                        semaphore.signal()
                    }
                    
                }
                // Handle response in task.result
                return nil
            })
        } catch{
            debugPrint("error serialization", error)
        }
        
        
        _ = semaphore.wait(timeout: .distantFuture)
        debugPrint("returning",success)
        return success
    }
    
    class func testOrderFood(){
        let food = Food()!
        food.name = "testFood"
        food.foodType = "Type"
        food.price = "123"
        let cart = Cart()
        cart.orders.append(Order(base: food))
        let user = User(name: "nic", email: "nwanavit@gmail.com", lineID: "1234", phoneNumber: "0816684442", address: "address", mapLink: "google.com")
        var purchaseOrder = PurchaseOrder(cart: cart , user: user, deliveryDate: Date())
        lambdaApi.sendOrder(data: purchaseOrder.data!)
    }
    
    class func orderFood(cart:Cart, user:User, deliveryDate:Date)->Bool{
        var purchaseOrder = PurchaseOrder(cart: cart, user: user, deliveryDate: deliveryDate)
        if let data = purchaseOrder.data {
            return lambdaApi.sendOrder(data: data)
        } else {
            debugPrint("encoding failed")
            return false
        }
    }
    
    
}
