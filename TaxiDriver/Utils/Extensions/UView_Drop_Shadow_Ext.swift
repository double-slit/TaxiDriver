//
//  UView_Drop_Shadow_Ext.swift
//  FastboxDriver
//
//  Created by Apple on 05/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation


import UIKit

class DropShadow: UIView {
    
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 15
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 1
    }
}
