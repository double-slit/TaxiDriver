//
//  BookingRequestDetailVC.swift
//  FastboxDriver
//
//  Created by Apple on 20/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BookingRequestDetailVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var view_Item_Quantity: UIView!
    @IBOutlet weak var view_Item_Info: UIView!
    @IBOutlet weak var view_Pickup_Info: UIView!
    @IBOutlet weak var view_Delivery_Info: UIView!
    @IBOutlet weak var view_Price: UIView!
    
    //MARK:- Variables
    
    var bookingObj:BookingModel!
    
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
        view_Item_Quantity.layer.borderColor = UIColor.lightGray.cgColor
        view_Item_Info.layer.borderColor = UIColor.lightGray.cgColor
        view_Pickup_Info.layer.borderColor = UIColor.lightGray.cgColor
        view_Delivery_Info.layer.borderColor = UIColor.lightGray.cgColor
        view_Price.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func Action_Accept(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: Constants.ShowBookingStatusVC, sender: nil)
    }
    
    
    @IBAction func Action_Reject(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
}
