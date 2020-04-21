//
//  CheckoutButtonStyle.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/17/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI
struct CheckoutButtonStyle: ButtonStyle {
    
    var activated:Bool
    func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .padding()
        .foregroundColor(.white)
        .background(configuration.isPressed ? Color.red : self.activated ? Color.red:Color.blue)
        .frame(height: 35)
        .cornerRadius(50.0)
    }
}
