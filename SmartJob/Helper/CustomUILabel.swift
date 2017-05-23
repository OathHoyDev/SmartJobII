//
//  CustomUILabel.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/28/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class CustomUILabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var topMargin : CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        var newBounds = bounds
        newBounds.origin.y += topMargin
    }
    
    
    

}
