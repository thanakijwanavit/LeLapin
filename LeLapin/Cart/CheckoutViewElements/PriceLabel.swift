//
//  PriceLabel.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/12/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI


struct PriceLabel: View {
    var totalCost: Int
    var body: some View{
        HStack{
            Text("Total Cost ")
            Text("\(self.totalCost)")
                .foregroundColor(.orange)
            Text("THB")
        }
            .font(.title)
    }
}
