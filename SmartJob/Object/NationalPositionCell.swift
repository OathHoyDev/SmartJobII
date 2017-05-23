//
//  NationalPositionCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalPositionCell: UITableViewCell {

    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        position.text = ""
        
        date.text = ""
        company.text = ""
        country.text = ""

    }

}
