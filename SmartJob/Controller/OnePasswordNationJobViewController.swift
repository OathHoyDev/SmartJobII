//
//  OnePasswordNationJobViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 23/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class OnePasswordNationJobViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var passwordLb: UITextField!
    @IBOutlet weak var confirmPasswordLb: UITextField!
    @IBOutlet weak var getCurrentPasswordBt: UIButton!
    @IBOutlet weak var cancelBt: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let employeeHelper = EmployeeHelper()
    
    var employee = NSDictionary()
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()


    override func viewDidLoad() {
        super.viewDidLoad()

        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        employee = appDelegate.employee
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doGetCurrentPassword(_ sender: Any) {
        
        passwordLb.text = UserDefaults.standard.value(forKey: "password") as? String
        
        confirmPasswordLb.text = UserDefaults.standard.value(forKey: "password") as? String
        
        getCurrentPasswordBt.isHidden = true
        
    }
    
    @IBAction func doChangePassword(_ sender: Any) {
        
        if passwordLb.text == confirmPasswordLb.text {
            
            let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
            
            var birthDate = ""
            
            if let smartJobBirthDate = employee.object(forKey: "SmartJobBirthDate") as? String {
                if smartJobBirthDate == "" {
                    
                    if let empuiBirthDate = employee.object(forKey: "EmpuiBirthDate") as? String {
                        
                        if empuiBirthDate == "" {
                            
                            let dateFormatter = DateFormatter()
                            let date = Date()
                            
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            birthDate = dateFormatter.string(from: date)
                            
                        }else {
                            birthDate = empuiBirthDate
                        }
                        
                    }
                    
                    
                }else {
                    
                    birthDate = smartJobBirthDate
                    
                }
            }
            
            let resp = doChangePassword(usercode: usercode! , password: passwordLb.text! , birthDate : birthDate)
            
//            let resp = doChangePassword(usercode: usercode! , password: passwordLb.text!)
            
            let respStatus = resp.object(forKey: "RespStatus") as! NSDictionary
            
            if respStatus.object(forKey: "StatusID") as! Int == 1 {
            
                let alertController = UIAlertController(title: "เปลี่ยนรหัสผ่านสำเร็จ", message:
                    "เปลี่ยนรหัสผ่านสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                    (action:UIAlertAction!) in self.performSegue(withIdentifier: "NationJobOnePasswordCompleteSegue", sender: self)
                }
))
                
                present(alertController, animated: true, completion: nil)
            
            }else {
            
                let alertController = UIAlertController(title: "เปลี่ยนรหัสผ่านไม่สำเร็จ", message:
                    "\(respStatus.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
            
            }
            
        }else {
        
            let alertController = UIAlertController(title: "ไม่สามารถเปลี่ยนรหัสผ่านได้", message:
                "ยืนยันรหัสผ่านไม่ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    func doChangePassword(usercode : String , password : String , birthDate : String) -> NSDictionary {
    
        var resp = NSDictionary()
        
        do{
            
            try resp = self.employeeHelper.changePassword(usercode: usercode, password: password, birthDate: employee.object(forKey: "SmartJobBirthDate") as! String)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
    
    }
    
    func doGetEmployeeDetail(employeeId : String) -> NSDictionary{
        
        var resp = NSDictionary()
        var profileResp = NSDictionary()
        
        do{
            
            try resp = self.employeeHelper.getEmployeeDetail(withEmployeeID: employeeId)
            
            let employeeProfileStatus = resp.object(forKey: "RespStatus") as! NSDictionary
            
            if employeeProfileStatus.object(forKey: "StatusID") as! Int == 1 {
                
                let employeeProfileResp = resp.object(forKey: "RespBody") as! NSMutableArray
                
                
                
                profileResp = employeeProfileResp.object(at: 0) as! NSDictionary
                
            }
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return profileResp

        
    }
    
    @IBAction func doLogout(_ sender: Any) {
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        performSegue(withIdentifier: "NationJobCancelLoginSegue", sender: self)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        keyboardWillShow(textField: textField)
        return true
    }
    
    func keyboardWillShow(textField : UITextField) {
        
        let textfieldFrampoint = textField.superview?.convert(textField.frame.origin, to: nil)
        
        let centerY = screenHeight*0.5
        
        
        if (textfieldFrampoint?.y)! > centerY {
            moveConstraint = (textfieldFrampoint?.y)! - centerY
            
        }else {
            moveConstraint = 0
            
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.frame.origin.y = 0 - CGFloat(self.moveConstraint)
            
            
        })
        
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
                return true
    }
    
    func hideKeyboard() {
        
        passwordLb.resignFirstResponder()
        confirmPasswordLb.resignFirstResponder()
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.frame.origin.y = 0
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    
    
}
