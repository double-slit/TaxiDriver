//
//  ForgotPasswordVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {

    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Touches Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- Textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
}
