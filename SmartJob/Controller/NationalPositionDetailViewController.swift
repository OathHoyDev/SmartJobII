//
//  NationalPositionDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 17/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalPositionDetailViewController: UIViewController {

    @IBOutlet weak var bossName: UILabel!
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var jobDesc: UILabel!
    @IBOutlet weak var numSekker: UILabel!
    @IBOutlet weak var wage: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var openDate: UILabel!
    @IBOutlet weak var closeDate: UILabel!
    
    var item = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPositionJobDetail()
    }
    
    func setPositionJobDetail() {
        
        if let value = item.object(forKey: "BossName") as? String {
        bossName.text = value
        }
        if let value = item.object(forKey: "JobName") as? String {
        position.text = value
        }
        if let value = item.object(forKey: "CtName") as? String {
        country.text = value
        }
        if let value = item.object(forKey: "BossAddress") as? String {
        address.text = value
        }
        if let value = item.object(forKey: "JobDesc") as? String {
        jobDesc.text = value
        }
        
        if let value = item.object(forKey: "NumSeeker") as? String {
            numSekker.text = "\(value) ตำแหน่ง"
        }
        if let value = item.object(forKey: "Wage") as? String {
            if let currency = item.object(forKey: "Currency") as? String {
                wage.text = "\(value) \(currency)"
            }else{
                wage.text = value
            }
        }
        if let value = item.object(forKey: "Benefit") as? String {
            benefit.text = value
        }
        if let value = item.object(forKey: "OpenDate") as? String{
            openDate.text = value
        }
        if let value = item.object(forKey: "CloseDate") as? String {
            closeDate.text = value
        }
    }
    

    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setNavigationItem() {
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.alignment = NSTextAlignment.center
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: navHeight!))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: ServiceConstant.FONT_NAME, size: 20)!
        
        let attributes = [NSParagraphStyleAttributeName : style]
        
        label.attributedText = NSAttributedString(string: self.navigationItem.title! , attributes:attributes)
        
        
        self.navigationItem.titleView = label
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        
    }


}
