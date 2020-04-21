//
//  NavigationView.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/10/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct NavigationViewController:View {
    let appearance = UINavigationBarAppearance()
    
    
    var body: some View{
        GeometryReader{ g in
            NavigationView{
                HomeView(g: g)
                    .navigationBarItems(leading: MainNavigtionLeadingItems()
                    ,trailing: MainNavigtionTrailingItems(g: g))
            }
        }
    }
}


extension UINavigationController{
    override open func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0.10, alpha: 0.9)
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        let appearance2 = UINavigationBarAppearance()
        appearance2.configureWithTransparentBackground()
        appearance2.backgroundColor = UIColor(red: 0, green: 0, blue: 0.10, alpha: 0.05)
        navigationBar.scrollEdgeAppearance = appearance2
        

    }
}

struct NavigationViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
