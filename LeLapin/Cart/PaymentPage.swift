//
//  PaymentPage.swift
//  LeLapin
//
//  Created by nic Wanavit on 4/11/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct PaymentPage: View {
    @Binding var isActive:Bool
    @EnvironmentObject var cart:Cart
    @State var name:String
    @State var email:String
    @State var lineID:String
    @State var phoneNumber:String
    @State var address:String
    @State var mapLink:String
    @State var showingAlert:Bool = false
    @State var alertText:String = ""
    @State private var deliveryDate = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    init(isActive:Binding<Bool>){
        let data = UserDefaults.standard.object(forKey: "user")
        _isActive = isActive
        
        var decodedUser:User? = nil
        if let data = data {
            let decoder = JSONDecoder()
            do {
                decodedUser = try decoder.decode(User.self, from: data as! Data)
            } catch {
                debugPrint("decoding user error")
            }
        }
        
        var user:User = User()
        
        if let decodedUser = decodedUser {
            user = decodedUser
        } else {
            debugPrint("error decoding")
        }
        
        
        _name = State(initialValue: user.name ?? "")
        _email = State(initialValue: user.email ?? "")
        _lineID = State(initialValue: user.lineID ?? "")
        _phoneNumber = State(initialValue: user.phoneNumber ?? "")
        _address = State(initialValue: user.address ?? "")
        _mapLink = State(initialValue: user.mapLink ?? "")
        
    }
    
    var body: some View{
        
        KeyboardHost{
        
        VStack {
//            Button("pop to root"){
//                self.popToRoot()
//            }
            
            
            HStack{
                Text("Total Cost ")
                Text("\(cart.total)")
                    .foregroundColor(.orange)
                Text("THB")
            }
                .font(.title)
            
            List{
                DatePicker(selection: self.$deliveryDate, in: Date()...Date(timeIntervalSinceNow: 1.2e6), displayedComponents: [.date, .hourAndMinute]) {
                    Text("delivery time")
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                

                Text("Delivery on \(deliveryDate, formatter: dateFormatter)")
                
                TextField("name", text: $name)
                TextField("address", text: $address)
                TextField("map link", text: $mapLink)
                TextField("email", text: $email)
                TextField("lineID", text: $lineID)
                TextField("phoneNumber", text: $phoneNumber)
                
                
                HStack{
                    Spacer()
                
                    VStack{
                        Button("Order"){
                            self.saveToUserDefaults()
                            self.showingAlert = true
                            debugPrint("sending order",self.cart.codableCart)
                            if lambdaApi.orderFood(cart: self.cart, user: self.getUser(), deliveryDate: self.deliveryDate){
                                self.alertText = SuccessAlertString
                                self.showingAlert = true
                                self.isActive = false
                                debugPrint(self.isActive)
                            } else {
                                self.alertText = FailedAlertString
                            }
                        }
                        .buttonStyle(CheckoutButtonStyle(activated: false))
                        Text("we will contact you shortly")
                        Text("or call us at 0894993888")
                        .font(.footnote)
                    }
                    
                    
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                .alert(isPresented: self.$showingAlert){
                    Alert(title: Text(self.alertText), dismissButton: self.alertText == SuccessAlertString ? Alert.Button.default(Text("OK")){ self.popToRoot()} : Alert.Button.default(Text("OK")))
                    }
                Spacer()
            }
        }
        .onTapGesture {
            self.saveToUserDefaults()
            UIApplication.shared.endEditing()
        }
        }
        
    }
    
    func getUser()->User{
        var user = User()
        user.name = self.name
        user.email = self.email
        user.lineID = self.lineID
        user.phoneNumber = self.phoneNumber
        user.address = self.address
        user.mapLink = self.mapLink
        return user
    }
    
    func saveToUserDefaults(){
        
        var user = User()
        user.name = self.name
        user.email = self.email
        user.lineID = self.lineID
        user.phoneNumber = self.phoneNumber
        user.address = self.address
        user.mapLink = self.mapLink
        let encoder = JSONEncoder()
        do {
            UserDefaults.standard.set(try encoder.encode(user), forKey: "user")
        } catch {
            debugPrint(error)
        }
        
    }
    
    func popToRoot(){
        self.presentationMode.wrappedValue.dismiss()
        self.isActive = false
        debugPrint("is active ?", self.isActive)
    }
    
}
struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        let cart = Cart()
        let food =  Food()!
        food.name = "BaseName"
        let topping1 = Food()!
        topping1.name = "Topping1"
        let order = Order(base: food)
        order.topping.append(topping1)
        cart.orders.append(order)
        _ = cart.orders.first?.base.name
        
        return Group {
            PaymentPage(isActive: .constant(true))
            
            PaymentPage(isActive: .constant(true))
                .environment(\.colorScheme, .dark)
        }
            .environmentObject(cart)
    }
}
