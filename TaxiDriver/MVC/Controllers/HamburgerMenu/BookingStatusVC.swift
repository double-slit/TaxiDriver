//
//  BookingStatusVC.swift
//  FastboxDriver
//
//  Created by Apple on 27/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BookingStatusVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var view_Item_Quantity: UIView!
    @IBOutlet weak var view_Item_Info: UIView!
    @IBOutlet weak var view_Pickup_Info: UIView!
    @IBOutlet weak var view_Slide: UIView!
    
    //MARK:- Variables
    
    var swipeRightGesture:UISwipeGestureRecognizer!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(BookingStatusVC.Action_Swipe(recogizer:)))
        swipeRightGesture.direction = .right
        view_Slide.addGestureRecognizer(swipeRightGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeRightGesture = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func didLoadTasks() {
        view_Item_Quantity.layer.borderColor = UIColor.lightGray.cgColor
        view_Item_Info.layer.borderColor = UIColor.lightGray.cgColor
        view_Pickup_Info.layer.borderColor = UIColor.lightGray.cgColor
        view_Slide.layer.cornerRadius = view_Slide.bounds.height / 2
    }
    
    //MARK:- Gesture Recognizer Methods
    
    @objc func Action_Swipe(recogizer:UIGestureRecognizer) {
        performSegue(withIdentifier: Constants.ShowMapVC, sender: nil)
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Back(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
    }
}
