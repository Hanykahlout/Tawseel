
import Foundation
import ObjectMapper

struct User : Mappable , Decodable {
	var id : Int?
	var username : String?
	var email : String?
	var gpsLng : Double?
	var gpsLat : Double?
	var gpsAddress : String?
	var name : String?
	var phone : String?
	var avatar : String?
	var fcm_token : String?
	var device_type : String?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}
    
    init(id:Int,username:String,email:String,gpsLng:Double,gpsLat:Double,gpsAddress:String,name:String,phone:String,avatar:String,fcm_token:String,device_type:String,created_at:String,updated_at:String) {
        self.id = id
        self.username = username
        self.email = email
        self.gpsLng = gpsLng
        self.gpsLat = gpsLat
        self.gpsAddress = gpsAddress
        self.name = name
        self.phone = phone
        self.avatar = avatar
        self.fcm_token = fcm_token
        self.device_type = device_type
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
	mutating func mapping(map: Map) {

		id <- map["id"]
		username <- map["username"]
		email <- map["email"]
		gpsLng <- map["gpsLng"]
		gpsLat <- map["gpsLat"]
		gpsAddress <- map["gpsAddress"]
		name <- map["name"]
		phone <- map["phone"]
		avatar <- map["avatar"]
		fcm_token <- map["fcm_token"]
		device_type <- map["device_type"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
