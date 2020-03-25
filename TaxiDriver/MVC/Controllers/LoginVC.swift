//
//  LoginVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var TF_Email_Address: UITextField!
    @IBOutlet weak var TF_Password: UITextField!
    @IBOutlet weak var lbl_Register: UILabel!
    
    //MARK:- Variables
    
    var btn_Next = UIButton()
    @IBOutlet var activeField:UITextField!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearTasks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func didLoadTasks() {
        btn_Next.setImage(UIImage(named: "btnGo"), for: .normal)
        let widthHeight = TF_Password.bounds.height
        btn_Next.frame = CGRect(x: TF_Password.bounds.width - widthHeight, y: widthHeight, width: widthHeight, height: widthHeight)
        btn_Next.addTarget(self, action: #selector(LoginVC.Action_Next(sender:)), for: .touchUpInside)
        TF_Password.rightView = btn_Next
        TF_Password.rightViewMode = .always
    }
    
    func willAppearTasks() {
        NotificationCenter.default.addObserver(self, selector:#selector(LoginVC.shiftScroll(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.resetScroll), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- Touches Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Keyboard Setup Methods
    
    @objc func shiftScroll(_ notification:Foundation.Notification) {
        let infoDict = notification.userInfo
        let kbSize : CGSize = ((infoDict![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size)
        let difference = UIScreen.main.bounds.height - kbSize.height
        weak var selfVar = self
        if activeField.frame.maxY + activeField.bounds.height > difference
        {
            UIView.animate(withDuration: 0.2, animations: {
                selfVar!.view.frame.origin.y -= (selfVar!.activeField.frame.maxY + self.activeField.bounds.height - difference)
            })
        }
    }
    
    @objc func resetScroll() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
    }

    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TF_Email_Address
        {
            TF_Password.becomeFirstResponder()
        }
        else if textField == TF_Password
        {
            TF_Password.resignFirstResponder()
        }
        activeField = textField
        return true
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Forgot_Password(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.ShowForgotPasswordVC, sender: nil)
    }
    
    
    @IBAction func Action_Register(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.ShowRegisterVC, sender: nil)
    }
    
    //MARK:- Target Actions
    
    @objc func Action_Next(sender:UIButton) {
        
        view.endEditing(true)
        let email = TF_Email_Address.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = TF_Password.text!
        let check = User.validateLogin(withEmail: email)
        if check == "Validated" {
            UtilityClass.showLoader(withMessage: nil)
            let params = ["driver_email":email,"driver_password":password]
            let url = "\(UrlConstants.BaseUrl)\(UrlConstants.Login)"
            User.postUser(withUrl: url, withParameters: params as [String : AnyObject], withHeader: UrlConstants.Header, success: { (userObj) in
                
                UtilityClass.hideLoader()
                Constants.userObj = userObj
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.update(withDeviceToken: UserDefaults.standard.string(forKey: Constants.DeviceToken)!, withDriverId: Constants.userObj.user_id!)
                UtilityClass.encodeObject(objectName: userObj, keyName: Constants.sharedInstance.UserData)
                weak var selfVar = self
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
                    let homeScreen = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC")
                    selfVar!.navigationController?.pushViewController(homeScreen, animated: true)
                }
                
            }, failure: { (error) in
                UtilityClass.hideLoader()
                UtilityClass.showAlert(withMessage:error, onViewController: self)
            })
        }
        else {
            UtilityClass.showAlert(withMessage:check, onViewController: self)
        }
    }
}
