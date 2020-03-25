//
//  UploadDocumentsVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class UploadDocumentsVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var view_Upload_Documents: UIView!
    @IBOutlet weak var view_Driver_Front_License: UIView!
    @IBOutlet weak var view_Driver_Back_License: UIView!
    @IBOutlet weak var lbl_Cover_Note: UILabel!
    @IBOutlet weak var lbl_Driver_Front_License: UILabel!
    @IBOutlet weak var lbl_Driver_Back_License: UILabel!
    
    //MARK:- Variables Recieved
    
    var params:[String:String]!
    var files:[String:Data] = [String:Data]()
    
    //MARK:- Variables
    
    var imagePicker = UIImagePickerController()
    var currentFileOption:File_Option = .Cover
    
    enum File_Option {
        case Cover
        case License_Front
        case License_Back
    }
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func didLoadTasks() {
        imagePicker.delegate = self
    }
    
    func open_Action_Sheet() {
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
    
    //MARK:- Button Actions
    
    
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Action_Submit_Documents(_ sender: UIButton) {
        
        if let _ = files["coverNote"],let _ = files["licenseFront"],let _ = files["licenseBack"] {
            performSegue(withIdentifier: Constants.ShowOTPVerificationVC, sender: nil)
        }
        else {
            UtilityClass.showAlert(withMessage: "Please upload the required documents.", onViewController: self)
        }
    }
    
    
    @IBAction func Action_Add_Cover_File(_ sender: UIButton) {
        currentFileOption = .Cover
        open_Action_Sheet()
    }
    
    
    @IBAction func Action_Add_Driver_License_Front(_ sender: UIButton) {
        currentFileOption = .License_Front
        open_Action_Sheet()
    }
    
    
    @IBAction func Action_Driver_License_Back(_ sender: UIButton) {
        currentFileOption = .License_Back
        open_Action_Sheet()
    }
    
    //MARK:- Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OTPVerificationVC {
            vc.params = params
            vc.files = files
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate Methods

extension UploadDocumentsVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let data = UIImageJPEGRepresentation(pickedImage, 0.5)
            switch currentFileOption {
              case .Cover:
                files["coverNote"] = data
                lbl_Cover_Note.text = "Cover_Note.jpg"
              case .License_Front:
                files["licenseFront"] = data
                lbl_Driver_Front_License.text = "Driver_License_Front.jpg"
              case .License_Back:
                files["licenseBack"] = data
                lbl_Driver_Back_License.text = "Driver_License_Back.jpg"
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

