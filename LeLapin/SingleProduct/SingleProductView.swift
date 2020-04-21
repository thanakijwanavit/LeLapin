//
//  SingleProductView.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import KingfisherSwiftUI
import SwiftUI

struct SingleProductView: View {
    var food:Food
    var toppings = DynamoDBApi.getTopping()
    var additionalTopping = DynamoDBApi.getAdditionalTopping()
    @Binding var isPresented:Bool
    @State var order:Order
    @EnvironmentObject var cart:Cart
    
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    
    init(food:Food, isPresented: Binding<Bool>){
        self.food = food
        _order = State(initialValue: Order(base: food))
        _isPresented = isPresented
    }
    var body: some View{
        GeometryReader{ g in
            VStack{
                Text(self.food.name ?? "")
                .font(.title)
                .padding()
                
                ScrollView {
                    
                    //short description
                    Text(self.food.shortDescription ?? "long description here")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                    
                    KFImage(self.food.wrappedImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(2)
                        .frame(width: g.size.width/2, height: g.size.width/2 + 50, alignment: .center)
                        .pinchToZoom()
                        
                        .offset(self.dragAmount)
                        .animation(Animation.default.delay( 0.0001))
                        .gesture(
                            DragGesture()
                                .onChanged { self.dragAmount = $0.translation }
                                .onEnded { _ in
                                    self.dragAmount = .zero
                                    self.enabled.toggle()
                                }
                        )
                    
                    
                    Text("Add Topping")
                        .font(.title)
                        .padding()
                    
                    ForEach(self.toppings, id: \.self){ topping in
                        ToppingListRow(topping: topping, order: self.$order)
                            .frame(width:g.size.width, alignment: .leading)
                    }
                    Text("Add Additional Topping")
                        .font(.title)
                        .padding()
                    ForEach(self.additionalTopping, id: \.self){ topping in
                        ToppingListRow(topping: topping, order: self.$order)
                            .frame(width:g.size.width, alignment: .leading)
                    }
                    
                    
                    Text("Description")
                        .font(.title)
                    
                    Text(self.food.longDescription ?? "long description here")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                    
                }

                Button(action: {
                    self.cart.orders.append(self.order)
                    self.isPresented = false
                }){
                    Text("Add to Cart")
                }
                
                
                
            }
        }
    }
}




struct SingleProductView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
