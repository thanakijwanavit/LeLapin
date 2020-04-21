//
//  BaseTitle.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/12/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct BaseTitle: View {
    var orderID:Int
    @EnvironmentObject var cart:Cart
    var body: some View {
        HStack {
            
            Text(self.orderID < self.cart.orders.count ? self.cart.orders[orderID].base.name ?? "" : "")
                .font(.headline)
            
            Spacer()
            Text(self.orderID < self.cart.orders.count ? "\(self.cart.orders[orderID].totalPrice) THB" : "")
                .foregroundColor(.orange)
        }
    }
}

struct BaseTitle_Previews: PreviewProvider {
    static var previews: some View {
        BaseTitle(orderID: 0)
            .environmentObject(Cart())
    }
}
