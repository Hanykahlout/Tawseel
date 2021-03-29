//
//  UserDefaultsData.swift
//  Tawseel
//
//  Created by macbook on 28/03/2021.
//


import Foundation

class UserDefaultsData {
    public static var shared: UserDefaultsData = {
        let userApi = UserDefaultsData()
        return userApi
    }()
    
    func setToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    func isloggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "token") ?? "" != ""
    }
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func saveUser(user:User) {
        UserDefaults.standard.setValue(user.id, forKey: "id")
        UserDefaults.standard.setValue(user.username, forKey: "username")
        UserDefaults.standard.setValue(user.email, forKey: "email")
        UserDefaults.standard.setValue(user.gpsLng, forKey: "gpsLng")
        UserDefaults.standard.setValue(user.gpsLat, forKey: "gpsLat")
        UserDefaults.standard.setValue(user.gpsAddress, forKey: "gpsAddress")
        UserDefaults.standard.setValue(user.name, forKey: "name")
        UserDefaults.standard.setValue(user.phone, forKey: "phone")
        UserDefaults.standard.setValue(user.avatar, forKey: "avatar")
        UserDefaults.standard.setValue(user.created_at, forKey: "created_at")
        UserDefaults.standard.setValue(user.updated_at, forKey: "updated_at")
    }
    
    func getUser() -> User {
        
        let id = UserDefaults.standard.integer(forKey: "id")
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gpsLng = UserDefaults.standard.string(forKey: "gpsLng") ?? ""
        let gpsLat = UserDefaults.standard.string(forKey: "gpsLat") ?? ""
        let gpsAddress = UserDefaults.standard.string(forKey: "gpsAddress") ?? ""
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        let avatar = UserDefaults.standard.string(forKey: "avatar") ?? ""
        let created_at = UserDefaults.standard.string(forKey: "created_at") ?? ""
        let updated_at = UserDefaults.standard.string(forKey: "updated_at") ?? ""
        
        return User(id: id, username: username, email: email, gpsLng: gpsLng, gpsLat: gpsLat, gpsAddress: gpsAddress, name: name, phone: phone, avatar: avatar, created_at: created_at, updated_at: updated_at)
        
    }
    
    func clearUserData(){
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "gpsLng")
        UserDefaults.standard.removeObject(forKey: "gpsLat")
        UserDefaults.standard.removeObject(forKey: "gpsAddress")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "avatar")
        UserDefaults.standard.removeObject(forKey: "created_at")
        UserDefaults.standard.removeObject(forKey: "updated_at")
    }
    
}


