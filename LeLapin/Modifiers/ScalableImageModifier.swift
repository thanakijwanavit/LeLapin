//
//  ScalableImageModifier.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/11/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
struct ScalableImageModifier:ViewModifier{
    func body(content: Content) -> some View {
        content
            .scaledToFit()
    }
}
