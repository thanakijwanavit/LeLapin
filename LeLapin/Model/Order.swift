//
//  Food.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/9/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
class Order: Hashable{
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id > rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.base.name!)
    }
    var id = Int.random(in: 0...1000)
    var base:Food
    var topping:[Food] = []
    
    init(base:Food){
        self.base = base
    }
    var totalPrice:Int {
        let basePrice = Int(self.base.price ?? "888") ?? 999
        var toppingPrice:Int = 0
        for topping_ in self.topping{
            toppingPrice += Int(topping_.price ?? "888") ?? 999
        }
        let total = basePrice + toppingPrice
        return total
    }
    lazy var codableOrder:CodableOrder = {
        return CodableOrder(order: self)
    }()
}

class CodableOrder: Codable{
    var base:CodableFood
    var topping:[CodableFood]
    var totalPrice: Int
    
    init(order:Order){
        self.base = order.base.codableFood
        var codableTopping:[CodableFood] = []
        for topping in order.topping{
            codableTopping.append(topping.codableFood)
        }
        self.topping = codableTopping
        self.totalPrice = order.totalPrice
    }
}




