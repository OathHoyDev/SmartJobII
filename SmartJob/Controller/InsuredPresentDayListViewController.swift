//
//  InsuredReportDayListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 20/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredPresentDayListViewController: UIViewController , UITableViewDataSource   {
    
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var presentListView: UIView!
    
    @IBOutlet weak var refNoLb: UILabel!
    @IBOutlet weak var pdfLinkButt: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var items = NSMutableArray()
    
    var item = NSDictionary()
    
    var respPresentInsured = NSDictionary()
    
    let empuiHelper = EmpuiHelper()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var presentBt: UIButton!
    @IBOutlet weak var qrCodeBt: UIButton!
    
    var presentInsured = NSDictionary()
    
    var sequence = ""
    
    var isPresentDateListView = true
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var qrcodeImage: CIImage!
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    //sideMenu
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    @IBOutlet weak var sideMenuView: UIView!
    var sideMenuViewSize = CGSize()
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    var smartjobLogoViewSize = CGSize()
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var smartJobLb: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var employeeProfileBt: UIButton!
    @IBOutlet weak var logoutBt: UIButton!
    @IBOutlet weak var loginBt: UIButton!
    
    var isSideMenuShow = false
    
    var isSixPresent = false
    var sixPresentRespMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white

        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let buttonFrameSize = presentBt.frame.size
        
        
        presentBt.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
        
        qrCodeBt.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prepareDataTable()
        preparePDF()
        
        
        setNavigationItem()
        
        doCheckLogin()
        
        sideMenu(false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isPresentDateListView {
        
            presentListView.isHidden = false
            qrCodeView.isHidden = true
            
        }else{
        
            presentListView.isHidden = true
            qrCodeView.isHidden = false
        
        }
        
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
        
        
        item = items.object(at: indexPath.row) as! NSDictionary
        
        sequence = "\(indexPath.row + 1)"
        
        switch item["insureStatus"] as! String {
            
        case "Success" :
            
            performSegue(withIdentifier: "HistoryPresentInfoSegue", sender:self)
            
        case "Waiting" :
            
            performSegue(withIdentifier: "PresentInfoSegue", sender:self)
            
        case "Cancel" :
            
            let alertController = UIAlertController(title: "", message:
                "ท่านไม่ได้รายงานตัวในวันดังกล่าว", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        case "Nothing" :
            
            let alertController = UIAlertController(title: "", message:
                "ยังไม่ใช่วันรายงานตัวของท่าน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        default :
            let alertController = UIAlertController(title: "", message:
                "\(sixPresentRespMessage)", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.minimumLineHeight = 15
        let attributes = [NSParagraphStyleAttributeName : style]
        
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "presentDateCell", for: indexPath) as! InsuredPresentDateCell
        
        cell.backgroundColor = UIColor.clear
        
        item = items.object(at: indexPath.row) as! NSDictionary
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.frontLabelCont.constant = 30
        }else{
            cell.frontLabelCont.constant = 15
        }
        
        cell.presentDate.text = item["reg_date"] as? String
        cell.address.text = item["location_name"] as? String
        cell.distic.text = item["location_group_name"] as? String
        
        cell.presentDateLb.text = "ครั้งที่ \(indexPath.row + 1)"
        
        switch item["positive"] as! String {
        case "ตรงตามกำหนด" :
            
            cell.notificationIcon.image = UIImage(named : "ic_success")
            
            item.setValue("Success", forKey: "insureStatus")
            
        case "ช้ากว่ากำหนด" :
            
            cell.notificationIcon.image = UIImage(named : "ic_success")
            
            item.setValue("Success", forKey: "insureStatus")
            
        case "-" :
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "th")
            formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
            
            if let presentDate = formatter.date(from: item["reg_date"] as! String) {
                
                let sysDate = Date()
                
                let userCalendar = Calendar.current
                
                let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second]
                
                var timeDifference = userCalendar.dateComponents(requestedComponent, from: sysDate, to: presentDate)
                
                print("Sequence : \(indexPath.row)")
                print("sysDate : \(sysDate)")
                print("presentDate : \(presentDate) , timeDifference : \(timeDifference.day)")
                
                
                if (timeDifference.month! == 0 && timeDifference.day! > 7) || timeDifference.month! > 0  {
                    
                    item.setValue("Nothing", forKey: "insureStatus")
                    
                }else if (timeDifference.month! == 0 && timeDifference.day! < -7) || timeDifference.month! < 0 {
                
                    cell.notificationIcon.image = UIImage(named : "ic_cancel")
                    
                    item.setValue("Cancel", forKey: "insureStatus")
                
                }else if (timeDifference.month! == 0 && (timeDifference.day! > -7 && timeDifference.day! < 7)){
                    
                    cell.notificationIcon.image = UIImage(named : "ic_warnning")
                    
                    item.setValue("Waiting", forKey: "insureStatus")
                }
                
            }
            
        default :
            break
        
        }
        
        
        
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
            
            let infoViewController = segue.destination as! InsurePresentInfoViewController
            
            infoViewController.item = presentInsured
            infoViewController.sequence = sequence
            
        }else if segue.identifier == "HistoryPresentInfoSegue" {
            
            let infoViewController : InsurePresentDetailViewController = segue.destination as! InsurePresentDetailViewController
            
            infoViewController.presentInsure = presentInsured
            infoViewController.sequence = sequence
        }
        
    }
    
    func preparePDF() {
        
        let employee = appDelegate.employee
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            let memberId = employee.object(forKey: "EmpuiMemberID") as! String
            let personalId = employee.object(forKey: "PersonalID") as! String
            
            self.respPresentInsured = self.getPresentInsured(memberId: memberId, personalId: personalId)
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                if self.respPresentInsured["RespStatus"] != nil {
                    
                    let status = self.respPresentInsured["RespStatus"] as! NSDictionary
                    
                    if status["StatusID"] as! Int == 908 {
                        self.isSixPresent = true
                        self.sixPresentRespMessage = status["StatusMsg"] as! String
                    }else if status["StatusID"] as! Int == 1 {
                    
                        self.presentInsured = self.respPresentInsured["RespBody"] as! NSDictionary
                        
                        if let value = self.presentInsured.object(forKey: "register_no") as? String {
                            
                            self.refNoLb.text = "รหัสอ้างอิง \(self.presentInsured.object(forKey: "register_no") as! String)"
                            
                            self.qrCodeBt.isEnabled = true
                            self.qrCodeBt.alpha = 1
                            
                            self.generateQRImage()
                            
                        }else {
                            
                            self.qrCodeBt.isHidden = true
                            self.presentBt.isHidden = true
                            
                        }
                    }
                    
                }
                
            }
        }

    }
    
    func prepareDataTable() {
        
        var respPresentDate = NSDictionary()
        
        let employee = appDelegate.employee
        
        
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            let memberId = employee.object(forKey: "EmpuiMemberID") as! String
            let personalId = employee.object(forKey: "PersonalID") as! String
            
            let respPresentDate = self.getPresentDateList(memberId: memberId)
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                if respPresentDate["RespStatus"] != nil {
                    
                    let status = respPresentDate["RespStatus"] as! NSDictionary
                    
                    let respDateList = respPresentDate["RespBody"] as! NSMutableArray
                    
                    if respDateList.count > 0 {
                        self.items = respDateList
                        
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }

    
    }
    
    func getPresentDateList(memberId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do {
            
            try resp = empuiHelper.getPresentDate(memberId)
            
            return resp
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return NSDictionary()
        }
        
    }
    
    func getPresentInsured(memberId : String , personalId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do {
            
            try resp = empuiHelper.getPresentInsured(memberId: memberId, personalId: personalId)
            
            return resp
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return NSDictionary()
        }
        
    }

    @IBAction func doShowPresentView(_ sender: Any) {
        
        isPresentDateListView = true
        
        presentListView.isHidden = false
        qrCodeView.isHidden = true
        
        presentBt.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        qrCodeBt.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR

    }
    
    @IBAction func doShowQRCodeView(_ sender: Any) {
        
        isPresentDateListView = false
        
        presentListView.isHidden = true
        qrCodeView.isHidden = false
        
        presentBt.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        qrCodeBt.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        
    }
    
    func generateQRImage() {
        
        let url = "\(ServiceConstant.QR_CODE_INSURED_URL)/\(self.presentInsured.object(forKey: "register_no") as! String)"
        
        let data = url.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        qrCodeImageView.image = UIImage(ciImage: qrcodeImage)
        
    
    }
    
    @IBAction func doLinkPDF(_ sender: Any) {
        
        let url = "\(ServiceConstant.QR_CODE_INSURED_URL)/\(presentInsured.object(forKey: "register_no") as! String)"
       UIApplication.shared.openURL(URL(string: "\(url)")!)
        
    }
    
    func doCheckLogin () {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin {
            
            sideMenuDetail(isLogin: true)
            
        }else {
            
            sideMenuDetail(isLogin: false)
            
        }
        
    }

    
    func sideMenuDetail(isLogin : Bool){
        
        
        
        if (isLogin) {
            
            let employee = appDelegate.employee
            
            loginBt.isHidden = true
            logoutBt.isHidden = false
            employeeProfileBt.isHidden = false
            
            smartJobLb.isHidden = true
            employeeNameLb.isHidden = false
            
            if let value = employee.object(forKey: "EmployeeFullName") as? String {
                employeeNameLb.text = value
            }else{
                employeeNameLb.text = ""
            }
            
            logoImage.image = UIImage(named : "Image_Cartoon_Employee")
            
            
            
        }else {
            
            loginBt.isHidden = false
            logoutBt.isHidden = true
            employeeProfileBt.isHidden = true
            
            smartJobLb.isHidden = false
            employeeNameLb.isHidden = true
            
            logoImage.image = UIImage(named : "logoOnly")
            
        }
        
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if (!isSideMenuShow){
            sideMenu(true)
        }else{
            sideMenu(false)
        }
        
    }
    
    func sideMenu(_ action : Bool){
        
        if (action){
            sideMenuView.isHidden = false
            sideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            isSideMenuShow = true
        }else{
            sideMenuLeadingConstraint.constant = -sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            sideMenuView.isHidden = true
            isSideMenuShow = false
        }
    }
    
    @IBAction func doLogout(_ sender: Any) {
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        let alertController = UIAlertController(title: "ออกจากระบบสำเร็จ", message:
            "ออกจากระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
            
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    
    
}
