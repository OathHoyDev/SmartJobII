//
//  JobApplyGroupCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/17/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JobApplyGroupCell: UITableViewCell {

    @IBOutlet weak var employeeListButton: UIButton!
    @IBOutlet weak var jobGroupNameLb: UILabel!
    @IBOutlet weak var jobApplyNumberLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
