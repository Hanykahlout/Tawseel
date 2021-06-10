import Foundation
import ObjectMapper

struct Rate : Mappable {
	var id : Int?
	var from : String?
	var to : String?
	var text : String?
	var stars : Int?
	var created_at : String?
	var updated_at : String?
	var driver : RateDriver?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		from <- map["from"]
		to <- map["to"]
		text <- map["text"]
		stars <- map["stars"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		driver <- map["driver"]
	}

}
