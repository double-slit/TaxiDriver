//
//  Constants.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let sharedInstance = Constants()
    
    //MARK:- Globals
    
    static var SideMenuItemSelected:Side_Menu_Item = .Home
    static var previousControllerInContainer:UIViewController!
    static var userObj:User!
    static let ProfilePlaceholder = UIImage(named: "placeholder")!
    static var currentLatitude:Double = 0.0
    static var currentLongitude:Double = 0.0
    
    //MARK:- Keys
    
    static var GoogleMapsApiKey = "AIzaSyBP6k6RfEOwt7Bj__kybT0HGdQU8zmZqEU"
    
    //MARK:- Segues
    static let ShowLoginVC = "ShowLoginVC"
    static let ShowRegisterVC = "ShowRegisterVC"
    static let ShowUploadDocumentsVC = "ShowUploadDocumentsVC"
    static let ShowOTPVerificationVC = "ShowOTPVerificationVC"
    static let ShowForgotPasswordVC = "ShowForgotPasswordVC"
    static let PresentModallyHamburgerMenu = "PresentModallyHamburgerMenu"
    static let ShowBookingRequestDetailVC = "ShowBookingRequestDetailVC"
    static let ShowBookingStatusVC = "ShowBookingStatusVC"
    static let ShowMapVC = "ShowMapVC"
    static let ShowSignatureVC = "ShowSignatureVC"
    
    //MARK:- Notifications
    
    static let NotiHomeMenuItemChanged = "NotiHomeMenuItemChanged"
    
    //MARK:- TableView Cells
    
    static let HamburgerMenuTVC = "HamburgerMenuTVC"
    static let BookingRequestCell = "BookingRequestCell"
    static let BookingsCell = "BookingsCell"
    
    //MARK:- User Defaults
    
    let UserData = "UserData"
    static let DeviceToken = "DeviceToken"
}
