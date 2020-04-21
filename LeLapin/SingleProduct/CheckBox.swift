//
//  CheckBox.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct CheckBox : View {
    var topping:Food
    @Binding var order:Order
    @State var inCart:Bool
    
    init(order:Binding<Order>, topping:Food){
        _inCart = State(initialValue: order.wrappedValue.topping.contains(topping))
        self._order = order
        self.topping = topping
    }
    
    var body: some View{
        var isChecked:Bool {
            get {
                if self.order.topping.contains(self.topping){
                    return true
                } else {
                    return false
                }
            }
            set {
                if self.order.topping.contains(self.topping) {
                    self.order.topping.removeAll { (topping) -> Bool in
                        return topping == self.topping
                    }
                    self.inCart = false
                } else {
                    self.order.topping.append(self.topping)
                    self.inCart = true
                }
            }
        }
        
        return Button(action: {
            isChecked.toggle()
            debugPrint("toggle is checked \(isChecked)")
        } ){
            Image(systemName: inCart ? "checkmark.square" : "square")
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        CheckBox(order: .constant(Order(base: Food())), topping: Food())
    }
}
