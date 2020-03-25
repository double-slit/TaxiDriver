//
//  HomeScreenVC.swift
//  OntarioCustomer
//
//  Created by Shivani Bajaj on 24/09/17.
//  Copyright © 2017 Shivani Bajaj. All rights reserved.
//

import UIKit
import CoreLocation

class HomeScreenVC: UIViewController {

    //MARK:- Outlets
   
    @IBOutlet weak var containerView_Obj: UIView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Logout: UIView!
    
    //MARK:- Variables
    
    var locationManager:CLLocationManager!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        change_Container_Content(withOption: Constants.SideMenuItemSelected)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeScreenVC.change_Container_Content(notiObj:)), name: Notification.Name(Constants.NotiHomeMenuItemChanged), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func change_Container_Content(withOption option:Side_Menu_Item) {
        if Constants.previousControllerInContainer != nil && option != Side_Menu_Item.Logout {
            remove(asChildViewController: Constants.previousControllerInContainer)
        }
        switch(option) {
        case .Home:
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let bookRequestScreen = storyBoard.instantiateViewController(withIdentifier: "HomeBookingRequestVC")
            add(asChildViewController: bookRequestScreen)
            lbl_Heading.text = Side_Menu_Item.Home.string
            Constants.previousControllerInContainer = bookRequestScreen
        case .My_Bookings:
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let myBookingsVC = storyBoard.instantiateViewController(withIdentifier: "MyBookingsVC")
            add(asChildViewController: myBookingsVC)
            Constants.previousControllerInContainer = myBookingsVC
            lbl_Heading.text = Side_Menu_Item.My_Bookings.string
        case .My_Profile:
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let myProfileVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileVC")
            add(asChildViewController: myProfileVC)
            Constants.previousControllerInContainer = myProfileVC
            lbl_Heading.text = Side_Menu_Item.My_Profile.string
        case .Change_Password:
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let changePasswordVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC")
            add(asChildViewController: changePasswordVC)
            Constants.previousControllerInContainer = changePasswordVC
            lbl_Heading.text = Side_Menu_Item.Change_Password.string
        case .Help:
            let storyBoard = UIStoryboard.init(name: "HamburgerMenu", bundle: nil)
            let bookRequestScreen = storyBoard.instantiateViewController(withIdentifier: "HomeBookingRequestVC")
            add(asChildViewController: bookRequestScreen)
            lbl_Heading.text = Side_Menu_Item.Home.string
            Constants.previousControllerInContainer = bookRequestScreen
        case .Logout:
            add(asChildViewController: Constants.previousControllerInContainer)
            view_Logout.isHidden = false
            view_Background.isHidden = false
        }
    }
    
    
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateLocation() {
        let url = "\(UrlConstants.BaseUrl)\(UrlConstants.UpdateLatLong)"
        let params:[String:Any] = ["driverId":Constants.userObj.user_id!,"driver_longitude":Constants.currentLongitude,"driver_latitude":Constants.currentLatitude]
        User.postString(withUrl: url, withParameters: params, withHeader: UrlConstants.Header, success: { (msg) in
            print(msg)
        }) { (error) in
            print(error)
        }
    }
    
    
    //MARK:- Notification Methods
    
    @objc func change_Container_Content(notiObj:Notification) {
        let item = notiObj.object as! Side_Menu_Item
        change_Container_Content(withOption: item)
    }
    
    
    //MARK:- Switch Methods
    
    @IBAction func actionChangeAvailableState(_ sender: UISwitch) {
        
        let url = "\(UrlConstants.BaseUrl)\(UrlConstants.UpdateAvailableStatus)"
        let status = (sender.isOn) ? "1" : "0"
        let params = ["driverId":Constants.userObj.user_id!,"status":status] as [String : Any]
        User.postString(withUrl: url, withParameters: params as [String : AnyObject], withHeader: UrlConstants.Header, success: { (msg) in
            print("Status Updated")
        }) { (error) in
            print("Error in updating status")
        }
    }
    
    //MARK:- Button Actions
    
    
    @IBAction func Action_Open_Side_Menu(_ sender: UIButton) {
        performSegue(withIdentifier:Constants.PresentModallyHamburgerMenu, sender: nil)
    }
    
    
    @IBAction func Action_Logout(_ sender: UIButton) {
        if sender.titleLabel!.text! == "Yes" {
       
            Constants.SideMenuItemSelected = .Home
            Constants.previousControllerInContainer = nil
            if UserDefaults.standard.object(forKey: Constants.sharedInstance.UserData) != nil {
                UserDefaults.standard.removeObject(forKey: Constants.sharedInstance.UserData)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            view_Logout.isHidden = true
            view_Background.isHidden = true
        }
    }
    
    //MARK:- Container Setup Methods
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView_Obj.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView_Obj.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    } 

    //MARK:- Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? HamburgerMenuVC {
            destinationVC.transitioningDelegate = self
        }
    }
}

extension HomeScreenVC:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
}


extension HomeScreenVC:CLLocationManagerDelegate {
    
    //MARK:- Location Manager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        Constants.currentLatitude = userLocation.coordinate.latitude
        Constants.currentLongitude = userLocation.coordinate.longitude
        updateLocation()
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get the location")
    }
}
