//
//  ChatInfo.swift
//  Tawseel
//
//  Created by macbook on 16/04/2021.
//

import Foundation
import ObjectMapper

struct ChatInfo : Mappable {
    var driver : ChatDriverInfo?
    var messages : [ChatMessage]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        driver <- map["driver"]
        messages <- map["messages"]
    }

}
