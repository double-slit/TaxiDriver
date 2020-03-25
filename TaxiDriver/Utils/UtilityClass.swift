//
//  UtilityClass.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import MKSpinner

class UtilityClass {
    //MARK:- User defaults Methods
    
    internal class func encodeObject(objectName object:AnyObject,keyName:String)
    {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(encodedObject, forKey: keyName)
        UserDefaults.standard.synchronize()
    }
    
    internal class func decodeObject(_ keyName:String) -> AnyObject
    {
        let decodedObject = UserDefaults.standard.object(forKey: keyName) as! Data
        let object:AnyObject = NSKeyedUnarchiver.unarchiveObject(with: decodedObject)! as AnyObject
        return object
    }
    
    //MARK:- AlertController
    
    internal class func showAlert(withMessage msg:String,onViewController controller:UIViewController)
    {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
    internal class func showLoader(withMessage message:String?) {
        let messageToShow = message ?? "Loading"
        MKFullSpinner.show(messageToShow)
    }
    
    internal class func hideLoader() {
        MKFullSpinner.hide()
    }
    
    static func isInternetAvailable() -> Bool {
        let status = Reach().connectionStatus()
        switch status {
        case .offline,.unknown:
            return true
        default:
            return false
        }
    }
    
    //MARK:- Camera Setup Methods
    
    internal class func checkAuthorizationStatusForCamera() -> Bool?
    {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if(authStatus == AVAuthorizationStatus.authorized) {
            return true
        }
        else if(authStatus == AVAuthorizationStatus.denied) {
            return false
        }
        else if(authStatus == AVAuthorizationStatus.restricted) {
            return false
        }
        else {
            return nil
        }
    }
}
