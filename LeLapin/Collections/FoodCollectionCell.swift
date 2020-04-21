//
//  FoodCollectionCell.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct FoodCollectionCell:View {
    
    var g: GeometryProxy
    var food:Food
    @State var rotation2D:Double = 0
    @State var showSingleFood:Bool = false
    @EnvironmentObject var cart:Cart
    var body: some View {
        VStack(spacing: 5){
            GeometryReader{ gin in
                
                KFImage(self.food.wrappedImage)
                    .placeholder{
                        KFImage(URL(string: "https://le-lapin.s3.amazonaws.com/main+dish/1.png")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.g.size.width / 2, height:  self.g.size.width + 50 / 2)
                }
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.g.size.width / 2, height:  self.g.size.width / 2)
                    .rotation3DEffect(.init(degrees: self.rotationValue(g: self.g, gin: gin)), axis: (x: -0.1, y: 1, z: -0.1))
                    .scaleEffect(self.scaleValue(g: gin, globalg: self.g))
                    
            }
            .onTapGesture {
                self.showSingleFood = true
            }
                .frame(width: self.g.size.width / 2, height:  self.g.size.width / 2)
            
            Text(food.shortName ?? "")
                .frame(width: self.g.size.width / 2, height: 80, alignment: .center)
                .lineLimit(3)
            
            Text("\(food.price ?? "999") THB")
                .font(.headline)
                .frame(width: self.g.size.width / 2, height: 30, alignment: .center)
            
            AddToCartButton(width: (self.g.size.width / 2) - 50, food: self.food)
                .padding(.vertical)
                .scaleEffect(CGFloat(1 + self.rotation2D))
                .animation(
                    Animation.interactiveSpring()
                )
                .onAppear {
                    self.rotation2D = 0.01
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.rotation2D = 0
                    }
                }
                .frame(height: 33)
            
            Button("Customize"){
                self.showSingleFood = true
            }
                .frame(height: 33)
            
            }
        .sheet(isPresented: self.$showSingleFood){
            SingleProductView(food: self.food, isPresented: self.$showSingleFood)
                .environmentObject(self.cart)
            }
        }
    
    func scaleValue(g:GeometryProxy,globalg:GeometryProxy)->CGFloat{
        let localMid = g.frame(in: .global).midX
        let globalMid = globalg.frame(in: .global).midX
        let diff = localMid - globalMid
        let isNegative = (localMid - globalMid) < 0
        let multiplier:CGFloat = 0.003
        let initial:CGFloat = self.food.foodType == "recommendedMenu" ? 1.2:1.4
        if isNegative {
            return initial - CGFloat(-diff) * multiplier
        } else {
            return initial - CGFloat(diff) * multiplier
        }
    }
    func rotationValue(g: GeometryProxy, gin: GeometryProxy)->Double{
        return Double(gin.frame(in: .global).minX - gin.size.width/2 ) * 0.3
    }
}

struct FoodCollectionCell_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
