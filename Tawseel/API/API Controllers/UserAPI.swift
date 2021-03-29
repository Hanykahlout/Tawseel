//
//  UserAPI.swift
//  Tawseel
//
//  Created by macbook on 28/03/2021.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class UserAPI{
    
    public static var shared: UserAPI = {
        let userApi = UserAPI()
        return userApi
    }()
    
    func register(userName:String,password:String,email:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String]?)->Void) {
        Alamofire.request(API_URLs.Register.url,method: .post, parameters: ["username":userName,"password":password,"email":email],headers: ["lang":"en"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
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
    
    func login(userName:String,password:String,callBack:@escaping (_ status:Bool,_ token:String,_ user:User?,_ message:[String]?)->Void){
        Alamofire.request(API_URLs.Login.url,method: .post,parameters: ["username":userName,"password":password],headers: ["lang":"en"]).responseObject { (response: DataResponse<BaseResponseObject<User>>) in
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
    
    func logout(callBack:@escaping (_ status:Bool)->Void) {
        Alamofire.request(API_URLs.Logout.url,method: .post,headers: ["Authorization":UserDefaultsData.shared.getToken()]).responseObject { (response:DataResponse<BaseResponseArray<User>>) in
            if response.result.isSuccess{
                callBack(true)
            }else{
                callBack(false)
            }
        }
    }
    
}

