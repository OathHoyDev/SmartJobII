//
//  HistoryInsuredRegisterCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 19/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class HistoryInsuredRegisterCell: UITableViewCell {

    @IBOutlet weak var presentDate: UILabel!
    @IBOutlet weak var no: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var pdfButton: UIButton!
    
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
        no.text = ""
        groupName.text = ""
        name.text = ""
    }

}
