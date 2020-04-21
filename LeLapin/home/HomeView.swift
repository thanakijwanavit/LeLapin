//
//  ContentView.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/8/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI
import AWSDynamoDB
import KingfisherSwiftUI

var foodList:[Food] = DynamoDBApi.getMainDish()
var recommendedList:[Food] = DynamoDBApi.getRecommended()
var toppingList:[Food] = DynamoDBApi.getTopping()
var additionalToppingList:[Food] = DynamoDBApi.getAdditionalTopping()


struct HomeView: View {
    var g : GeometryProxy
    
    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Color(UIColor(red: 0, green: 0, blue: 0.10, alpha: 1))
                .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            
                            
                            Text("Recommended")
                                .background(Color(TranLucentDefaultColor))
                                .font(.title)
                            HorizontalFoodCollection(foodList: recommendedList)
                                .frame(height: self.rowHeight(g: g))
                            
                            Text("Menu")
                                .font(.title)
                            
                            HorizontalFoodCollection(foodList: foodList)
                                .frame(height: self.rowHeight(g: g))
                            
                            
                            Text("Topping")
                                .font(.title)

                            HorizontalFoodCollection(foodList: toppingList)
                                .frame(height: self.rowHeight(g: g))
                            
                            
                            Text("Super Topping")
                                .font(.title)
                            HorizontalFoodCollection(foodList: additionalToppingList)
                            .frame(height: self.rowHeight(g: g))
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func rowHeight(g:GeometryProxy)->CGFloat{
        return (g.size.width / 2) + 250
    }
    
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ g in
            Group{
                HomeView(g: g)
                    .environment(\.colorScheme, .dark)
                
                CheckoutView( isActive: .constant(true))
            }
        }
    }
}
