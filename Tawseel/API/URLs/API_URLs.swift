//
//  APIURLs.swift
//  Tawseel
//
//  Created by macbook on 27/03/2021.
//

import Foundation



public enum API_URLs : String {
    
    case Base_URL = "http://tawseel.pal-dev.com/api/"
    
    case Register = "user/register"
    case Login = "user/login"
    case Show_Get_Profile = "user/profile"
    case ResetPassword = "user/reset-password"
    case Logout = "user/logout"
    case Payment_And_Accept_Order = "user/accept-order/{id}"
    case Cancel_Order = "user/cancel-order/{id}"
    case Notifications = "user/notifications?page={id}"
    case Delete_Notification = "user/delete-notification/{id}"
    case Drivers = "user/drivers?lat={id1}&lng={id2}"
    case Confirm_Deliverd_Order = "user/confirm-deliverd-order/{id}"
    case Current_Orders = "user/current-orders?page={id}"
    case Finished_Orders = "user/finished-orders?page={id}"
    case Show_Order = "user/order/{id}"
    case Chat_Contacts = "user/drivers-chat"
    case Chat_Between_User_And_Driver = "user/chat/{id1}/{id2}"
    case Delete_Chat = "user/delete-chat/{id}"
    case Send_Message = "user/send-message"
    case Paid_Bills = "user/paid-bills?page={id}"
    case Canceled_Bills = "user/canceled-bills?page={id}"
    case Bill = "user/bill/{id}"
    case Delete_Bill = "user/delete-bill/{id}"
    case Add_Rate = "user/add-rate"
    case Ratings = "user/ratings?page={id}"
    case Update_Rate = "user/update-rate/{id}"
    case Filter_Drivers = "user/filter-drivers"
    case Update_FCM_Token = "user/update-fcm-token"
    case Facebook_Login = "user/social-login/facebook"
    case Google_Login = "user/social-login/google"
    case Search = "user/search"
    
    
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
    
    
    func withId(id:String) -> String {
        switch self {
        case .Chat_Between_User_And_Driver:
            var url = self.rawValue
            url = url.replacingOccurrences(of: "{id1}", with: "\(id)")
            url = url.replacingOccurrences(of: "/{id2}", with: "")
            
            return "\(API_URLs.Base_URL.rawValue)\(url)"
        case .Payment_And_Accept_Order , .Cancel_Order , .Confirm_Deliverd_Order , .Show_Order , .Delete_Chat , .Bill ,.Delete_Notification, .Update_Rate , .Current_Orders , .Finished_Orders,.Paid_Bills,.Ratings,.Canceled_Bills,.Delete_Bill,.Notifications:
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}", with: "\(id)"))"
        default:
            return ""
        }
    }
    
    func withTwoIDs(id1:String,id2:String) -> String{
        switch self {
        case .Chat_Between_User_And_Driver :
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id1}/{id2}", with: "\(id1)/\(id2)"))"
        case .Drivers:
            return "\(API_URLs.Base_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "lat={id1}&lng={id2}", with: "lat=\(id1)&lng=\(id2)"))"
        default:
            return ""
        }
    }
     
}
