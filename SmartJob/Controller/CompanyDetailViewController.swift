//
//  CompanyDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class CompanyDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var companyObject = NSDictionary()
    
    @IBOutlet weak var permitCode: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var companyDetailButton: UIButton!
    @IBOutlet weak var employeeDetailButton: UIButton!
    
    @IBOutlet weak var companyNameBar: UILabel!
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyDetailView: UIView!
    
    @IBOutlet weak var employeeView: UIView!
    
    @IBOutlet weak var companyOwnerTableView: UITableView!
    
    @IBOutlet weak var compantEmployeeTableView: UITableView!
    
    var ownerItems = NSMutableArray()
    var employeeItems = NSMutableArray()
    
    var isCompanyMode = true
    
    var buttonFrameSize = CGSize()
    var companyFrameSize = CGSize()
    var tableRowViewFrameSize = CGSize()

    let companyStatus = ServiceConstant.NATIONAL_COMPANY_STATUS
    
    let nationalCompanyHelper = NationalCompanyHelper()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        doSwitchView(isCompanyMode: true)
        
        companyDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        employeeDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        
        if let company = getCompanyInfo(companyObject.object(forKey: "CompanyId") as! String) as? NSDictionary {
            if company.count > 0 {
            
                if let value = company.object(forKey: "PermitCode") as? String {
                    permitCode.text = "เลขที่ใบอนุญาต : \(value)"
                }
                
                if let value = company.object(forKey: "Address") as? String {
                    address.text = "ที่อยู่ : \(value)"
                }
                
                if let value = company.object(forKey: "Tel") as? String {
                    tel.text = "เบอร์โทร : \(value)"
                }
                
                if let value = company.object(forKey: "Status") as? String {
                    status.text = "สถานะ : \(value)"
                }
                
                if let value = company.object(forKey: "CompanyName") as? String {
                    companyNameBar.text = value
                }
                
                if let value = company.object(forKey: "CompanyPmList") as? NSMutableArray{
                    ownerItems = value
                }
                
                if let value = company.object(forKey: "CompanyEmpList") as? NSMutableArray {
                    employeeItems = value
                }
                
            }
        }
        
        
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    
        companyDetailButton.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
        employeeDetailButton.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
        
        companyDetailView.addDashedBorder(size: companyFrameSize , color : ServiceConstant.ENABLE_LABEL_COLOR)
        
        setNavigationItem()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        buttonFrameSize = companyDetailButton.frame.size
        companyFrameSize = companyDetailView.frame.size
        
    }
    @IBAction func companyViewAction(_ sender: Any) {
        doSwitchView(isCompanyMode: true)
        
    }
    @IBAction func employeeViewAction(_ sender: Any) {
        doSwitchView(isCompanyMode: false)
    }
    
    func doSwitchView(isCompanyMode : Bool){
        
        if isCompanyMode {
            
            self.isCompanyMode = true
        
            companyView.isHidden = false
            employeeView.isHidden = true
            
            companyDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
            employeeDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        
        }else {
            
            self.isCompanyMode = false
        
            companyView.isHidden = true
            employeeView.isHidden = false
            
            companyDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
            employeeDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.contentView.setNeedsLayout()
//        cell.contentView.layoutIfNeeded()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == companyOwnerTableView {
            return ownerItems.count
        }else {
            return employeeItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.minimumLineHeight = 15
        let attributes = [NSParagraphStyleAttributeName : style]
        
        if tableView == companyOwnerTableView {
            
            // dequeue a cell for the given indexPath
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyOwnerCell", for: indexPath) as! CompanyEmployeeCell
            
            cell.backgroundColor = UIColor.clear
            
            let item = ownerItems.object(at: indexPath.row) as! NSDictionary
            
            
            cell.name.text = item.object(forKey: "NamePm") as! String
            cell.type.text = "ผู้รับอนุญาต"
            
            if let imgData = item.object(forKey: "ImgPm") as? String {
                if imgData != "<br/><br/><b>File Not Found </b>" {
                    let dataDecoded : Data = Data(base64Encoded: imgData, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    cell.imgView.image = decodedimage
                    cell.imgView.layer.cornerRadius = cell.imgView.frame.width/2
                    cell.imgView.layer.masksToBounds = true
                }
            }
            
            cell.cellView.setNeedsLayout()
            cell.cellView.layoutIfNeeded()
            
            cell.cellView.addDashedBorder(size: cell.cellView.frame.size , color : ServiceConstant.ENABLE_LABEL_COLOR)
            
            return cell
            
        }else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyEmployeeCell", for: indexPath) as! CompanyEmployeeCell
            
            cell.backgroundColor = UIColor.clear
            
            let item = employeeItems.object(at: indexPath.row) as! NSDictionary
            
            
            cell.name.text = item.object(forKey: "NameEmp") as! String
            
            if let value = item.object(forKey: "EmpId") as? String {
                cell.type.text = "เลขบัตรลูกจ้าง : \(value)"
            }else{
                cell.type.text = ""
            }
            
            
            if let imgData = item.object(forKey: "ImgEmp") as? String {
                if imgData != "<br/><br/><b>File Not Found </b>" {
                    let dataDecoded : Data = Data(base64Encoded: imgData, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    cell.imgView.image = decodedimage
                    cell.imgView.layer.cornerRadius = cell.imgView.frame.width/2
                    cell.imgView.layer.masksToBounds = true
                }
            }
            
            cell.cellView.setNeedsLayout()
            cell.cellView.layoutIfNeeded()
            
            cell.cellView.addDashedBorder(size: cell.cellView.frame.size , color : ServiceConstant.ENABLE_LABEL_COLOR)
            
            return cell
        
        }
    }

    

    func getCompanyInfo(_ companyId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = nationalCompanyHelper.getCompanyDetail(companyId: companyId)
            
            if resp["RespBody"] != nil {
                return resp["RespBody"] as! NSDictionary
            }
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            
        }
        
        return resp
        
    }


}
