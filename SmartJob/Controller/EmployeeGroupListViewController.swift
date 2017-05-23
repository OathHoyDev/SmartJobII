//
//  ApplicantGroupListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/8/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeGroupListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var logoutButt: UIBarButtonItem!
    
    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet weak var notfoundLabel: UILabel!
    @IBOutlet weak var employeeApplyButt: UIButton!
    @IBOutlet weak var employeeMatchingButt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var applyJobGroup = NSMutableArray()
    var employeeList = NSMutableArray()
    var isviewFronNoti = false
    
    var jobAnnounceID = ""
    
    var employeeGroupType = ""
    
    var selectRow = -1;
    
    //var employerID = ""
    var employer = NSDictionary()
    
    let employerHelper = EmployerHelper()
    //let keychainWrapper = KeychainWrapper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func checkLogin() {
        
        var employeeID = ""
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if let value = appDelegate.employee.object(forKey: "EmployeeID") as? String {
            employeeID = value
        }
        
        if hasLogin && employeeID != "" {
            self.navigationItem.hidesBackButton = true
            
        }else{
            UIView.setAnimationsEnabled(true)
            self.navigationItem.hidesBackButton = false
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            startLoadContent()
        }
        
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
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
        checkNoti()
    
        setNavigationItem("")
        
        applyJobGroup.removeAllObjects()
        tableView.dataSource = self
        tableView.reloadData()
        
        checkLogin()
        
        UIView.setAnimationsEnabled(true)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
        }else{
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        }
    }
    
    func setTitleBar() {
        
        if employeeGroupType == "" {
            employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY
        }
        
        if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
            setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_APPLY)
        }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
            setNavigationItem(ServiceConstant.TITLE_EMPLOYEE_MATCHING)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setTitleBar()
        
        startLoadContent()
        
        enableNavigationItem()
    }
    
    func startLoadContent() {
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.disableNavigationItem), toTarget: self, with: nil)
        
        if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis_Dis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = false
            
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = true
            
            applyJobGroup = getEmployeeApplyGroup()
            
            //self.title = ServiceConstant.TITLE_EMPLOYEE_APPLY
            
            
            
            
        }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = true
            
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee_Dis") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = false
            
            applyJobGroup = getEmployeeMatchingGroup()
            
            //self.title = ServiceConstant.TITLE_EMPLOYEE_MATCHING
            
            
        }
        
        if applyJobGroup.count == 0 {
            jobListTableView.isHidden = true
            notfoundLabel.isHidden = false
        }else{
            jobListTableView.isHidden = false
            notfoundLabel.isHidden = true
        }
        
        loadingView.isHidden = true
        
        tableView.dataSource = self
        tableView.reloadData()
        
        enableNavigationItem()
        
    }
    
    func setNavigationItem(_ title : String) {
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.alignment = NSTextAlignment.center
        
        self.navigationController?.navigationBar.isHidden = false
        
        
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
        
        self.navigationController?.isNavigationBarHidden = false
        
        employer = appDelegate.employer
        
        startLoadContent()
        
        
        
    }
    
    func applicationDidBecomeActive( _ application: UIApplication) {
        checkNoti()
    }
    
    func checkNoti() {
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if userType == "Employer" && appDelegate.haveNotiFromBackground {
        
            isviewFronNoti = true
            
            jobAnnounceID = appDelegate.jobAnnounceIDForNoti
            
            performSegue(withIdentifier: "EmployeeInGroupSegue", sender: self)
            
        }
    }
    
    func getEmployeeApplyGroup() -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employerHelper.getEmployeeApplyGroup(employer)
            
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
    
    func getEmployeeMatchingGroup() -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employerHelper.getEmployeeMatchingGroup(employer)
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyJobGroup.count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobGroupCell", for: indexPath) as! JobApplyGroupCell
        
        cell.backgroundColor = UIColor.clear
        
        let group = applyJobGroup.object(at: indexPath.row) as! NSDictionary
        
        cell.jobGroupNameLb.text = group["JobPosition"] as! String
        var applyNumber : NSNumber!
        if group["ApplyNumber"] != nil {
            applyNumber = group["ApplyNumber"] as! NSNumber
        }else if group["MatchNumber"] != nil {
            applyNumber = group["MatchNumber"] as! NSNumber
        }
        
        let applyAmount = "\(applyNumber)"
        
        cell.jobApplyNumberLb.text = "\(addComma(applyAmount))"
        
        cell.employeeListButton.tag = indexPath.row
        
        cell.jobGroupNameLb.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func addComma(_ text : String) -> String {
        
        var largeNumber : NSNumber = 0
        
        if let number = Int(text) {
            largeNumber = NSNumber(value: number as Int)
            //            print(largeNumber)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        return numberFormatter.string(from: largeNumber)!
        
    }
    
    @IBAction func employeeListAction(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
        self.shouldPerformSegue(withIdentifier: "EmployeeInGroupSegue", sender: self)
        
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
//        if (identifier == "EmployeeInGroupSegue"){
//            
//            let indexRow = tableView.indexPathForSelectedRow! as NSIndexPath
//            
//            let group = applyJobGroup.objectAtIndex(indexRow.row) as! NSDictionary
//            
//            NSThread.detachNewThreadSelector(Selector("startIndicator"), toTarget: self, withObject: nil)
//            
////            getEmployeeList(group)
////            
////            if employeeList.count > 0 {
////                return true
////            }else{
////                return false
////            }
//            
//            return true
//            
//        }else{
//            return true
//        }
        
        return true
    }
    
    func getEmployeeList(_ jobAnnounce : NSDictionary) {
    
        if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY {
            employeeList = getEmployeeApplyList(jobAnnounce)
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = false
            
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee_Dis") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = false
            
        }else if employeeGroupType == ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING {
            employeeList = getEmployeeMatchingList(jobAnnounce)
            
            let imageEmployeeApply = UIImage(named: "Button_Employee_Regis_Dis") as UIImage?
            employeeApplyButt.setBackgroundImage(imageEmployeeApply, for: UIControlState())
            employeeApplyButt.isUserInteractionEnabled = false
            
            let imageEmployeeMatching = UIImage(named: "Button_Property_Employee") as UIImage?
            employeeMatchingButt.setBackgroundImage(imageEmployeeMatching, for: UIControlState())
            employeeMatchingButt.isUserInteractionEnabled = false
            
        }
    
    }
    
    func getEmployeeApplyList(_ jobAnnounce : NSDictionary) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
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
        
        Thread.detachNewThreadSelector(#selector(EmployeeGroupListViewController.startIndicator), toTarget: self, with: nil)
        
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmployeeInGroupSegue" {
        
            let viewController:EmployeeListViewController = segue.destination as! EmployeeListViewController
        
            if !isviewFronNoti {
                
                let indexPath = tableView.indexPathForSelectedRow! as IndexPath
                let group = applyJobGroup.object(at: indexPath.row) as! NSDictionary
                jobAnnounceID = "\(group["JobAnnounceID"] as! NSNumber)"
                viewController.jobPositionName = group["JobPosition"] as! String
                viewController.employeeGroupType = employeeGroupType
                
            }
            else{
                viewController.jobPositionName = ""
                viewController.isviewFronNoti = true
                viewController.employeeGroupType = ""
            }
            
            //viewController.employeeList = employeeList
            viewController.jobAnnounceID = jobAnnounceID
            
            isviewFronNoti = false
            
            viewController.title = self.title
            
        }
    }
    
    @IBAction func employeeApplyAction(_ sender: AnyObject) {
        employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY
        setTitleBar()
        startLoadContent()
        
    }
    
    @IBAction func employeeMatchingAction(_ sender: AnyObject) {
        employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING
        setTitleBar()
        startLoadContent()
        
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
