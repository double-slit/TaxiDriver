//
//  OTPVerificationVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class OTPVerificationVC: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets

    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    
    //MARK:- Variables
    
    var otp:String = ""
    
    //MARK:- Variables Recieved
    
    var params:[String:String]!
    var files:[String:Data] = [String:Data]()
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func validate_Otp() -> Bool {
        let first_Digit = TF1.text!
        let second_Digit = TF2.text!
        let third_Digit = TF3.text!
        let fourth_Digit = TF4.text!
        guard first_Digit != "" else { return false }
        guard second_Digit != "" else { return false }
        guard third_Digit != "" else { return false }
        guard fourth_Digit != "" else { return false }
        otp = "\(first_Digit)\(second_Digit)\(third_Digit)\(fourth_Digit)"
        return true
    }
    
    //MARK:- Touches Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- Textfield delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text!.characters.count >= 1  && string.characters.count == 0){
            // on deleting value from Textfield
            let previousTag = textField.tag - 1;
            
            // get next responder
            if let previousResponder = textField.superview?.viewWithTag(previousTag) {
                textField.text = ""
                previousResponder.becomeFirstResponder();
                return false
            }
        }
        else {
            let nextTag = textField.tag + 1;
            // get next responder
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                textField.text = "\(string.characters.last!)"
                nextResponder.becomeFirstResponder()
                return false
            }
            else {
                textField.text = "\(string.characters.last!)"
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        view.endEditing(true)
        if validate_Otp() {
            UtilityClass.showLoader(withMessage: nil)
            let url = "\(UrlConstants.BaseUrl)\(UrlConstants.Register)"
            User.postUserWithImage(withUrl: url, withParameters: params! as [String : AnyObject], withFiles: files, success: { (userObj) in
                UtilityClass.hideLoader()
                Constants.userObj = userObj
                UtilityClass.encodeObject(objectName: userObj, keyName: Constants.sharedInstance.UserData)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.update(withDeviceToken: UserDefaults.standard.string(forKey: Constants.DeviceToken)!, withDriverId: Constants.userObj.user_id!)
                
                weak var selfVar = self
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
                    let homeScreen = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC")
                    selfVar!.navigationController?.pushViewController(homeScreen, animated: true)
                }
                
            }, failure: { (error) in
                UtilityClass.hideLoader()
                UtilityClass.showAlert(withMessage: error, onViewController: self)
            })
        }
        else {
            UtilityClass.showAlert(withMessage: "Please enter a correct OTP to continue.", onViewController: self)
        }
    }
}
