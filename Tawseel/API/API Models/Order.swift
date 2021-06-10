
import Foundation
import ObjectMapper

struct Order : Mappable {
	var id : Int?
	var user_id : String?
	var driver_id : String?
	var status : String?
	var price : Int?
	var from_lat : Double?
	var from_lng : Double?
	var from_address : String?
	var to_lat : Double?
	var to_lng : Double?
	var to_address : String?
	var created_at : String?
	var updated_at : String?
	var iDName : String?
    var current_lat:Double?
    var current_lng:Double?
    var bill_id:String?
    var payment_method:String?
    var name:String?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		driver_id <- map["driver_id"]
		status <- map["status"]
		price <- map["price"]
		from_lat <- map["from_lat"]
		from_lng <- map["from_lng"]
		from_address <- map["from_address"]
		to_lat <- map["to_lat"]
		to_lng <- map["to_lng"]
		to_address <- map["to_address"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		iDName <- map["IDName"]
        current_lat <- map["current_lat"]
        current_lng <- map["current_lng"]
        bill_id <- map["bill_id"]
        payment_method <- map["payment_method"]
        name <- map["name"]
        
        
	}

}
