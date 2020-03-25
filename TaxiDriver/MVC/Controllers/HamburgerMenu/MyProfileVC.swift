//
//  MyProfileVC.swift
//  FastboxDriver
//
//  Created by Apple on 05/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage

class MyProfileVC: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var TF_Name: UITextField!
    @IBOutlet weak var TF_Email: UITextField!
    @IBOutlet weak var TF_Phone_No: UITextField!
    @IBOutlet weak var imgView_Profile_Pic: UIImageView!
    
    //MARK:- Variables
    
    var imagePicker = UIImagePickerController()
    var picChanged:Bool = false
    
    //MARK:- Lifecycle Methods
    
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
        imagePicker.delegate = self
        let userObj = Constants.userObj!
        TF_Name.text = userObj.user_name
        TF_Email.text = userObj.user_email_id
        TF_Phone_No.text = "+91-\(userObj.user_phone_no)"
        if Constants.userObj.user_pic != "" {
            let url = URL(string: "\(UrlConstants.ImageUrl)\(userObj.user_pic)")
            imgView_Profile_Pic.sd_setImage(with: url, placeholderImage: Constants.ProfilePlaceholder, options: .highPriority, completed: nil)
        }
    }
    
    func willAppearTasks() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(MyProfileVC.shiftScroll(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyProfileVC.resetScroll), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        if TF_Name.frame.maxY + TF_Name.bounds.height > difference
        {
            UIView.animate(withDuration: 0.2, animations: {
                selfVar!.view.frame.origin.y -= (selfVar!.TF_Name.frame.maxY + selfVar!.TF_Name.bounds.height - difference)
            })
        }
    }
    
    @objc func resetScroll() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    //MARK:- Camera Setup Methods
    
    func cameraSelected()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                weak var selfVar = self
                if let _ = UtilityClass.checkAuthorizationStatusForCamera() {
                    DispatchQueue.main.async {
                        selfVar!.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                        selfVar!.imagePicker.cameraCaptureMode = .photo
                        selfVar!.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
                else {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                        
                        if(granted)
                        {
                            DispatchQueue.main.async {
                                selfVar!.imagePicker.sourceType = .camera
                                selfVar!.imagePicker.cameraCaptureMode = .photo
                                selfVar!.present(self.imagePicker, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
            else
            {
                UtilityClass.showAlert(withMessage: "Rear Camera is not available in the device", onViewController: self)
            }
        }
        else
        {
            UtilityClass.showAlert(withMessage:"Camera is currently not available in the device", onViewController: self)
        }
    }
    
    
    func gallerySelected()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            self.imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            UtilityClass.showAlert(withMessage:"Photo library is not currently available on this device", onViewController: self)
        }
    }

    //MARK:- TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    //MARK:- Button Actions
    
    
    @IBAction func Action_Change_Pic(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose Option", message: "Select Pic from:", preferredStyle: .actionSheet)
        weak var selfVar = self
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            selfVar!.cameraSelected()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (alertAction) in
            selfVar!.gallerySelected()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func Action_Save_Changes(_ sender: UIButton) {
        let userObj = Constants.userObj!
        let name = TF_Name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if name == "" {
            UtilityClass.showAlert(withMessage: "Please enter a valid name to save changes.", onViewController: self)
        }
        else if !picChanged && userObj.user_name == name {
           NotificationCenter.default.post(name: Notification.Name(Constants.NotiHomeMenuItemChanged), object: Side_Menu_Item.Home)
        }
        else {
            
            UtilityClass.showLoader(withMessage: nil)
            
            var params:[String:AnyObject] = [String:AnyObject]()
            var files = [String:Data]()
            if !picChanged {
              params = ["driverId":userObj.user_id!,"driver_pic":userObj.user_pic,"full_name":name,"driver_latitude":"0","driver_longitude":"0"] as [String:AnyObject]
            }
            else {
                params = ["driverId":userObj.user_id!,"full_name":name,"driver_latitude":"0","driver_longitude":"0"] as [String:AnyObject]
                let imageData = UIImageJPEGRepresentation(imgView_Profile_Pic.image!, 0.5)
                files = ["driver_pic":imageData!]
            }
            let url = "\(UrlConstants.BaseUrl)\(UrlConstants.EditProfile)"
            User.putUserWithImage(withUrl: url, withParameters: params, withFiles: files, success: { (userObj) in
                
                
                Constants.userObj = userObj
                UtilityClass.encodeObject(objectName: userObj, keyName: Constants.sharedInstance.UserData)
                
                DispatchQueue.main.async {
               
                    UtilityClass.hideLoader()
                    UtilityClass.showAlert(withMessage: "Changes Saved.", onViewController: self)
                }
            }, failure: { (error) in
                UtilityClass.hideLoader()
                UtilityClass.showAlert(withMessage: error, onViewController: self)
            })
        }
    }
}


//MARK: - UIImagePickerControllerDelegate Methods

extension MyProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            picChanged = true
            imgView_Profile_Pic.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

