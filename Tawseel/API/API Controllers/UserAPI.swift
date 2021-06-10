//
//  UserAPI.swift
//  Tawseel
//
//  Created by macbook on 28/03/2021.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import SVProgressHUD
import Firebase
import CoreLocation
import TRVSEventSource
class UserAPI{
    
    public static var shard: UserAPI = {
        let userApi = UserAPI()
        return userApi
    }()
    
    
    func register(viewController:UIViewController,userName:String,password:String,email:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String])->Void) {
        SVProgressHUD.show()
        Alamofire.request(API_URLs.Register.url,method: .post, parameters: ["username":userName,"password":password,"email":email,"device_type":"ios","fcm_token":UserDefaultsData.shard.getFCMToken()],headers: ["lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value {
                    callBack(baseResponse.status!,baseResponse.token ?? "",baseResponse.data!,baseResponse.message!)
                    return
                }
            }
            callBack(false,"",nil,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func login(userName:String,password:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String])->Void){
        SVProgressHUD.show()
        Alamofire.request(API_URLs.Login.url,method: .post,parameters: ["username":userName,"password":password,"device_type":"ios","fcm_token":UserDefaultsData.shard.getFCMToken()],headers: ["lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value {
                    callBack(baseResponse.status!,baseResponse.token ?? "",baseResponse.data!,baseResponse.message!)
                    return
                }
            }
            callBack(false,"",nil,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func logout(callBack:@escaping (_ status:Bool,_ message:[String])->Void) {
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Logout.url,method: .post,headers: headers).responseObject {
            (response:DataResponse<BaseResponseArray<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value {
                    callBack(baseResponse.status!,baseResponse.message!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func loginWithSoicalMedia(type:SoicalLoginType,email:String,id:String,name:String,callBack:@escaping(_ status:Bool,_ user:User?,_ messages:[String],_ token:String)->Void){
        SVProgressHUD.show()
        
        Alamofire.request("http://tawseel.pal-dev.com/api/user/social-login/\(type.rawValue)",method: .post,parameters: ["email":email,"id":id,"name":name,"device_type":"ios","fcm_token":UserDefaultsData.shard.getFCMToken()],headers: ["lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]).responseObject { (response:DataResponse<BaseResponseObject<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.data!,baseResponse.message!,baseResponse.token!)
                    return
                }
            }
            callBack(false,nil,[NSLocalizedString("Sorry,Server Error", comment: "")],"")
        }
    }
    
    
    func signInWithCardinateInFirebase(cardinate:AuthCredential,callback: @escaping (_ status:Bool)->Void) {
        SVProgressHUD.show()
        Auth.auth().signIn(with: cardinate) { (authData, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                if let window = UIApplication.shared.windows.first,let root = window.rootViewController{
                    GeneralActions.shard.showAlert(target: root, title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                }
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    
    
    func setProfileData(lat:Double,lng:Double,address:String,name:String,phone:String,avatar:UIImage?,callBack:@escaping(_ status:Bool,_ messages:[String],_ user:User?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        let parameters:[String:Any] = ["gpsLat":lat,"gpsLng":lng,"gpsAddress":address,"name":name,"phone":phone]
        Alamofire.upload(multipartFormData: { multipartFormData in

            if let data = avatar{
                guard let imgData = data.jpegData(compressionQuality: 0.5) else { return }
                multipartFormData.append(imgData, withName: "avatar", fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Double {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }

            }
          
        },
        to: URL(string: API_URLs.Show_Get_Profile.url)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON { (response:DataResponse<Any>) in
                    SVProgressHUD.dismiss()
                    let json = response.data
                    if (json != nil)
                    {
                        let jsonData = try! JSONSerialization.jsonObject(with: json!, options: []) as? [String: Any]
                        if let jsonData = jsonData{
                            let stauts = jsonData["status"] as! Bool
                            let messages = jsonData["message"] as! [String]
                            let decoder = JSONDecoder()
                            do {
                                let user = try decoder.decode(User.self, from: try JSONSerialization.data(withJSONObject: jsonData["data"]!))
                                callBack(stauts, messages,stauts ?  user : nil)
                            } catch {
                                callBack(false,[error.localizedDescription],nil)
                            }

                        }
                    }
                }

                break
            case .failure(let error):
                callBack(false,[error.localizedDescription],nil)
                break
                
            }
        }
    }
    
    
    func getProfileData(callBack:@escaping(_ status:Bool,_ messages:[String],_ user:User?)->Void) {
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Show_Get_Profile.url,method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseObject<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.status! ? baseResponse.data! : nil)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func restPassword(username:String,email:String,callBack:@escaping(_ status:Bool,_ messages:[String])->Void){
        SVProgressHUD.show()
        Alamofire.request(API_URLs.ResetPassword.url,method: .post,parameters: ["username":username,"email":email],headers: ["lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]).responseObject { (response:DataResponse<BaseResponseArray<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let basedResponse = response.result.value{
                    callBack(basedResponse.status!,basedResponse.message!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    func getAllDriver(lat:String,lng:String,callBack:@escaping(_ status:Bool,_ messages:[String],_ drivers:[Driver]?)->Void) {
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request( API_URLs.Drivers.withTwoIDs(id1: lat, id2:lng),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Driver>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.stauts ?? baseResponse.status! ,baseResponse.message!,baseResponse.data)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getChatData(id:String,orderId:String?,callBack:@escaping(_ status:Bool,_ messages:[String],_ chatInfo:ChatInfo?)->Void) {
        let url = orderId == nil ? API_URLs.Chat_Between_User_And_Driver.withId(id: id) : API_URLs.Chat_Between_User_And_Driver.withTwoIDs(id1: id, id2: orderId!)
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(url , headers: headers ).responseObject { (response: DataResponse<BaseResponseObject<ChatInfo>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let basedResponse = response.result.value{
                    callBack(basedResponse.status!,basedResponse.message!,basedResponse.status! ? basedResponse.data! : nil)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func sendMessage(to:Int,type:String,messageText:String,isFirst:Bool,orderId:Int?,callBack:@escaping (_ status:Bool,_ messages:[String],_ sendMessageData:ChatMessage?)->Void){
        let parameters:Parameters =  isFirst ? ["to":to,"type":type,"message":messageText,"first":"\(isFirst)"] : ["to":to,"type":type,"message":messageText,"order_id":orderId!]
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Send_Message.url,method: .post,parameters: parameters,headers: headers).responseObject { (response:DataResponse<BaseResponseObject<ChatMessage>>) in
            if response.result.isSuccess{
                if let basedResponse = response.result.value{
                    callBack(basedResponse.status!,basedResponse.message!,basedResponse.data)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func chatContacts(pageNumber:Int,callBack:@escaping (_ status:Bool,_ messages:[String],_ chatContentData:[ChatContactData]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        let parameters:Parameters = ["page":pageNumber]
        Alamofire.request(API_URLs.Chat_Contacts.url,parameters: parameters,headers: headers).responseObject { (reponse:DataResponse<BaseResponseArray<ChatContactData>>) in
            SVProgressHUD.dismiss()
            if reponse.result.isSuccess{
                if let baseResponse = reponse.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func filterDrivers(location:CLLocationCoordinate2D?,stars:Double,inside:Bool,callBack:@escaping(_ status:Bool,_ messages:[String],_ driver:[Driver]?)->Void) {
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        let parameters:Parameters = ["lat":location!.latitude,"lng":location!.longitude,"stars":stars,"inside":inside]
        Alamofire.request(API_URLs.Filter_Drivers.url,method: .post,parameters: parameters,headers: headers).responseObject { (reponse:DataResponse<BaseResponseArray<Driver>>) in
            SVProgressHUD.dismiss()
            if reponse.result.isSuccess{
                if let basedResponse = reponse.result.value{
                    callBack(basedResponse.status!,basedResponse.message!,basedResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getCurrentOrders(pageNumber:Int,callBack:@escaping (_ status:Bool,_ messages:[String],_ orders:[Order]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Current_Orders.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Order>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.stauts ?? baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getFinishedOrders(pageNumber:Int,callBack:@escaping (_ status:Bool,_ messages:[String],_ orders:[Order]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Finished_Orders.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Order>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status ?? baseResponse.stauts!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func deleteChat(order_id:Int,callBack: @escaping(_ status:Bool,_ messages:[String])->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Delete_Chat.withId(id: String(order_id)),method: .post,headers: headers).responseObject { (response: DataResponse<BaseResponseArray<ChatContactData>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    func getPaidBills(pageNumber:Int,callBack:@escaping(_ status:Bool,_ messsages:[String],_ orders:[Order]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Paid_Bills.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Order>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getCanceledBills(pageNumber:Int,callBack:@escaping(_ status:Bool,_ messsages:[String],_ orders:[Order]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Canceled_Bills.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Order>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getBillById(id:Int,callBack:@escaping(_ status:Bool,_ messages:[String],_ order:Order?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Bill.withId(id: String(id)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseObject<Order>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func searchForDriver(driverName:String,callBack:@escaping(_ status:Bool,_ messages:[String],_ drivers:[Driver]?)->Void) {
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Search.url,method: .post ,parameters: ["name":driverName],headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Driver>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getNotification(pageNumber:Int,callBack:@escaping (_ status:Bool,_ messages:[String],_ data:[NotificationData]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Notifications.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<NotificationData>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
    
    
    func getRatings(pageNumber:Int,callBack:@escaping(_ status:Bool,_ messages:[String],_ data:[Rate]?)->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Ratings.withId(id: String(pageNumber)),method: .get,headers: headers).responseObject { (response:DataResponse<BaseResponseArrayRatings>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    if let status = baseResponse.status{
                        callBack(status,baseResponse.message!,nil)
                        return
                    }else{
                        callBack(true,[],baseResponse.ratings!)
                        return
                    }
                }
            }
            
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
        }
    }
 
    
    func updateRate(ratingId:String,driverId:String,comment:String,stars:Double,callBack:@escaping(_ status:Bool,_ message:[String])->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        let param:Parameters = ["to":driverId,"text":comment,"stars":stars]
        Alamofire.request(API_URLs.Update_Rate.withId(id: ratingId),method: .post,parameters: param,headers: headers).responseObject { (response:DataResponse<BaseResponseArray<Rate>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let baseResponse = response.result.value{
                    callBack(baseResponse.status!,baseResponse.message!)
                    return
                }
            }
            
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func updateFCMToken(device:String,FCMToken:String,callBack:@escaping(_ status:Bool,_ messages:[String])->Void){
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Update_FCM_Token.url,method: .post,parameters: ["device":device,"FCMtoken":FCMToken],headers: headers).responseObject { (response:DataResponse<BaseResponseObject<User>>) in
            if response.result.isSuccess{
                if let baseResponse = response.result.value {
                    callBack(baseResponse.status!,baseResponse.message!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func deleteBillById(billId:String,callBack:@escaping (_ status:Bool,_ messages:[String]) -> Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Delete_Bill.withId(id: billId),method: .post,headers: headers).responseObject { (response:DataResponse<BaseResponseObject<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let basedResponse = response.result.value{
                    callBack(basedResponse.status!,basedResponse.message!)
                    return
                }
            }
            
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    
    func deleteNotification(notificationId:String,callBack:@escaping(_ status:Bool,_ message:[String])->Void){
        SVProgressHUD.show()
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
        Alamofire.request(API_URLs.Delete_Notification.withId(id: notificationId),method: .post,headers: headers).responseObject { (response:DataResponse<BaseResponseObject<NotificationData>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                if let basedResponse = response.result.value{
                    callBack(basedResponse.status!,basedResponse.message!)
                    return
                }
            }
            callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")])
        }
    }
    
    func sendFileMessage(image:UIImage?,url:URL?,to:Int,type:String,isFirst:Bool,orderId:Int?,callBack:@escaping (_ status:Bool,_ messages:[String],_ sendMessageData:ChatMessage?)-> Void){
        SVProgressHUD.show()
        let parameters:Parameters =  isFirst ? ["to":to,"type":type,"first":"\(isFirst)"] : ["to":to,"type":type,"order_id":orderId!]
        let headers:HTTPHeaders = ["Authorization":UserDefaultsData.shard.getToken(),"lang":L102Language.currentAppleLanguage(),"Accept":"application/json"]
    
        Alamofire.upload(multipartFormData: { multipartFormData in
            if type == "audio" || type == "video" {
                multipartFormData.append(url!, withName: "message")
            }else{
                guard let imgData = image!.jpegData(compressionQuality: 0.5) else { return }
                    multipartFormData.append(imgData, withName: "message", fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Double {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            }

        },
        to: URL(string: API_URLs.Send_Message.url)!, method: .post , headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result{
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseObject { (response:DataResponse<BaseResponseObject<ChatMessage>>) in
                    SVProgressHUD.dismiss()
                    if response.result.isSuccess{
                        if let baseResponse = response.result.value{
                            callBack(baseResponse.status!,baseResponse.message!,baseResponse.data!)
                            return
                        }
                    }
                    callBack(false,[NSLocalizedString("Sorry,Server Error", comment: "")],nil)
                }
                break
            case .failure(let error):
                callBack(false,[error.localizedDescription],nil)
                break
            }
        }
    }

}


enum SoicalLoginType : String {
    case facebook = "facebook"
    case google = "google"
    case apple = "apple"
}

