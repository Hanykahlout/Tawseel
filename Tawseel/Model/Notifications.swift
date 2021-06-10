//
//  NotificationInfo.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import Foundation

struct Notifications {
    var id:Int
    var isNew:Bool
    var text:String
    var time:Date
    var aciton: ()-> Void
}
