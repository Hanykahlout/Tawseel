//
//  BaseResponseString.swift
//  Tawseel
//
//  Created by macbook on 28/04/2021.
//

import Foundation
import Foundation
import ObjectMapper

struct BaseResponseStringObject : Mappable {
    var status : Bool?
    var data : String?
    var message : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
        message <- map["message"]
    }

}
