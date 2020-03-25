//
//  MapVC.swift
//  FastboxDriver
//
//  Created by Apple on 27/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MapVC: UIViewController {
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Confirm_Pickup(_ sender: UIButton) {
//        let confirmationView = ConfirmationView(frame: self.view.bounds, withMessage: "Are you sure you have arrived at pickup?", withLeftOption: "Yes", withRightOption: "No")
//        self.view.addSubview(confirmationView)
        
        performSegue(withIdentifier: Constants.ShowSignatureVC, sender: nil)
    }
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
