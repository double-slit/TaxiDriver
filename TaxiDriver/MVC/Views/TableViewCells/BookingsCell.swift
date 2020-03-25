//
//  BookingsCell.swift
//  FastboxDriver
//
//  Created by Apple on 25/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BookingsCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var lbl_Ride_Status: UILabel!
    @IBOutlet weak var view_Content: UIView!
    
    //MARK:- Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_Ride_Status.layer.cornerRadius = lbl_Ride_Status.bounds.height / 2
        view_Content.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
