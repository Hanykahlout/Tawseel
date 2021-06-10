
import Foundation
import ObjectMapper

struct ChatContactData : Mappable {
	var message : String?
	var type : String?
	var created_at : String?
	var order_id : Int?
	var driver_id : Int?
	var unreaded : String?
	var iDName : String?
	var avatar : String?
    
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		message <- map["message"]
		type <- map["type"]
		created_at <- map["created_at"]
		order_id <- map["order_id"]
		driver_id <- map["driver_id"]
		unreaded <- map["unreaded"]
		iDName <- map["IDName"]
		avatar <- map["avatar"]
        
        
	}

}

