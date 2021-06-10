

import Foundation
import ObjectMapper

struct NotificationData : Mappable {
	var id : Int?
	var type : String?
	var target : String?
	var params : String?
	var url : String?
	var status : Int?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		type <- map["type"]
		target <- map["target"]
		params <- map["params"]
		url <- map["url"]
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
