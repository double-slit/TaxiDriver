//
//  HamburgerMenuVC.swift
//  OntarioCustomer
//
//  Created by Shivani Bajaj on 24/09/17.
//  Copyright © 2017 Shivani Bajaj. All rights reserved.
//

import UIKit

class HamburgerMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets
    
    @IBOutlet var tblView_Menu: UITableView!
    @IBOutlet weak var imgView_Profile_Pic: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView_Menu.tableFooterView = UIView(frame: CGRect.zero)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearTasks()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Setup Methods
    
    func willAppearTasks() {
        let userObj = Constants.userObj!
        lbl_Name.text = userObj.user_name
        lbl_Email.text = userObj.user_email_id
        if userObj.user_pic != "" {
            let url = URL(string: "\(UrlConstants.ImageUrl)\(userObj.user_pic)")
            imgView_Profile_Pic.sd_setImage(with: url, placeholderImage: Constants.ProfilePlaceholder, options: .highPriority, completed: nil)
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func Action_Close_Hamburger_Menu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK:- TableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Side_Menu_Item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HamburgerMenuTVC) as! HamburgerMenuTVC
        
        let itemObj = Side_Menu_Item(rawValue: indexPath.row)!
        cell.lbl_Menu_Item.text = itemObj.string
        cell.lbl_Selection_Indicator.isHidden = (Constants.SideMenuItemSelected == itemObj) ? false : true
        cell.lbl_Menu_Item.textColor = (Constants.SideMenuItemSelected == itemObj) ? UIColor(red: 235/255, green: 58/255, blue: 68/255, alpha: 1) : UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.SideMenuItemSelected = Side_Menu_Item(rawValue: indexPath.row)!
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(Constants.NotiHomeMenuItemChanged), object: Side_Menu_Item(rawValue: indexPath.row)!)
        dismiss(animated: true, completion: nil)
    }
}
