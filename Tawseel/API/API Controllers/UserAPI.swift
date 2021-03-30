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

class UserAPI{
    
    public static var shared: UserAPI = {
        let userApi = UserAPI()
        return userApi
    }()
    
    func register(userName:String,password:String,email:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String]?)->Void) {
        SVProgressHUD.show()
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let fcmToken = token {
                Alamofire.request(API_URLs.Register.url,method: .post, parameters: ["username":userName,"password":password,"email":email,"device_type":"ios","fcm_token":fcmToken],headers: ["lang":"en","Accept":"application/json"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
                    SVProgressHUD.dismiss()
                    if let baseResponse = response.result.value {
                        if response.result.isSuccess{
                            if  let user = baseResponse.data , let token = baseResponse.token {
                                callBack(true,token,user,nil)
                            }else{
                                callBack(false,"",nil, baseResponse.message)
                            }
                            return
                        }
                        callBack(false,"",nil, baseResponse.message)
                    }else{
                        callBack(false,"",nil,["Sorry, There is an unknown error, we will resolve it as soon as possible"])
                    }
                }
            }
        }
        
    }
    
    func login(userName:String,password:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String]?)->Void){
        SVProgressHUD.show()
        Messaging.messaging().token { token, error in
            if let _ = error {
                callBack(false,"",nil,nil)
                return
            } else if let fcmToken = token {
                Alamofire.request(API_URLs.Login.url,method: .post,parameters: ["username":userName,"password":password,"device_type":"ios","fcm_token":fcmToken],headers: ["lang":"en","Accept":"application/json"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
                    SVProgressHUD.dismiss()
                    if let baseResponse = response.result.value {
                        if response.result.isSuccess{
                            if let user = baseResponse.data , let token = baseResponse.token{
                                callBack(true,token,user,nil)
                            }else{
                                callBack(false,"",nil, baseResponse.message)
                            }
                            return
                        }
                        callBack(false,"",nil,baseResponse.message)
                    }else{
                        callBack(false,"",nil,["Sorry, There is an unknown error, we will resolve it as soon as possible"])
                    }
                }
            }
        }
        
    }
    
    func logout(callBack:@escaping (_ status:Bool)->Void) {
        SVProgressHUD.show()
        Alamofire.request(API_URLs.Logout.url,method: .post,headers: ["Authorization":UserDefaultsData.shared.getToken(),"Accept":"application/json"]).responseObject {
            (response:DataResponse<BaseResponseArray<User>>) in
            SVProgressHUD.dismiss()
            if response.result.isSuccess{
                callBack(true)
                return
            }
            callBack(false)
        }
    }
    
}

