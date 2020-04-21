//
//  Cart.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/9/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI

class Cart:ObservableObject{
    @Published var orders:[Order]
    
    var cartId:String
    
    init (){
        self.orders = []
        self.cartId = UUID().uuidString
    }
    var total:Int {
        var totalPrice:Int = 0
        for order in self.orders{
            totalPrice += order.totalPrice
        }
        return totalPrice
    }
    lazy var codableCart:CodableCart = {
        return CodableCart(cart: self)
    }()
    
    lazy var data:Data? = {
        let encoder = JSONEncoder()
        
        do {
            return try encoder.encode(self.codableCart)
        } catch {
            debugPrint("error encoding cart", error)
            return nil
        }
    }()
    
    
}

class CodableCart:Codable{
    var orders: [CodableOrder]
    var total: Int
    var cartId: String
    
    init(cart:Cart){
        self.total = cart.total
        var codableOrders:[CodableOrder] = []
        for order in cart.orders{
            codableOrders.append(order.codableOrder)
        }
        self.orders = codableOrders
        self.cartId = cart.cartId
    }
    
}



