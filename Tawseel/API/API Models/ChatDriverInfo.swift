
import Foundation
import ObjectMapper

struct ChatDriverInfo : Mappable {
	var iDName : String?
	var avatar : String?
	var id : Int?
	var stars : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		iDName <- map["IDName"]
		avatar <- map["avatar"]
		id <- map["id"]
		stars <- map["stars"]
	}

}
