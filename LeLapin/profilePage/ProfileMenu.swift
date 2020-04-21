//
//  ProfileMenu.swift
//  Villa2
//
//  Created by nic Wanavit on 4/5/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

class UserProfile: Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.hashValue > rhs.hashValue
    }
    
    
    var userId:String = "abcd1234"
    var SampleProfileData = [
        "name":"nic".capitalizingFirstLetter(),
        "memberId":"1234",
        "birthday": "1 feb 2020",
        "membership": "gold",
        "points": "123"
    ]
    var image = UIImage(systemName: "person")!.withTintColor(.white)
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.userId)
    }
}




struct ProfileMenu: View {
    var userProfile:UserProfile = UserProfile()
    @EnvironmentObject var cart:Cart
    @State var name:String
    @State var email:String
    @State var lineID:String
    @State var phoneNumber:String
    @State var address:String
    @State var mapLink:String
    @State var showingAlert:Bool = false
    @State var showImagePicker:Bool = false
//    @State var userImage:UIImage = UserProfile.image
    
    
    init(){
        let data = UserDefaults.standard.object(forKey: "user")
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
            debugPrint("user loaded successfully")
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
    
    var body: some View {
        let keys = userProfile.SampleProfileData.map{$0.key}
        let values = userProfile.SampleProfileData.map {$0.value}
        return KeyboardHost{GeometryReader{ g in
            List {
                //profile image
                Image(uiImage: self.readImageFromDocs() ?? UIImage(named: "profilePlaceholder") ?? UIImage(named: "LOGO")!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: g.size.width * 0.7, height: g.size.width * 0.7, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white , lineWidth: 10).shadow(radius: 2).opacity(0.6))
                    .shadow(radius: 2)
                    .padding()
                    .frame(width: g.size.width, height: g.size.width, alignment: .center)
                    .listRowInsets(EdgeInsets(top: -20, leading: 0, bottom: -20, trailing: -20))
                    .onTapGesture {
                        self.showImagePicker = true
                    }
                
                
                TextField("name", text: self.$name)
                TextField("address", text: self.$address)
                TextField("map link", text: self.$mapLink)
                TextField("email", text: self.$email)
                TextField("lineID", text: self.$lineID)
                TextField("phoneNumber", text: self.$phoneNumber)
                
                Button("save"){
                    self.saveToUserDefaults()
                }
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .onAppear{
                self.loadData()
            }
            .onTapGesture {
                debugPrint("on tap gesture")
                self.saveToUserDefaults()
                UIApplication.shared.endEditing()
            }
            .onDisappear{
                debugPrint("on disappear")
                self.saveToUserDefaults()
            }
            .sheet(isPresented: self.$showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.userProfile.image = image
                    self.writeImageToDocs(image: image)
                    
                    }
                }
            }
        }
    }
    
    func writeImageToDocs(image:UIImage){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent("filename.png")
        
        debugPrint("destination path is",destinationPath)
        
        do {
            try image.pngData()?.write(to: destinationPath)
        } catch {
            debugPrint("writing file error", error)
        }
    }

    func readImageFromDocs()->UIImage?{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent("filename.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        } else {
            return nil
        }
    }
    
    func loadData(){
        let data = UserDefaults.standard.object(forKey: "user")
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
            debugPrint("user loaded successfully")
        } else {
            debugPrint("error decoding")
        }
        
        
        self.name = user.name ?? ""
        self.email = user.email ?? ""
        self.lineID = user.lineID ?? ""
        self.phoneNumber = user.phoneNumber ?? ""
        self.address = user.address ?? ""
        self.mapLink = user.mapLink ?? ""
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
            debugPrint("save user successful")
        } catch {
            debugPrint(error)
        }
        
    }
}

struct ProfileMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ProfileMenu()
                       .environment(\.colorScheme, .dark)
            ProfileMenu()
        }
    }
}
