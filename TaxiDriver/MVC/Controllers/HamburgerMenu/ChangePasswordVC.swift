//
//  ChangePasswordVC.swift
//  FastboxDriver
//
//  Created by Apple on 05/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var TF_Old_Password: UITextField!
    @IBOutlet weak var TF_New_Password: UITextField!
    @IBOutlet weak var TF_Confirm_Password: UITextField!
    
    //MARK:- Variables
    
    @IBOutlet var activeField:UITextField!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK:- View Lifecycle Methods
    
    func willAppearTasks() {
        NotificationCenter.default.addObserver(self, selector:#selector(ChangePasswordVC.shiftScroll(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordVC.resetScroll), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        weak var selfVar = self
        UIView.animate(withDuration: 0.2, animations: {
            selfVar!.view.frame.origin.y = 0
        })
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func Action_Change_Password(_ sender: UIButton) {
        let oldPassword = TF_Old_Password.text!
        let newPassword = TF_New_Password.text!
        let confirmPassword = TF_Confirm_Password.text!
        if newPassword != confirmPassword {
            UtilityClass.showAlert(withMessage: "Please confirm you correct password.", onViewController: self)
        }
        else {
            
        }
    }
    
    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        activeField = textField
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TF_Old_Password
        {
            TF_New_Password.becomeFirstResponder()
        }
        else if textField == TF_New_Password
        {
            TF_Confirm_Password.becomeFirstResponder()
        }
        else if textField == TF_Confirm_Password
        {
            TF_Confirm_Password.resignFirstResponder()
        }
        return true
    }
}
