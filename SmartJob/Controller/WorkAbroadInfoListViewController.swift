//
//  WorkAbroadInfoListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class WorkAbroadInfoListViewController: UIViewController , UITableViewDataSource{
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var notFoundLb: UILabel!
    
    let workAbroadInfoHelper = WorkAbroadInfoHelper()
    
    var selectRow = -1
    
    var items = NSMutableArray()
    
    var selectItem = NSDictionary()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    func startIndicator() {
        loadingView.isHidden = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadWorkAbroadInfoList()
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
    
    func loadWorkAbroadInfoList() {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getWorkAbroadInfo()
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkAbroadInfoCell", for: indexPath) as! WorkAbroadInfoCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.infomation.text = "\(item.object(forKey: "TitleMl") as! String)"
        
        cell.detailButton.tag = indexPath.row
        
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        self.selectItem = items[selectRow] as! NSDictionary
        
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewController:WorkAbroadInfoDetailViewController = segue.destination as! WorkAbroadInfoDetailViewController
        
        viewController.item = selectItem
    
    }

    
    @IBAction func doWorkAbroadInfoDetail(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
        
    }
    
    func getWorkAbroadInfo() -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.workAbroadInfoHelper.getAllWorkAbroadInfo()
            
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    

}
