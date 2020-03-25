//
//  BookingRequestCell.swift
//  FastboxDriver
//
//  Created by Apple on 20/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BookingRequestCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var lbl_Item_Name: UILabel!
    @IBOutlet weak var lbl_Item_Type: UILabel!
    @IBOutlet weak var lbl_Location_Name: UILabel!
    @IBOutlet weak var btn_Details: UIButton!
    
    //MARK:- Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_Content.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
