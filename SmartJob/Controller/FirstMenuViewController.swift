//
//  FirstMenuViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 9/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class FirstMenuViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let employeeHelper = EmployeeHelper()
    let employerHelper = EmployerHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func checkLogin() {
    
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin {
            
            let userType = UserDefaults.standard.value(forKey: "userType") as? String
            let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
            let password = UserDefaults.standard.value(forKey: "password") as? String
            
            if userType == "Employee" {
                
                
                
                _ = doLoginEmployee(usercode!, withPassword: password!) as! NSDictionary
                
            }else{
                let branchID = UserDefaults.standard.value(forKey: "branchID") as? String
                
                _ = doLoginEmployer(usercode: usercode!, password: password!, branchID: branchID!)
            
                
            
            }
            
            
        }else {
            performSegue(withIdentifier: "LocalJobSegue", sender: self)
        }
    
    }
    
    func doLoginEmployer(usercode : String , password : String , branchID : String) -> NSDictionary {
        
        var soapResp = NSDictionary()
        
        var employer = NSDictionary()
        
        do{
            
            try soapResp = employerHelper.login(usercode, withPassword: password, withBranch: branchID)
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                if resp["StatusID"] as! NSNumber == 1 {
                    let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    if respBody.count > 0 {
                        
                        employer = respBody.object(at: 0) as! NSDictionary
                        
                        appDelegate.employer = employer
                        appDelegate.usercode = usercode
                        
                        UserDefaults.standard.setValue(usercode, forKey: "usercode")
                        UserDefaults.standard.setValue(password, forKey: "password")
                        UserDefaults.standard.setValue(branchID, forKey: "branchID")
                        UserDefaults.standard.set(true, forKey: "hasLogin")
                        UserDefaults.standard.setValue("Employer", forKey: "userType")
                        UserDefaults.standard.synchronize()
                        
                        performSegue(withIdentifier: "EmployerHasLoginSegue", sender: self)
                        
                        
                    }else{
                        let alertController = UIAlertController(title: "", message:
                            "\(resp.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                        
                        present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                }else {
                    let alertController = UIAlertController(title: "", message:
                        "\(resp.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
            
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        return employer
        
    }

    func doLoginEmployee(_ userCode : String , withPassword password: String) -> NSDictionary {
        
        var employee = NSDictionary();
        var soapResp = NSDictionary();
        
        do{
            try soapResp = employeeHelper.login(userCode, withPassword: password)
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                if resp["StatusID"] as! NSNumber == 1 {
                    let respBody = soapResp["RespBody"] as! NSMutableArray
                    employee = respBody.object(at: 0) as! NSDictionary
                    
                    appDelegate.employee = employee
                    appDelegate.usercode = userCode
                    
                    UserDefaults.standard.setValue(userCode, forKey: "usercode")
                    UserDefaults.standard.setValue(password, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "hasLogin")
                    UserDefaults.standard.setValue("Employee", forKey: "userType")
                    UserDefaults.standard.synchronize()
                    
                    if employee.object(forKey: "EmployeeID") as! String != "" {
                    
                        performSegue(withIdentifier: "EmployeeHasLoginSegue", sender: self)
                        
                    }else{
                        performSegue(withIdentifier: "LocalJobSegue", sender: self)
                    }
                    
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
        
        return employee
        
    }
    
    @IBAction func do_LocalJob(_ sender: Any) {
        
        checkLogin()
        
    }


}
