//
//  CheckoutImage.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/12/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CheckOutImage : View {
    @EnvironmentObject var cart:Cart
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    var orderID:Int
    var g:GeometryProxy
    
    var body: some View{
        KFImage(orderID < self.cart.orders.count ? self.cart.orders[orderID].base.wrappedImage: URL(string: "https://le-lapin.s3.amazonaws.com/main+dish/1.png")!)
        .resizable()
        .scaledToFit()
            .scaleEffect(1.5)
        .frame(width: g.size.width/2, height: g.size.width/2, alignment: .center)
        
        .pinchToZoom()
        //drag gesture
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
    }
}

struct CheckOutImage_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ g in
            CheckOutImage(orderID: 0, g: g)
                .environmentObject(Cart())
        }
    }
}
