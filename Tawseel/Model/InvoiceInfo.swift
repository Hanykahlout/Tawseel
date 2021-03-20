//
//  InvoiceInfo.swift
//  Tawseel
//
//  Created by macbook on 19/03/2021.
//

import UIKit
import CoreLocation
struct InvoiceInfo {
    var driverName:String
    var deliveryAmount:String
    var invoiceNumber:String
    var fromLocation:String
    var toLocation:String
    var fromLatLong:CLLocationCoordinate2D?
    var toLatLong:CLLocationCoordinate2D?
    var currentLatLong:CLLocationCoordinate2D?
}
