//
//  Enums.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

enum ServerStatus {
    case Success
    case NotFound
    case ServerError
    case InternetConnectionError
    case Other
}

enum Side_Menu_Item:Int {
    case Home
    case My_Bookings
    case My_Profile
    case Change_Password
    case Help
    case Logout
    
    var string:String {
        switch self {
        case .Home: return "Home"
        case .My_Bookings: return "My Bookings"
        case .My_Profile: return "My Profile"
        case .Change_Password: return "Change Password"
        case .Help: return "Help"
        case .Logout: return "Logout"
        }
    }
    
    static var count:Int {
        return Side_Menu_Item.Logout.hashValue + 1
    }
}
