//
//  User.swift
//  FastboxDriver
//
//  Created by Apple on 01/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import Reachability

class User: NSObject,NSCoding {
    
    var user_id:Int!
    var user_name:String = ""
    var user_email_id:String = ""
    var user_pic:String = ""
    var user_lat:String = ""
    var user_long:String = ""
    var user_phone_no:String = ""
    var user_vehicle_type:String = ""
    var user_plate_no:String = ""
    var user_cover_note:String = ""
    var user_license_front:String = ""
    var user_license_back:String = ""
    var user_device_token:String = ""
    var user_otp:String = ""
    var user_device_type:Int!
    
    //MARK: - NSCoding Methods
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let userId = aDecoder.decodeObject(forKey: "user_id") as? Int {
            self.user_id = userId
        }
        if let userName = aDecoder.decodeObject(forKey: "user_name") as? String {
            self.user_name = userName
        }
        if let userEmail = aDecoder.decodeObject(forKey: "user_email_id") as? String {
            self.user_email_id = userEmail
        }
        if let user_pic = aDecoder.decodeObject(forKey: "user_pic") as? String {
            self.user_pic = user_pic
        }
        if let userLat = aDecoder.decodeObject(forKey: "user_lat") as? String {
            self.user_lat = userLat
        }
        if let userLong = aDecoder.decodeObject(forKey: "user_long") as? String {
            self.user_long = userLong
        }
        if let userPhoneNo = aDecoder.decodeObject(forKey: "user_phone_no") as? String {
            self.user_phone_no = userPhoneNo
        }
        if let user_vehicle_type = aDecoder.decodeObject(forKey: "user_vehicle_type") as? String {
            self.user_vehicle_type = user_vehicle_type
        }
        if let user_plate_no = aDecoder.decodeObject(forKey: "user_plate_no") as? String {
            self.user_plate_no = user_plate_no
        }
        if let user_cover_note = aDecoder.decodeObject(forKey: "user_cover_note") as? String {
            self.user_cover_note = user_cover_note
        }
        if let user_license_front = aDecoder.decodeObject(forKey: "user_license_front") as? String {
            self.user_license_front = user_license_front
        }
        if let user_license_back = aDecoder.decodeObject(forKey: "user_license_back") as? String {
            self.user_license_back = user_license_back
        }
        
        if let userDeviceToken = aDecoder.decodeObject(forKey: "user_device_token") as? String {
            self.user_device_token = userDeviceToken
        }
        if let userCode = aDecoder.decodeObject(forKey: "user_confirmation_code") as? String {
            self.user_otp = userCode
        }
        if let userDeviceType = aDecoder.decodeObject(forKey: "user_device_type") as? Int {
            self.user_device_type = userDeviceType
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
       
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(user_email_id, forKey: "user_email_id")
        aCoder.encode(user_pic, forKey: "user_pic")
        aCoder.encode(user_lat, forKey: "user_lat")
        aCoder.encode(user_long, forKey: "user_long")
        aCoder.encode(user_phone_no, forKey: "user_phone_no")
        aCoder.encode(user_vehicle_type, forKey: "user_vehicle_type")
        aCoder.encode(user_plate_no, forKey: "user_plate_no")
        aCoder.encode(user_cover_note, forKey: "user_cover_note")
        aCoder.encode(user_license_front, forKey: "user_license_front")
        aCoder.encode(user_license_back, forKey: "user_license_back")
        aCoder.encode(user_phone_no, forKey: "user_phone_no")
        aCoder.encode(user_device_token, forKey: "user_device_token")
        aCoder.encode(user_otp, forKey: "user_otp")
        aCoder.encode(user_device_type, forKey: "user_device_type")
    }
    
    //MARK:- API Methods
    
    class func postUser(withUrl url:String,withParameters params:[String:Any],withHeader header:String,success:@escaping (User) -> (),failure:@escaping (String) -> ()) {
        
