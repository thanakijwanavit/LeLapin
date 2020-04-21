//
//  CheckoutView.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cart:Cart
    @Binding var isActive: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .leading){
//                Button("pop to root"){
//                    self.isActive = false
//                    self.presentationMode.wrappedValue.dismiss()
//                    debugPrint("is active ?", self.isActive)
//                }
                
                //title
                PriceLabel(totalCost: self.cart.total)
                    .padding()
                
                
                
                List(0..<self.cart.orders.count){ orderID in
                    VStack(alignment: .leading){
                        
                        if orderID < self.cart.orders.count {
                            //Base title
                                
                            BaseTitle(orderID: orderID)
                            
                            //base subtitle
                            Text(self.cart.orders[orderID].base.name ?? "")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            HStack{
                                Spacer()
                                CheckOutImage(orderID: orderID, g: g)
                                Spacer()
                            }
                                .padding()
                            
                            // Toppings
                            
                            ToppingRow(order: self.cart.orders[orderID])
                        }
                    }
                }
                
                NavigationLink(destination: PaymentPage(isActive: self.$isActive).environmentObject(self.cart)) {
                    HStack {
                        Spacer()
                        
                        Text("Order Now")
                        
                        Spacer()
                    }
                    .padding()
                }
                    .isDetailLink(false)
                
            }
            .onAppear{
                
                debugPrint("cart is :",self.cart, self.cart.orders, self.cart.orders.count)
                
                debugPrint("is active ?", self.isActive)
                if !self.isActive{
                    self.presentationMode.wrappedValue.dismiss()
                    self.cart.orders.removeAll()
                }
            }
        }
    }
}






struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let cart = Cart()
        let food =  Food()!
        food.name = "BaseName"
        let topping1 = Food()!
        topping1.name = "Topping1"
        let order = Order(base: food)
        order.topping.append(topping1)
        cart.orders.append(order)
        _ = cart.orders.first?.base.name
        
        return Group {
            CheckoutView(isActive: .constant(true))
            
            CheckoutView(isActive: .constant(true))
                .environment(\.colorScheme, .dark)
        }
            .environmentObject(cart)
    }
}
