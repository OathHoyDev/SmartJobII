//
//  WorkAbroadInfoDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class WorkAbroadInfoDetailViewController: UIViewController {

    @IBOutlet weak var infomationName: UILabel!
    @IBOutlet weak var pdfView: UIWebView!
    
    
    var pdfLink = ""
    
    var item = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    override func viewWillAppear(_ animated: Bool) {
        infomationName.text = item.object(forKey: "TitleMl") as! String
        
        let website = item.object(forKey: "Path") as! String
        let reqURL =  URL(string: website)
        let request = NSURLRequest(url: reqURL!)
        
        pdfView.loadRequest(request as URLRequest)
        
        setNavigationItem()
    }

}
