//
//  MyBookingsVC.swift
//  FastboxDriver
//
//  Created by Apple on 20/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MyBookingsVC: UIViewController {

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
        let cellNib = UINib(nibName: Constants.BookingsCell, bundle: nil)
        tblViewObj.register(cellNib, forCellReuseIdentifier: Constants.BookingsCell)
    }
}


extension MyBookingsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.BookingsCell) as! BookingsCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

