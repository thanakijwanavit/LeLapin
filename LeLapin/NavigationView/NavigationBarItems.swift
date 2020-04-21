//
//  NavigationBarItems.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct MainNavigtionLeadingItems: View {
    @State var isActive:Bool = false
    
    var body: some View {
        HStack{
            NavigationLink(destination: ProfileMenu(), isActive: self.$isActive) {
            ZStack{
                Image(systemName: "line.horizontal.3")
                .resizable()
                .scaledToFill()
            }
            .frame(width: 12, height: 12, alignment: .center)
            .padding()
            
        }
        .isDetailLink(false)
            
//            Button("test order food"){
//                lambdaApi.testOrderFood()
//            }
            
        }
    }
}


struct MainNavigtionTrailingItems: View {
    
    var g: GeometryProxy
    @State var isActive:Bool = false
    @EnvironmentObject var cart:Cart
    var body: some View {
        
        HStack{
            KFImage(URL(string: "https://go.aws/2V8E8VO")!)
                .resizable()
                .scaledToFill()
                .frame(width: 50)
                .padding(.trailing, (g.size.width / 2.0) - 100)
            
            NavigationLink(
                destination: CheckoutView(isActive: self.$isActive).environmentObject(self.cart),
                label: {
                ZStack(alignment: .topTrailing){
                    
                    Image(systemName: cart.orders.count == 0 ? "cart":"cart.fill")
                        .colorMultiply(.blue)
                        .frame(width: 50, height: 50, alignment: .center)
                    
                    if self.cart.orders.count > 0 {
                        Image(systemName: "\(cart.orders.count).circle")
                        .resizable()
                        .colorMultiply(.red)
                        .foregroundColor(.red)
                        .scaledToFit()
                        .frame(width: 10, height: 10, alignment: .center)
                        .padding(10)
                    }
                }
            })
                .isDetailLink(true)
                .buttonStyle(BorderlessButtonStyle())
                .disabled(self.cart.orders.count > 0 ? false:true)
                .frame(width: 50)
                .onAppear{
                    if !self.isActive{
                        self.isActive = true
                    }
            }
        }
    }
    func clearCart(){
        self.cart.orders.removeAll()
    }
}


struct NavigationBarItems_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ g in
            MainNavigtionTrailingItems(g: g)
            .environmentObject(Cart())
        }
    }
}
