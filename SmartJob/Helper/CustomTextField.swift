//
//  CustomTextField.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/28/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var topMargin : CGFloat = 10.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.y += topMargin
        return newBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.y += topMargin
        return newBounds
    }

}
