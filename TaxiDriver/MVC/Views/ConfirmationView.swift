//
//  ConfirmationView.swift
//  FastboxDriver
//
//  Created by Apple on 27/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ConfirmationView: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lbl_Msg: UILabel!
    @IBOutlet weak var btn_Option_Left: UIButton!
    @IBOutlet weak var btn_Option_Right: UIButton!
    
    //MARK:- Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    init(frame: CGRect,withMessage msg:String,withLeftOption leftOption:String,withRightOption rightOption:String) {
        super.init(frame: frame)
        setUpView()
        lbl_Msg.text = msg
        btn_Option_Left.setTitle(leftOption, for: .normal)
        btn_Option_Right.setTitle(rightOption, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init not implemented")
    }
    
    //MARK:- View Setup Methods
    
    func setUpView() {
        Bundle.main.loadNibNamed("ConfirmationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
