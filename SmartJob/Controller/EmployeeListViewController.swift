//
//  ApplicantListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/8/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var JobPositionNameLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var employeeMatchingButt: UIButton!
    @IBOutlet weak var employeeApplyButt: UIButton!
    
    var haveMessage = false
    var jobAnnounceID = ""
    var employeeID = ""
    var employeeGroupType = ""
    var employeeList = NSMutableArray()
    var jobPositionName = ""
    
    var employee = NSDictionary()
    
    let employeeHelper = EmployeeHelper()
    
    //let keychainWrapper = KeychainWrapper()
    
    let employerHelper = EmployerHelper()
    
    var selectRow = -1;
    
    var isviewFronNoti = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func disableNavigationItem(){
        //self.navigationController!.setNavigationBarHidden(true, animated: true)
        //employeeProfileButton.hidde = false
        //searchButton.enabled = false
        
    }
    
    func enableNavigationItem(){
        //self.navigationController!.setNavigationBarHidden(false, animated: true)
        //employeeProfileButton.enabled = true
        //searchButton.enabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        disableNavigationItem()
        
        if isviewFronNoti {
            
            if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
                
                setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_APPLY)
                
                
            }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
                
                setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_MATCHING)
                
                
            }
            checkNoti()
            
        }else{
            
            if employeeGroupType != "" {

        
                Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
                
                //loadingView.hidden = true
                
                setButtomButton()
                
                
                
                if(tableView.indexPathForSelectedRow != nil){
                    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                }
                
            }else{
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false);
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        getEmployeeList(jobAnnounceID)
        tableView.reloadData()
        self.navigationItem.backBarButtonItem?.title = "Back"
        enableNavigationItem()
        
    }
    
    func checkNoti() {
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if userType == "Employer" && appDelegate.jobAnnounceIDForNoti != "" && appDelegate.employerIDForNoti != "" {
            
            
            jobAnnounceID = appDelegate.jobAnnounceIDForNoti
            haveMessage = true
            employeeID = appDelegate.employeeIDForNoti
            
            let resp = getEmployeeDetail(withEmployeeID: employeeID)
            if resp["RespBody"] != nil {
                
                let respArray = resp["RespBody"] as! NSMutableArray
                employee = respArray.object(at: 0) as! NSDictionary
            }
            
            
            
            performSegue(withIdentifier: "EmployeeDetailSegue", sender: self)
            
        }
    }
    
    func getEmployeeList(_ jobAnnounceID : String) {
        
        let numberFormatter = NumberFormatter()
        let number:NSNumber? = numberFormatter.number(from: jobAnnounceID)
        
        let jobAnnounce : NSDictionary = ["JobAnnounceID" : number!]
        
        if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
            
            setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_APPLY)
            
            employeeList = getEmployeeApplyList(jobAnnounce)
            
            
        }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
            
            setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_MATCHING)
            
            employeeList = getEmployeeMatchingList(jobAnnounce)
            
                        
        }
        
    }
    
    func getEmployeeApplyList(_ jobAnnounce : NSDictionary) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employerHelper.getEmployeeApplyList(jobAnnounce)
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            return NSMutableArray()
        }
        
        
    }
    
    func getEmployeeMatchingList(_ jobAnnounce : NSDictionary) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employerHelper.getEmployeeMatchingList(jobAnnounce)
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            return NSMutableArray()
        }
    }

    
    @IBAction func backToEmployeeGroupTypeApplyAction(_ sender: UIButton) {
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
    
        let n: Int! = self.navigationController?.viewControllers.count
        let employeeApplyGroupController = self.navigationController?.viewControllers[n-2] as! EmployeeGroupListViewController
        
        
        employeeApplyGroupController.employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        
    
    }
    
    @IBAction func backToEmployeeGroupTypeMatchingAction(_ sender: UIButton) {
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        let n: Int! = self.navigationController?.viewControllers.count
        let employeeApplyGroupController = self.navigationController?.viewControllers[n-2] as! EmployeeGroupListViewController
        
        
        employeeApplyGroupController.employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        
        
    }
    
    func setButtomButton() {
    
        if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
            
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis_Dis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = false
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = true
            
            
            
        }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
            
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = true
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee_Dis") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = false
            
            
        }

    
    }
    
    func setNavigationItem(_ title : String) {
        
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
        
        label.attributedText = NSAttributedString(string: title , attributes:attributes)
        
        
        self.navigationItem.titleView = label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JobPositionNameLb.text = jobPositionName
        JobPositionNameLb.backgroundColor = ServiceConstant.BAR_COLOR
        JobPositionNameLb.tintColor = ServiceConstant.BAR_COLOR
        
        // Do any additional setup after loading the view
        tableView.dataSource = self
        
        employeeApplyButt.isEnabled = true
        employeeMatchingButt.isEnabled = true
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicantCell", for: indexPath) as! EmployeeListCell
        
        let item = employeeList.object(at: indexPath.row) as! NSDictionary
        
        if item["MsgFlag"] != nil && item["MsgFlag"] as! String != "0" {
            cell.mailNotiIcon.isHidden = false
            
            var imageMail = UIImage()
            
            if item["MsgFlag"] as! String == "1" {
                imageMail = UIImage(named: "Mail_Icon")! as UIImage
            }else{
                imageMail = UIImage(named: "Mail_Read_Icon")! as UIImage
            }
            
            cell.mailNotiIcon.image = imageMail
            
        }else{
            cell.mailNotiIcon.isHidden = true
        }
        
        if item["ApplyDate"] != nil {
            
            cell.applyDate.isHidden = false
            
            let applyDate = item["ApplyDate"] as! String
            
            let applyDay = applyDate.substring(to: applyDate.range(of: " ")!.lowerBound)
            cell.applyDate.text = "\(applyDay)"
        
        }else{
            cell.applyDateWidthConst.constant = -(cell.employeeDetailButton.frame.size.width - cell.mailNotiIcon.frame.size.width)
        }
        
        cell.employeeNameLb.text = item["EmployeeFullName"] as! String
        cell.backgroundColor = UIColor.clear
        
         
        cell.employeeDetailButton.tag = indexPath.row
        
        
        
        return cell
    }
    
    
    
    @IBAction func detailAction(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        self.shouldPerformSegue(withIdentifier: "EmployeeDetailSegue", sender: self)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if (identifier == "EmployeeDetailSegue"){
            
            let item = employeeList.object(at: selectRow) as! NSDictionary
            
            if item["MsgFlag"] != nil && item["MsgFlag"] as! String != "0" {
                haveMessage = true
            }else {
                haveMessage = false
            }
            
            var resp = NSDictionary()
            
            if !isviewFronNoti {
                resp = getEmployeeDetail(item)
            
            
                if resp["RespBody"] != nil {
                    
                    let respArray = resp["RespBody"] as! NSMutableArray
                    employee = respArray.object(at: 0) as! NSDictionary
                    return true
                }else{
                    return false
                }
                
            }else{
                return true
            }
            
        }else{
            return true
        }
    }
    
    func getEmployeeDetail(withEmployeeID employeeID : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp =  employeeHelper.getEmployeeDetail(withEmployeeID: employeeID)
            
            loadingView.isHidden = true
            
            return resp
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            return NSDictionary()
        }
    }
    
    func getEmployeeDetail(_ employee : NSDictionary) -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp =  employeeHelper.getEmployeeDetail(employee)
            
            loadingView.isHidden = true
            
            return resp
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            return NSDictionary()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let viewController:EmployeeListViewController = segue.destinationViewController as! EmployeeListViewController
        
        if segue.identifier == "EmployeeDetailSegue" {
        
            let viewController:EmployeeDetailViewController = segue.destination as! EmployeeDetailViewController
            
            viewController.employee = employee
            viewController.jobAnnounceID = jobAnnounceID
            viewController.haveMessage = haveMessage
        }
        
        isviewFronNoti = false
        
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        appDelegate.employer = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        UserDefaults.standard.setValue(nil, forKey: "branchID")
        UserDefaults.standard.synchronize()
        
        
        performSegue(withIdentifier: "EmployerLogoutSegue", sender: self)
        
    }
    
    
}