        NSURLSessionAPI.postJSON(withURL: url, withParameters: params,withHeader:header,success: { (response) in
            
            if response["success"] as! Int == 1{
                let userObj = User.parseUser(response["data"] as! [String:AnyObject])
                success(userObj)
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    
    class func putUser(withUrl url:String,withParameters params:[String:Any],withHeader header:String,success:@escaping (User) -> (),failure:@escaping (String) -> ()) {
        
        NSURLSessionAPI.putJSON(withURL: url, withParameters: params,success: { (response) in
            
            if response["success"] as! Int == 1{
                let userObj = User.parseUser(response["data"] as! [String:AnyObject])
                success(userObj)
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    
    class func postUserWithImage(withUrl url:String,withParameters params:[String:Any],withFiles files:[String:Data],success:@escaping (User) -> (),failure:@escaping (String) -> ()) {
        
        NSURLSessionAPI.postWithImage(withUrl: url, withParameters: params, withFileNames: files, success: { (response) in
            
            if response["success"] as! Int == 1{
                let userObj = User.parseUser(response["data"] as! [String:AnyObject])
                success(userObj)
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    
    class func putUserWithImage(withUrl url:String,withParameters params:[String:Any],withFiles files:[String:Data],success:@escaping (User) -> (),failure:@escaping (String) -> ()) {
        
        NSURLSessionAPI.putWithImage(withUrl: url, withParameters: params, withFileNames: files, success: { (response) in
            
            if response["success"] as! Int == 1{
                let userObj = User.parseUser(response["data"] as! [String:AnyObject])
                success(userObj)
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    
    class func postString(withUrl url:String,withParameters params:[String:Any],withHeader header:String,success:@escaping (String) -> (),failure:@escaping (String) -> ()) {
        
        guard UtilityClass.isInternetAvailable() else {
            print(ErrorMessageConstants.InternetConnection)
            failure(ErrorMessageConstants.InternetConnection)
            return
        }
        
        NSURLSessionAPI.postJSON(withURL: url, withParameters: params,withHeader:header,success: { (response) in
           
            if response["success"] as! Int == 1 || response["success"] as! Int == 2 {
                if let msg = response["data"] as? String {
                    success(msg)
                }
                else {
                    success("Success")
                }
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    
    class func getString(withUrl url:String,withParameters params:[String:Any],withHeader header:String,success:@escaping (String) -> (),failure:@escaping (String) -> ()) {
        
        NSURLSessionAPI.getJSON(withUrl: url, withParameters: params, success: { (response) in
        
            if response["success"] as! Int == 1{
                if let msg = response["data"] as? String {
                    success(msg)
                }
                else {
                    success("Success")
                }
            }
            else {
                failure(response["message"] as! String)
            }
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    
    //MARK: - Parse Methods
    
    class func parseUser(_ data : [String:Any]) -> User
    {
        let userObj = User()
        if let user_id = data["driverId"] as? Int {
            userObj.user_id = user_id
        }
        if let full_name = data["driver_name"] as? String {
            userObj.user_name = full_name
        }
        if let email_address = data["driver_email"] as? String {
            userObj.user_email_id = email_address
        }
        if let profile_pic = data["driver_pic"] as? String {
            userObj.user_pic = profile_pic
        }
        if let latitude = data["driver_latitude"] as? String {
            userObj.user_lat = latitude
        }
        if let longitude = data["driver_longitude"] as? String {
            userObj.user_long = longitude
        }
        if let mobile_number = data["driver_phoneNumber"] as? String {
            userObj.user_phone_no = mobile_number
        }
        if let user_vehicle_type = data["driver_vehicleType"] as? String {
            userObj.user_vehicle_type = user_vehicle_type
        }
        if let driver_plateNo = data["driver_plateNo"] as? String {
            userObj.user_plate_no = driver_plateNo
        }
        if let driver_coverNote = data["driver_coverNote"] as? String {
            userObj.user_cover_note = driver_coverNote
        }
        if let driver_licenseFront = data["driver_licenseFront"] as? String {
            userObj.user_license_front = driver_licenseFront
        }
        if let driver_licenseBack = data["driver_licenseBack"] as? String {
            userObj.user_license_back = driver_licenseBack
        }
        if let device_token = data["device_token"] as? String {
            userObj.user_device_token = device_token
        }
        if let driver_otp = data["driver_otp"] as? String {
            userObj.user_otp = driver_otp
        }
        if let device_type = data["device_type"] as? Int {
            userObj.user_device_type = device_type
        }
        return userObj
    }
    
    //MARK: - Setup methods
    
    class func validateLogin(withEmail email:String) -> String
    {
        guard email != "" else {
            return "Please enter all fields"
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        guard result else {
              return "Invalid email"
        }
        return "Validated"
    }
    
    
    class func validateSignUp(withName username:String,withEmail email:String,withPhoneNumber phoneNo:String,withVehicleType vehicleType:String,withPlateNo plateNo:String,withPassword password:String,withConfirmPassword confirmPassword:String) -> String
    {
        guard username != "" else {
            return "Please enter all the fields."
        }
        guard email != "" else {
            return "Please enter all the fields."
        }
        guard phoneNo != "" else {
            return "Please enter all the fields."
        }
        guard vehicleType != "" else {
            return "Please enter all the fields."
        }
        guard plateNo != "" else {
            return "Please enter all the fields."
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        guard result else {
            return "Invalid email"
        }
        guard let _ = Int(phoneNo) else {
            return "Please enter a valid mobile number"
        }
        guard password == confirmPassword else {
            return "Your passwords do not match.Please confirm the correct password to proceed."
        }
        return "Validated"
    }
}

