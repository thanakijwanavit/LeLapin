//
//  DynamoDBObjectModels.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/9/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import AWSDynamoDB
import KingfisherSwiftUI

class Food : AWSDynamoDBObjectModel, AWSDynamoDBModeling, Identifiable  {
    @objc var foodType:String?
    @objc var name:String?
    @objc var cat:String?
    @objc var imageLink:String?
    @objc var price:String?
    @objc var longDescription:String?
    @objc var shortDescription:String?
    @objc var shortName:String?

    
    
    
    var wrappedImage:URL {
        if let imageLink = self.imageLink{
            if let url = URL(string: imageLink){
                return url
            }
        }
        //return logo as placeholder
        return URL(string: "https://le-lapin.s3.amazonaws.com/main+dish/1.png")!
    }

    class func dynamoDBTableName() -> String {
        return "LeLapin"
    }

    class func hashKeyAttribute() -> String {
        return "foodType"
    }
    
    lazy var codableFood:CodableFood = {
        return CodableFood(food: self)
    }()
    
}

class CodableFood: Codable{
    var foodType:String?
    var name:String?
    var cat:String?
    var imageLink:String?
    var price:String?
    var longDescription:String?
    var shortDescription:String?
    
    
    init(food:Food){
        self.foodType = food.foodType
        self.name = food.name
        self.cat = food.cat
        self.imageLink = food.imageLink
        self.price = food.price
        self.longDescription = food.longDescription
        self.shortDescription = food.shortDescription
    }
}
