//
//  HistoryInsuredListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 19/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class HistoryInsuredListViewController: UIViewController , UITableViewDataSource {

    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let empuiHelper = EmpuiHelper()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    var items = NSMutableArray()
    var item = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prepareTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareTable() {
    
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            do {
                
                let employee = self.appDelegate.employee
                
                let memberId = employee.object(forKey: "EmpuiMemberID") as! String
                let nationalId = employee.object(forKey: "PersonalID") as! String
                
                try resp = self.getHistoryRegister(memberId: memberId, nationalId: nationalId)
                
                
            }catch {
                
                
                
            }
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                if resp["RespBody"] != nil {
                    
                    self.items = resp["RespBody"] as! NSMutableArray
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
        }
    
    }
    

    func getHistoryRegister(memberId : String , nationalId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = empuiHelper.getHistoryPresentDate(memberId, andNationalId: nationalId)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        //self.performSegueWithIdentifier("showView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.minimumLineHeight = 15
        let attributes = [NSParagraphStyleAttributeName : style]
        
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryInsuredRegisterCell", for: indexPath) as! HistoryInsuredRegisterCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.presentDate.text = "\(item.object(forKey: "create_date") as! String)"
        
        cell.no.text = "\(item.object(forKey: "register_no") as! String)"
        
        cell.groupName.text = "\(item.object(forKey: "group_name") as! String)"
        
        cell.name.text = "\(item.object(forKey: "name") as! String)"
        
        cell.pdfButton.tag = indexPath.row
        
        return cell
    }

    @IBAction func doLinkPDF(_ sender: UIButton) {
        let tag = sender.tag
        
        let item = items.object(at: tag) as! NSDictionary
        
        let pdfUrl = item.object(forKey: "part_pdf") as! String
        
        UIApplication.shared.openURL(URL(string: pdfUrl)!)
    }

    @IBAction func do_BackPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
