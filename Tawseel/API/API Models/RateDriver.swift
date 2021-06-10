//
//  RateDriver.swift
//  Tawseel
//
//  Created by macbook on 01/05/2021.
//

import Foundation
import ObjectMapper

struct RateDriver : Mappable {
    var id : Int?
    var iDName : String?
    var avatar : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        iDName <- map["IDName"]
        avatar <- map["avatar"]
    }

}
