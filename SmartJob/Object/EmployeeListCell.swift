//
//  EmployeeListCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/17/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeListCell: UITableViewCell {

    @IBOutlet weak var applyDateWidthConst: NSLayoutConstraint!
    @IBOutlet weak var employeeDetailButton: UIButton!
    @IBOutlet weak var mailNotiIcon: UIImageView!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var applyDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        employeeNameLb.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
