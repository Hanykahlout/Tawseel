//
//  BaseResponseArrayRatings.swift
//  Tawseel
//
//  Created by macbook on 01/05/2021.
//

import Foundation
import ObjectMapper
struct BaseResponseArrayRatings : Mappable {
    
    var status : Bool?
    var message : [String]?
    var ratings:[Rate]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        ratings <- map["ratings"]
    }

}
