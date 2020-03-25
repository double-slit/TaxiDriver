//
//  BookingModel.swift
//  FastboxDriver
//
//  Created by Apple on 21/01/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class BookingModel: NSObject {
    //MARK:- Variables
    
    var bookingId:Int!
    var bookingAmount:String = ""
    var bookingItemName:String = ""
    var bookingItemType:String = ""
    var bookingDate:String = ""
    var bookingPickUpLocation:String = ""
    
    //MARK:- Parse Methods
    
    func parsePush(withDict dict:[String:Any]) -> BookingModel {
        let pushObj = BookingModel()
        if let booking_id = dict["bookingId"] as? Int {
            pushObj.bookingId = booking_id
        }
        if let amount = dict["amount"] as? String {
            pushObj.bookingAmount = amount
        }
        if let itemName = dict["itemName"] as? String {
            pushObj.bookingItemName = itemName
        }
        if let itemType = dict["itemType"] as? String {
            pushObj.bookingItemType = itemType
        }
        if let date = dict["date"] as? String {
            pushObj.bookingDate = date
        }
        if let pickUpLocation = dict["pickUpLocation"] as? String {
            pushObj.bookingPickUpLocation = pickUpLocation
        }
        return pushObj
    }
}
