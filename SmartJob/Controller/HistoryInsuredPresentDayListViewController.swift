//
//  HistoryInsuredPresentDayListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 30/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class HistoryInsuredPresentDayListViewController: UIViewController , UITableViewDataSource {
    
    @IBOutlet weak var refNoLb: UILabel!
    @IBOutlet weak var pdfLinkButt: UIButton!
    
    @IBOutlet weak var presentListView: UIView!
    @IBOutlet weak var qrCodeView: UIView!
    
    @IBOutlet weak var presentBt: UIButton!
    @IBOutlet weak var qrCodeBt: UIButton!

    @IBOutlet weak var qrCodeImageView: UIImageView!
    var qrcodeImage: CIImage!

    @IBOutlet weak var tableView: UITableView!
    
    let empuiHelper = EmpuiHelper()
    
    var items = NSMutableArray()
        
    @IBOutlet weak var loadingView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    var presentInsured = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentListView.isHidden = false
        qrCodeView.isHidden = true
        generateQRImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyPresentDateCell", for: indexPath) as! HistoryInsuredPresentDateCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.frontLabelCont.constant = 30
        }else{
            cell.frontLabelCont.constant = 15
        }
        
        cell.presentDate.text = item["create_date"] as? String
        
        cell.presentId.text = item["register_no"] as? String
        cell.address.text = item["req_position_name"] as? String
       
        
        
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentInfoSegue" {
            let viewController:InsurePresentInfoViewController = segue.destination as! InsurePresentInfoViewController
            
            
        }
    }
    
    func prepareDataTable() {
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            let presentResp = self.getPresentInsured()
            let historyResp = self.getHistoryPresentDateList()
            
            OperationQueue.main.addOperation() {
                
                if historyResp["RespStatus"] != nil {
                    
                    let status = historyResp["RespStatus"] as! NSDictionary
                    
                    if status["StatusID"] as! Int == 1 {
                        
                        self.items = historyResp["RespBody"] as! NSMutableArray
                        
                    }
                    
                }
                
                if presentResp["RespStatus"] != nil {
                    
                    let status = presentResp["RespStatus"] as! NSDictionary
                    
                    if status["StatusID"] as! Int == 1 {
                        
                        self.presentInsured = presentResp["RespBody"] as! NSDictionary
                        
                        self.refNoLb.text = "รหัสอ้างอิง \(self.presentInsured.object(forKey: "register_no") as! String)"
                        
                    }else {
                        self.refNoLb.text = "\(status["StatusMsg"] as! String)"
                        self.pdfLinkButt.alpha = 0.5
                        self.pdfLinkButt.isEnabled = false
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func getHistoryPresentDateList() -> NSDictionary {
        
        var resp = NSDictionary()
        
        let employee = appDelegate.employee
        
        do {
            
            try resp = empuiHelper.getHistoryPresentDate(employee.object(forKey: "EmpuiMemberID") as! String, andNationalId: employee.object(forKey: "PersonalID") as! String)
            loadingView.isHidden = true
            
            return resp
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return NSDictionary()
        }
        
        
        
        //
        
    }
    
    func getPresentInsured() -> NSDictionary {
        
        var resp = NSDictionary()
        
        let employee = appDelegate.employee

        
        do {
            
            try resp = empuiHelper.getPresentInsured(memberId: employee.object(forKey: "EmpuiMemberID") as! String , personalId: employee.object(forKey: "PersonalID") as! String)
            
            loadingView.isHidden = true
            
            return resp
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return NSDictionary()
        }
        
        
        
        //
        
    }
    
    @IBAction func doShowPresentView(_ sender: Any) {
        presentListView.isHidden = false
        qrCodeView.isHidden = true
        
        presentBt.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        qrCodeBt.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
    }
    
    @IBAction func doShowQRCodeView(_ sender: Any) {
        presentListView.isHidden = true
        qrCodeView.isHidden = false
        
        presentBt.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        qrCodeBt.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
    }
    @IBAction func doBackPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func generateQRImage() {
        
        let url = "\(ServiceConstant.QR_CODE_INSURED_URL)/\(presentInsured.object(forKey: "register_no") as! String)"
        
        let data = url.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        qrCodeImageView.image = UIImage(ciImage: qrcodeImage)
        
        
    }
    @IBAction func doLinkPDF(_ sender: Any) {
        
        
        
    }
}
