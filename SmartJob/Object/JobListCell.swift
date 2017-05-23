import UIKit

class JobListCell: UITableViewCell {
    
    @IBOutlet weak var frontLabelCont: NSLayoutConstraint!
    @IBOutlet weak var jobPositionLabel: UILabel!
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var announceUpdateLabel: UILabel!
    @IBOutlet weak var mailNotiIcon: UIImageView!
    
    @IBOutlet weak var detailButton: UIButton!
    override func awakeFromNib() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
        employerNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
