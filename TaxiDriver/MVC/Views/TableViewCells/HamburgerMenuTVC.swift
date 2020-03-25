//
//  HamburgerMenuTVC.swift
//  OntarioCustomer
//
//  Created by Shivani Bajaj on 24/09/17.
//  Copyright © 2017 Shivani Bajaj. All rights reserved.
//

import UIKit

class HamburgerMenuTVC: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet var lbl_Menu_Item: UILabel!
    @IBOutlet var lbl_Selection_Indicator: UILabel!
    
    //MARK:- View Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
