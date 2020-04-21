//
//  DynamoDBApi.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/9/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDBApi{
    class func getMainDish()->[Food]{
        return self.getFood(catName: "mainDish")
    }
    class func getRecommended()->[Food]{
        return self.getFood(catName: "recommendedMenu")
    }
    class func getTopping()->[Food]{
        return self.getFood(catName: "topping")
    }
    class func getAdditionalTopping()->[Food]{
        return self.getFood(catName: "additionalTopping")
    }
    
    
    
    class func getFood(catName: String)->[Food]{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        var foods:[Food] = []
        let semaphore = DispatchSemaphore(value: 0)
        let queryExpression = AWSDynamoDBQueryExpression()

        queryExpression.keyConditionExpression = "foodType = :catName"
        queryExpression.projectionExpression = "foodType, #nm, cat, imageLink, price, longDescription, shortDescription, shortName"
        queryExpression.expressionAttributeNames = [ "#nm" : "name" ]
        queryExpression.expressionAttributeValues = [":catName": catName]

        dynamoDBObjectMapper.query(Food.self, expression: queryExpression).continueWith { (task) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                // Do something with task.result.
                for food in paginatedOutput.items{
//                    debugPrint("result is ",food)
                    if let food = food as? Food {
                        foods.append(food)
//                        debugPrint("parsed result is ",food)
                    }
                }
            } else {
                debugPrint("no result", task.result!)
            }
            semaphore.signal()
            return nil
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return foods
    }
}
