//
//  UILabel_Ext.swift
//  FastboxDriver
//
//  Created by Apple on 04/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

class UILabelPadding: UILabel {
    
    let padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
