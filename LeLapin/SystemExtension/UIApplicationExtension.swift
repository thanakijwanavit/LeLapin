//
//  UIApplicationExtension.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/11/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
