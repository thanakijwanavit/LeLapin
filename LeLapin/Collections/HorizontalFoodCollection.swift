//
//  FoodCollectionView.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct HorizontalFoodCollection: View {
    var foodList:[Food]
    @State var rotation:Double = 0
    var body: some View {
        GeometryReader{ g in
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    
                    Spacer().frame(width:100)
                    
                    ForEach(self.foodList ,id: \.self){ food in
                        FoodCollectionCell(g: g, food: food)
                    }
                    Spacer().frame(width:100)

                }
            }
        }
    }
    
    func scaleValue(g:GeometryProxy,globalg:GeometryProxy)->CGFloat{
        let localMid = g.frame(in: .global).midX
        let globalMid = globalg.frame(in: .global).midX
        let diff = localMid - globalMid
        let isNegative = (localMid - globalMid) < 0
        let multiplier:CGFloat = 0.005
        let initial:CGFloat = 1.8
        if isNegative {
            return initial - CGFloat(-diff) * multiplier
        } else {
            return initial - CGFloat(diff) * multiplier
        }
    }
}

struct HorizontalFoodCollection_Previews: PreviewProvider {
    let food:Food
    
    
    
    static var previews: some View {
        let food = Food()!
        food.cat = "cat"
        food.name = "name"
        food.imageLink = "image"
        food.foodType = "type"
        
        return HorizontalFoodCollection(foodList: [food,food,food])
    }
}
