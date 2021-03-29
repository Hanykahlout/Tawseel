//
//  APIURLs.swift
//  Tawseel
//
//  Created by macbook on 27/03/2021.
//

import Foundation



public enum API_URLs : String {
    
    case Base_URL = "https://tawseel.ahmad-abu-hazaa.co/api/"
    
    case Register = "user/register"
    case Login = "user/login"
    case Show_Get_Profile = "user/profile"
    case ResetPassword = "user/reset-password"
    case Logout = "user/logout"
    case Payment_And_Accept_Order = "user/accept-order/{id}"
    case Cancel_Order = "user/cancel-order/{id}"
    case Notifications = "user/notifications"
    case Drivers = "user/drivers"
    case Confirm_Deliverd_Order = "user/confirm-deliverd-order/{id}"
    case Current_Orders = "user/current-orders"
    case Finished_Orders = "user/finished-orders"
    case Show_Order = "user/order/{id}"
    case Chat_Contacts = "user/drivers-chat"
    case Chat_Between_User_And_Driver = "user/chat/{id1}/{id2}"
    case Delete_Chat = "user/delete-chat/{id}"
    case Send_Message = "user/send-message"
    case Paid_Bills = "user/paid-bills"
    case Canceled_Bills = "user/canceled-bills"
    case Bill = "user/bill/{id}"
    case Add_Rate = "user/add-rate"
    case Ratings = "user/ratings"
    case Update_Rate = "user/update-rate/{id}"
    case Filter_Drivers = "user/filter-drivers"
    case Update_FCM_Token = "user/update-fcm-token"
    
    case Who_Us = "who-us"
    case Policies = "policies"
    case Contact_Us = "contact-us"
    case Whatsapp_Number = "whatsapp-number"
    
    
    var url :String {
        switch self {
        case .Base_URL:
            return API_URLs.Base_URL.rawValue
        default:
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue)"
        }
    }
    
    
    func withId(id:Int) -> String {
        switch self {
        case .Payment_And_Accept_Order , .Cancel_Order , .Confirm_Deliverd_Order , .Show_Order , .Delete_Chat , .Bill , .Update_Rate :
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}", with: "\(id)"))"
        default:
            return ""
        }
    }
    
    func withTwoIDs(id1:Int,id2:Int) -> String{
        switch self {
        case .Chat_Between_User_And_Driver :
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id1}/{id2}", with: "\(id1)/\(id2)"))"
        default:
            return ""
        }
    }
     
}
