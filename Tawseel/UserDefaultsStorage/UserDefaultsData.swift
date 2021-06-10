//
//  UserDefaultsData.swift
//  Tawseel
//
//  Created by macbook on 28/03/2021.
//


import UIKit

class UserDefaultsData {
    public static var shard: UserDefaultsData = {
        let userApi = UserDefaultsData()
        return userApi
    }()
    
    func setToken(token:String) {
        UserDefaults.standard.setValue("Bearer \(token)", forKey: "token")
    }
    
    func setFCMToken(fcmToken:String){
        UserDefaults.standard.setValue(fcmToken, forKey: "FCM_Token")
    }
    
    func getFCMToken() ->String{
        return UserDefaults.standard.string(forKey: "FCM_Token") ?? ""
    }
    
    func isloggedIn() -> Bool {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return false}
        return token != "Bearer "
    }
    
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    
    // MARK:- C.R.D. User Data
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
        UserDefaults.standard.setValue(user.fcm_token, forKey: "fcm_token")
        UserDefaults.standard.setValue(user.device_type, forKey: "device_type")
        
    }
    
    func getUser() -> User {
        
        let id = UserDefaults.standard.integer(forKey: "id")
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let gpsLng = UserDefaults.standard.double(forKey: "gpsLng")
        let gpsLat = UserDefaults.standard.double(forKey: "gpsLat")
        let gpsAddress = UserDefaults.standard.string(forKey: "gpsAddress") ?? ""
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let phone = UserDefaults.standard.string(forKey: "phone") ?? ""
        let avatar = UserDefaults.standard.string(forKey: "avatar") ?? ""
        let created_at = UserDefaults.standard.string(forKey: "created_at") ?? ""
        let updated_at = UserDefaults.standard.string(forKey: "updated_at") ?? ""
        let fcm_token = UserDefaults.standard.string(forKey: "fcm_token") ?? ""
        let device_type = UserDefaults.standard.string(forKey: "device_type") ?? ""
        return User(id: id, username: username, email: email, gpsLng: gpsLng, gpsLat: gpsLat, gpsAddress: gpsAddress, name: name, phone: phone, avatar: avatar,fcm_token:fcm_token,device_type:device_type, created_at: created_at, updated_at: updated_at)
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
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "fcm_token")
        UserDefaults.standard.removeObject(forKey: "device_type")
    }
    
    
 
    // MARK:- C.R.D. Visa Or Other Card Data
    
    func saveCardData(cardData:CardData){
        UserDefaults.standard.setValue(true, forKey: "Is_Exist_Card")
        UserDefaults.standard.setValue(cardData.number, forKey: "Card_Number")
        UserDefaults.standard.setValue(cardData.userName, forKey: "User_Name")
        UserDefaults.standard.setValue(cardData.cvv, forKey: "CVV")
        UserDefaults.standard.setValue(cardData.endDate, forKey: "End_Date")
    }
    
    
    func getSavedCardData()->CardData{
        let number = UserDefaults.standard.string(forKey: "Card_Number") ?? ""
        let userName = UserDefaults.standard.string(forKey: "User_Name") ?? ""
        let cvv = UserDefaults.standard.string(forKey: "CVV") ?? ""
        let endDate = UserDefaults.standard.string(forKey: "End_Date") ?? ""
        return CardData(number: number, userName: userName, cvv: cvv, endDate: endDate)
    }
    
    
    func removeCardData(){
        UserDefaults.standard.setValue(false, forKey: "Is_Exist_Card")
        UserDefaults.standard.removeObject(forKey: "Card_Number")
        UserDefaults.standard.removeObject(forKey: "User_Name")
        UserDefaults.standard.removeObject(forKey: "CVV")
        UserDefaults.standard.removeObject(forKey: "End_Date")
    }
    
    // MARK:- C.R.D. PayPal Card Data
    func savePayPalCardData(cardData:(email:String,password:String)){
        UserDefaults.standard.setValue(true, forKey: "Is_Exist_PayPal_Card")
        UserDefaults.standard.setValue(cardData.email, forKey: "PayPal_Email")
        UserDefaults.standard.setValue(cardData.password, forKey: "PayPal_Password")
    }
    
    
    func getSavedPayPalCardData()->(email:String,password:String){
        let email = UserDefaults.standard.string(forKey: "PayPal_Email") ?? ""
        let password = UserDefaults.standard.string(forKey: "PayPal_Password") ?? ""
        return (email:email,password:password)
    }
    
    
    func removePayPalCardData(){
        UserDefaults.standard.setValue(false, forKey: "Is_Exist_PayPal_Card")
        UserDefaults.standard.removeObject(forKey: "PayPal_Email")
        UserDefaults.standard.removeObject(forKey: "PayPal_Password")
    }
    
    
}


