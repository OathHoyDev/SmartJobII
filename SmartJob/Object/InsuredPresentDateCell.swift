//
//  InsuredPresentDateCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 29/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredPresentDateCell: UITableViewCell {
    
    @IBOutlet weak var presentDate: UILabel!

    @IBOutlet weak var presentNoLb: UILabel!
    @IBOutlet weak var frontLabelCont: NSLayoutConstraint!
    @IBOutlet weak var presentDateLb: UILabel!
    @IBOutlet weak var distic: UILabel!
    
    @IBOutlet weak var disticLb: NSLayoutConstraint!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var addressLb: UILabel!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    
    //var lastPresent : Bool
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        presentDate.text = ""
        address.text = ""
        distic.text = ""
        presentDateLb.text = ""
        
        notificationIcon.image = nil

    }

}
