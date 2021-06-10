
import Foundation
import ObjectMapper

struct ChatMessage : Mappable , Decodable{
	var id : Int?
	var order_id : Int?
	var from : String?
	var sender_type : String?
	var to : String?
	var reciver_type : String?
	var message : String?
	var type : String?
	var created_at : String?
	var updated_at : String?
    
	init?(map: Map) {

	}
    
	mutating func mapping(map: Map) {

		id <- map["id"]
		order_id <- map["order_id"]
		from <- map["from"]
		sender_type <- map["sender_type"]
		to <- map["to"]
		reciver_type <- map["reciver_type"]
		message <- map["message"]
		type <- map["type"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}
}


