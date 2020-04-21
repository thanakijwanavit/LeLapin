//
//  AddToCartButton.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/9/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct AddToCartButton: View {
    
    
    @State var quantityDisplay:Int = 0
    @EnvironmentObject var cart:Cart
    var width: CGFloat
    var food: Food
    
    
    init(width:CGFloat, food:Food) {
        self.width = width
        self.food = food
    }
    
    
    var body: some View {
        return ZStack(alignment: .leading){
            HStack(alignment: .center) {
                
                if self.quantityDisplay > 0 {
                    RemoveButton(quantityDisplay: self.$quantityDisplay, food: self.food)
                }
                
                Spacer()
                
                Button(action: {
                    self.cart.orders.append(Order(base: self.food))
                    self.quantityDisplay += 1
                    debugPrint("quantity set to", self.quantityDisplay)
                }) {
                    Text(self.quantityDisplay > 0 ? "\(self.quantityDisplay)":"Add to Cart")
                        .frame(height: 33)
                }
                
                Spacer()
                
                if self.quantityDisplay > 0 {
                    AddButton(quantityDisplay: self.$quantityDisplay, food: self.food)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: width, height: 33, alignment: .center)
            .padding(.horizontal)
            .overlay(Capsule().stroke(
                Color.blue.opacity(0.5),lineWidth: 5)
                )
            .onAppear{
//                debugPrint("button has appeared")
                self.syncQuantity()
            }
        }
    }
    
    func syncQuantity(){
        self.quantityDisplay = self.cart.orders.filter { (order) -> Bool in
            return order.base == self.food
        }.count
    }
}


struct AddButton:View {
    
    @Binding var quantityDisplay:Int
    @EnvironmentObject var cart:Cart
    var food:Food
    
    var body: some View{
        Button(action: {
            self.cart.orders.append(Order(base: self.food))
            self.quantityDisplay += 1
            debugPrint("quantity set to", self.quantityDisplay)
        }) {
            Image(systemName: "plus")
//                        .resizable()
            .modifier(ScalableImageModifier())
                .frame(width: 33, height: 33)
        }
    }
}

struct RemoveButton:View {
    @Binding var quantityDisplay:Int
    @EnvironmentObject var cart:Cart
    var food:Food
    
    
    var body: some View{
        Button(action: {
            let firstIndex = self.cart.orders.firstIndex { (order) -> Bool in
                order.base.name ?? "" == self.food.name ?? ""
            }
            
            if let firstIndex = firstIndex{
                self.cart.orders.remove(at: firstIndex)
            }
            
            self.quantityDisplay -= 1
            debugPrint("quantity set to", self.quantityDisplay)
        }) {
            Image(systemName: "minus")
//                        .resizable()
            .modifier(ScalableImageModifier())
                .frame(width: 33, height: 33)
        }
    }
}

struct AddToCartButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartButton(width: 100, food: Food())
    }
}
