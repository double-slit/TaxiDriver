//
//  RegisterVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class RegisterVC: UIViewController,UITextFieldDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var TF_Full_Name: UITextField!
    @IBOutlet weak var TF_Email_Address: UITextField!
    @IBOutlet weak var TF_Phone_Number: UITextField!
    @IBOutlet weak var TF_Password: UITextField!
    @IBOutlet weak var TF_Confirm_Password: UITextField!
    @IBOutlet weak var imgView_Profile_Pic: UIImageView!
    @IBOutlet weak var TF_Vehicle_Type: UITextField!
    @IBOutlet weak var TF_Vehicle_Plate_Number: UITextField!
    
    @IBOutlet weak var scrollViewObj: UIScrollView!
    
    //MARK:- Variables
    
    var btn_Next = UIButton()
    var imagePicker = UIImagePickerController()
    var files:[String:Data] = [String:Data]()
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
        imagePicker.delegate = self
        btn_Next.setImage(UIImage(named: "btnGo"), for: .normal)
        let widthHeight = TF_Confirm_Password.bounds.height
        btn_Next.frame = CGRect(x: TF_Confirm_Password.bounds.width - widthHeight, y: widthHeight, width: widthHeight, height: widthHeight)
        btn_Next.addTarget(self, action: #selector(LoginVC.Action_Next(sender:)), for: .touchUpInside)
        TF_Confirm_Password.rightView = btn_Next
        TF_Confirm_Password.rightViewMode = .always
    }
    
    func willAppearTasks() {
        NotificationCenter.default.addObserver(self, selector:#selector(RegisterVC.shiftScroll(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.resetScroll), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- Keyboard Setup Methods
    
    @objc func shiftScroll(_ notification:Foundation.Notification)
    {
        let infoDict = notification.userInfo
        let kbSize : CGSize = ((infoDict![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size)
        let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height + 20, 0)
        scrollViewObj.contentInset = contentInsets
        scrollViewObj.scrollIndicatorInsets = contentInsets
        if let currentTextField = activeField {
            let difference = UIScreen.main.bounds.height - kbSize.height
            if currentTextField.frame.maxY > difference
            {
                scrollViewObj.scrollRectToVisible(currentTextField.frame, animated: true)
            }
        }
    }
    
    
    @objc func resetScroll()
    {
        scrollViewObj.contentInset = UIEdgeInsets.zero
        scrollViewObj.scrollIndicatorInsets = UIEdgeInsets.zero
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
    
    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        activeField = textField
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TF_Full_Name
        {
            TF_Email_Address.becomeFirstResponder()
        }
        else if textField == TF_Email_Address
        {
            TF_Phone_Number.becomeFirstResponder()
        }
        else if textField == TF_Phone_Number
        {
            TF_Vehicle_Type.becomeFirstResponder()
        }
        else if textField == TF_Vehicle_Type
        {
            TF_Vehicle_Plate_Number.becomeFirstResponder()
        }
        else if textField == TF_Vehicle_Plate_Number
        {
            TF_Password.becomeFirstResponder()
        }
        else if textField == TF_Password
        {
            TF_Confirm_Password.becomeFirstResponder()
        }
        else if textField == TF_Confirm_Password
        {
            TF_Confirm_Password.resignFirstResponder()
        }
        return true
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Add_Pic(_ sender: UIButton) {
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
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    //MARK:- Target Actions
    
    @objc func Action_Next(sender:UIButton) {
        
        view.endEditing(true)
        let name = TF_Full_Name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = TF_Email_Address.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phno = TF_Phone_Number.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vehicleType = TF_Vehicle_Type.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let vehiclePlateNo = TF_Vehicle_Plate_Number.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = TF_Password.text!
        let confirmPassword = TF_Confirm_Password.text!
        let check = User.validateSignUp(withName: name, withEmail: email, withPhoneNumber: phno, withVehicleType: vehicleType, withPlateNo: vehiclePlateNo, withPassword: password, withConfirmPassword: confirmPassword)
        if check == "Validated" {
            
            if imgView_Profile_Pic.image != UIImage(named: "placeholder")
            {
                let data = UIImageJPEGRepresentation(imgView_Profile_Pic.image!, 0.5)
                files["driver_pic"] = data
                let dict = ["full_name":name,"driver_email":email,"driver_password":password,"driver_phoneNumber":phno,"driver_vehicleType":vehicleType,"driver_plateNo":vehiclePlateNo,"driver_latitude":"0","driver_longitude":"0"]
                performSegue(withIdentifier: Constants.ShowUploadDocumentsVC, sender: dict)
            }
            else {
                UtilityClass.showAlert(withMessage:"Please enter your profile pic", onViewController: self)
            }
        }
        else {
            UtilityClass.showAlert(withMessage:check, onViewController: self)
        }
    }
    
    //MARK:- Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UploadDocumentsVC {
            vc.params = sender as! [String:String]
            vc.files = files
        }
    }
}

//MARK: - UIImagePickerControllerDelegate Methods

extension RegisterVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgView_Profile_Pic.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}
