//
//  ToppingRow.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/12/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct ToppingRow: View {
    var order:Order
    var body: some View {
        VStack(alignment: .leading){
            if self.order.topping.count > 0 {
                Text("Toppings")
                    .font(.headline)
                    .padding(.vertical)
            }
            // toppings
            ForEach(self.order.topping, id: \.self){ topping in
                HStack {
                    Text(topping.name ?? "name")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(topping.price ?? "0")
                        .foregroundColor(.gray)
                    Text("THB")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ToppingRow_Previews: PreviewProvider {
    static var previews: some View {
        ToppingRow(order: Order(base: Food()))
    }
}
