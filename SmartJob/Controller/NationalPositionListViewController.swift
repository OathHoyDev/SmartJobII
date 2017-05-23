//
//  NationalPositionListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalPositionListViewController: UIViewController , UITableViewDataSource {
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = NSMutableArray()
    
    var selectRow = -1
    
    let nationalPostionHelper = NationalPostionHelper()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    @IBOutlet weak var notFoundLb: UILabel!
    
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
        setNavigationItem()
    }
    
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
    
    

    

    func loadPositionList() {
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            let resp = self.getPositionInfo()
            
            OperationQueue.main.addOperation() {
                
                if resp["RespBody"] != nil {
                    
                    self.items = resp["RespBody"] as! NSMutableArray
                    
                }
                
                self.loadingView.isHidden = true
                
                self.tableView.reloadData()
                
                if self.items.count == 0 {
                    self.notFoundLb.isHidden = false
                }else{
                    self.notFoundLb.isHidden = true
                }
            }
        }
        
        
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadPositionList()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationalPositionCell", for: indexPath) as! NationalPositionCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.position.text = "\(item.object(forKey: "JobName") as! String)"
        
        cell.company.text = "\(item.object(forKey: "BossName") as! String)"
        
        cell.country.text = "ประเทศ \(item.object(forKey: "CtName") as! String)"
        
        cell.detailButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func doCompanyDetail(_ sender: UIButton) {
        
        selectRow = sender.tag
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PositionDetailSegue" {
        
            let view : NationalPositionDetailViewController = segue.destination as! NationalPositionDetailViewController
            
            view.item = items.object(at: selectRow) as! NSDictionary
            
        }
        
    }
    // API
    
    func getPositionInfo() -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = nationalPostionHelper.getNationalPostion(poId: "")
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
        return resp
        
    }


}
