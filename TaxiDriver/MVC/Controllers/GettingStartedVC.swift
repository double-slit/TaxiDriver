//
//  GettingStartedVC.swift
//  FastboxDriver
//
//  Created by Apple on 19/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class GettingStartedVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var btn_Get_Started: UIButton!
    
    //MARK:- Variables
    
    var swipeGesture:UISwipeGestureRecognizer!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: Constants.sharedInstance.UserData) != nil {
            Constants.userObj = UtilityClass.decodeObject(Constants.sharedInstance.UserData) as! User
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let homeScreen = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC")
            navigationController?.pushViewController(homeScreen, animated: false)
        }
        btn_Get_Started.semanticContentAttribute = .forceRightToLeft
        btn_Get_Started.addTarget(self, action: #selector(GettingStartedVC.actionGetStarted(sender:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Target Actions
    
    @objc func actionGetStarted(sender:UIButton) {
        performSegue(withIdentifier: Constants.ShowLoginVC, sender: nil)
    }
}
