
import Foundation
import ObjectMapper

struct User : Mappable {
	var id : Int?
	var username : String?
	var email : String?
	var gpsLng : String?
	var gpsLat : String?
	var gpsAddress : String?
	var name : String?
	var phone : String?
	var avatar : String?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}
    
    init(id:Int,username:String,email:String,gpsLng:String,gpsLat:String,gpsAddress:String,name:String,phone:String,avatar:String,created_at:String,updated_at:String) {
        self.id = id
        self.username = username
        self.email = email
        self.gpsLng = gpsLng
        self.gpsLat = gpsLat
        self.gpsAddress = gpsAddress
        self.name = name
        self.phone = phone
        self.avatar = avatar
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
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
