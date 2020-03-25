//
//  HomeBookingRequestVC.swift
//  FastboxDriver
//
//  Created by Apple on 20/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class HomeBookingRequestVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var tblViewObj: UITableView!
    
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
        let cellNib = UINib(nibName: Constants.BookingRequestCell, bundle: nil)
        tblViewObj.register(cellNib, forCellReuseIdentifier: Constants.BookingRequestCell)
    }
    
    //MARK:- Target Actions
    
    @objc func show_Request_Details(sender:UIButton) {
        performSegue(withIdentifier: Constants.ShowBookingRequestDetailVC, sender: nil)
    }
}

extension HomeBookingRequestVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.BookingRequestCell) as! BookingRequestCell
        cell.btn_Details.addTarget(self, action: #selector(HomeBookingRequestVC.show_Request_Details(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
