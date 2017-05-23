//
//  ConfirmEmpuiRegistrationViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 8/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class ConfirmEmpuiRegistrationViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    var employee = NSDictionary()
    
    let empuiHelper = EmpuiHelper()
    let employeeHelper = EmployeeHelper()
    
    var employeeProfile = NSMutableDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var detailView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func startIndicator() {
        //loadingView.isHidden = false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func do_Registration(_ sender: Any) {
        
        empuiRegistration()
        
        
        

        
    }
    
    func empuiRegistration(){
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(ConfirmEmpuiRegistrationViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = empuiHelper.empuiRegistration(employeeProfile)
            
            //loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                //                print("Register Resp : \(resp)")
                
                if resp["StatusID"] as! NSNumber == 1 {
                    //let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    let alertController = UIAlertController(title: "ลงทะเบียนเรียบร้อยแล้ว", message:
                        "ลงทะเบียนเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        
                        self.doLogin(userCode: self.employeeProfile.object(forKey: "nationalId") as! String, password: self.employeeProfile.object(forKey: "password") as! String)
                    
                        
                        
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                    
                }else {
                    let errorMsg = resp["StatusMsg"] as! String
                    
                    let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                        "\(errorMsg)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
                
            }else{
                
                let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                    "ลงทะเบียนผิดพลาด", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
                }))
                
                present(alertController, animated: true, completion: nil)
                
            }
            
        }catch {
            
            //loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                "\(error)", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }

    }
    
    func doLogin(userCode : String , password: String) -> NSDictionary {
        
        var employee = NSDictionary()
        var soapResp = NSDictionary()
        
        
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
                    
                    performSegue(withIdentifier: "RegistrationCompleteSegue", sender: self)
                    
                    
                }else{
                    
                    let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                        "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
            }
        }catch {
            
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            //present(alertController, animated: true, completion: nil)
            
            
            
        }
        
        return employee
        
    }
    
    @IBAction func do_ConfirmRegistration(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
