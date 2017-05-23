//
//  MainMenuViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/14/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var logoWidthConst: NSLayoutConstraint!
    
    @IBOutlet weak var buttonWidthConst: NSLayoutConstraint!
    var jobList = NSDictionary()
    
    
    let employeeHelper = EmployeeHelper()
    let employerHelper = EmployerHelper()
    
    @IBOutlet weak var loadingView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 30
        style.lineSpacing = 5
        
        let ipadStyle = NSMutableParagraphStyle()
        ipadStyle.minimumLineHeight = 35
        ipadStyle.lineSpacing = 5
        
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: 0), for: .default)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: ServiceConstant.FONT_NAME, size: 20)!], for: UIControlState())
            
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSParagraphStyleAttributeName : ipadStyle ,
                NSForegroundColorAttributeName: UIColor.white ,
                NSFontAttributeName: UIFont(name: ServiceConstant.FONT_NAME, size: 20)!]
        }else{
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: ServiceConstant.FONT_NAME, size: 16)!], for: UIControlState())
            
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSParagraphStyleAttributeName : style ,
                NSForegroundColorAttributeName: UIColor.white ,
                NSFontAttributeName: UIFont(name: ServiceConstant.FONT_NAME, size: 16)!]
        }
        
        checkLogin()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setLayout(){
    
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            
            let newLogoWidthConst = NSLayoutConstraint(
                item: logoWidthConst.firstItem,
                attribute: logoWidthConst.firstAttribute,
                relatedBy: logoWidthConst.relation,
                toItem: logoWidthConst.secondItem,
                attribute: logoWidthConst.secondAttribute,
                multiplier: 0.3,
                constant: logoWidthConst.constant)
            
            newLogoWidthConst.priority = logoWidthConst.priority

            
            let newButtonWidthConstraint = NSLayoutConstraint(
                item: buttonWidthConst.firstItem,
                attribute: buttonWidthConst.firstAttribute,
                relatedBy: buttonWidthConst.relation,
                toItem: buttonWidthConst.secondItem,
                attribute: buttonWidthConst.secondAttribute,
                multiplier: 0.45,
                constant: buttonWidthConst.constant)
            
            newButtonWidthConstraint.priority = buttonWidthConst.priority
            
            newButtonWidthConstraint.isActive = true
            newLogoWidthConst.isActive = true
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setLayout()
        
        loadingView.isHidden = true
        
        
    
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        
        if hasLogin {
            
            let userType = UserDefaults.standard.value(forKey: "userType") as? String
            
            if userType == "Employee" {
                let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
                let password = UserDefaults.standard.value(forKey: "password") as? String
                
                var soapResp = NSDictionary()
                
                var employee = NSDictionary()
                
                
                do{
                    try soapResp = employeeHelper.login(usercode!, withPassword: password!)
                    
                    if soapResp.count > 0 {
                        
                        let resp = soapResp["RespStatus"] as! NSDictionary
                        
                        if resp["StatusID"] as! NSNumber == 1 {
                            let respBody = soapResp["RespBody"] as! NSMutableArray
                            employee = respBody.object(at: 0) as! NSDictionary
                            
                            appDelegate.employee = employee
                            appDelegate.usercode = usercode!
                            
                            UserDefaults.standard.setValue(usercode, forKey: "usercode")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            UserDefaults.standard.set(true, forKey: "hasLogin")
                            UserDefaults.standard.setValue("Employee", forKey: "userType")
                            UserDefaults.standard.synchronize()
                            
                            checkNationalAccountStatus(employee: employee)
                            
                            
                        }else{
                            
                            let respMessage = resp["StatusMsg"] as! String
                        
                            let alertController = UIAlertController(title: "", message:
                                "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                            
                            present(alertController, animated: true, completion: nil)
                            
                            appDelegate.employee = NSDictionary()
                            appDelegate.usercode = ""
                            
                            UserDefaults.standard.setValue(nil, forKey: "usercode")
                            UserDefaults.standard.setValue(nil, forKey: "password")
                            UserDefaults.standard.set(false, forKey: "hasLogin")
                            UserDefaults.standard.setValue(nil, forKey: "userType")
                            UserDefaults.standard.synchronize()

                        
                        }
                    }
                }catch {
                    
                    
                    
                    let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                        "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                
            }else if userType == "Employer" {
                
                
                
                let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
                let password = UserDefaults.standard.value(forKey: "password") as? String
                let branchID = UserDefaults.standard.value(forKey: "branchID") as? String
                
                var soapResp = NSDictionary()
                var employer = NSDictionary()
                
                do{
                    try soapResp = employerHelper.login(usercode!, withPassword: password!, withBranch: branchID!)
                    
                    if soapResp.count > 0 {
                        
                        let resp = soapResp["RespStatus"] as! NSDictionary
                        
                        if resp["StatusID"] as! NSNumber == 1 {
                            let respBody = soapResp["RespBody"] as! NSMutableArray
                            employer = respBody.object(at: 0) as! NSDictionary
                            
                            appDelegate.employer = employer
                            appDelegate.usercode = usercode!
                            
                            UserDefaults.standard.setValue(usercode, forKey: "usercode")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            UserDefaults.standard.setValue(branchID, forKey: "branchID")
                            UserDefaults.standard.set(true, forKey: "hasLogin")
                            UserDefaults.standard.setValue("Employer", forKey: "userType")
                            UserDefaults.standard.synchronize()
                            
                            performSegue(withIdentifier: "employerLoginSegeue", sender: self)
                        }
                    }
                    
                    
                }catch {
                    
                    
                    let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                        "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                    appDelegate.employee = NSDictionary()
                    appDelegate.usercode = ""
                    
                    UserDefaults.standard.setValue(nil, forKey: "usercode")
                    UserDefaults.standard.setValue(nil, forKey: "password")
                    UserDefaults.standard.set(false, forKey: "hasLogin")
                    UserDefaults.standard.setValue(nil, forKey: "userType")
                    UserDefaults.standard.synchronize()
                                        
                }
                
            }
        }else{
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func checkNationalAccountStatus(employee : NSDictionary) {
        
        let statusList = employee.object(forKey: "StatusList") as! NSMutableArray
        let accountStatus = statusList.object(at: 0) as! NSDictionary
        let status = accountStatus.object(forKey: "StatusFlag") as! String
        
        switch status {
        case "01" :
            
            performSegue(withIdentifier: "EmployeeHasLoginSegue", sender: self)

            
        default :
            break
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getJobListAction(_ sender: AnyObject) {
        
        Thread.detachNewThreadSelector(#selector(MainMenuViewController.startIndicator), toTarget: self, with: nil)
        
        performSegue(withIdentifier: "JobListSegue", sender: self)

    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "JobListSegue" {
            
            let viewController:JobListViewController = segue.destination as! JobListViewController
            viewController.title = ServiceConstant.TITLE_JOB_NEW
            //viewController.jobListData = jobList

        }
        
        else if segue.identifier == "EmployeeHasLoginSegue" {
        
            let view : JobOfEmployeeListViewController = segue.destination as! JobOfEmployeeListViewController
            
            view.employee = appDelegate.employee
            view.jobListType = ServiceConstant.JOB_LIST_TYPE_MATCHING
        
        }
    }
    
    @IBAction func backToFirstMenuAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}

struct MyConstraint {
    static func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
