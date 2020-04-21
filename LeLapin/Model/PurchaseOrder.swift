//
//  PurchaseOrder.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/11/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
struct PurchaseOrder:Codable{
    var cart:CodableCart
    var user:User
    var purchaseOrderId:String
    var deliveryDate:Date

    init(cart:Cart, user:User, deliveryDate:Date){
        self.cart = cart.codableCart
        self.user = user
        self.purchaseOrderId = UUID().uuidString
        self.deliveryDate = deliveryDate
    }
    
    lazy var data:Data? = {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            debugPrint("error encoding purchaseOrder", error)
            return nil
        }
    }()
}
