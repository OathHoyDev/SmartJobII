//
//  CompanyEmployeeCell.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class CompanyEmployeeCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    var cellFrameSize = CGSize()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cellFrameSize = cellView.frame.size
//        
//        
//        cellView.addDashedBorder(size: cellFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        name.text = ""
        type.text = ""
        
        imgView.image = nil
    }

}
