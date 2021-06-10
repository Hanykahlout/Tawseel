//
//  BaseResponseArray.swift
//  Tawseel
//
//  Created by macbook on 29/03/2021.
//

import Foundation
import ObjectMapper

struct BaseResponseArray<T : Mappable> : Mappable {
    var stauts : Bool?
    var status : Bool?
    var token : String?
    var data : [T]?
    var message : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        stauts <- map["stauts"]
        status <- map["status"]
        token <- map["token"]
        data <- map["data"]
        message <- map["message"]
    }

}
