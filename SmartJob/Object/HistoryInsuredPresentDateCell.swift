//
//  HistoryInsuredPresentDateCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 31/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class HistoryInsuredPresentDateCell: UITableViewCell {
    
    @IBOutlet weak var presentDateLb: UILabel!
    @IBOutlet weak var presentDate: UILabel!
    @IBOutlet weak var presentIdLb: UILabel!
    @IBOutlet weak var presentId: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var disticLb: UILabel!
    @IBOutlet weak var distic: UILabel!
    
    @IBOutlet weak var pdfBt: UIButton!

    @IBOutlet weak var frontLabelCont: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        presentDateLb.text = ""
        presentDate.text = ""
        presentIdLb.text = ""
        presentId.text = ""
        addressLb.text = ""
        address.text = ""
        disticLb.text = ""
        distic.text = ""

    }

}
