//
//  ToppingListRow.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct ToppingListRow: View {
    var topping:Food
    @Binding var order:Order
    
    var body: some View{
        HStack{
            CheckBox(order: self.$order, topping: self.topping)
                .padding(.leading)
            
            Text(topping.name ?? "")
            
            Spacer()
            
            Text("\(topping.price ?? "") THB")
                .foregroundColor(.orange)
                .padding(.trailing, 10)
        }
    }
}

struct ToppingListRow_Previews: PreviewProvider {
    static var previews: some View {
        ToppingListRow(topping: Food(), order: .constant(Order(base: Food())))
    }
}
