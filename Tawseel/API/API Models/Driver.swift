
import Foundation
import ObjectMapper

struct Driver : Mappable {
	var status : String?
	var id : Int?
	var gpsLat : Double?
	var gpsLng : Double?
	var gpsAddress : String?
    var stars : String?
    var distance : String?
    
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		status <- map["status"]
		id <- map["id"]
		gpsLat <- map["gpsLat"]
		gpsLng <- map["gpsLng"]
		gpsAddress <- map["gpsAddress"]
        stars <- map["stars"]
        distance <- map["distance"]
    
    }

    
}
