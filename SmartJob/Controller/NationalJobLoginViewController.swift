//
//  NationalJobLoginViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 21/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalJobLoginViewController: UIViewController, UITextFieldDelegate {
    
    var logingFrom = ""
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgetPasswordText1: UITextField!
    
    @IBOutlet weak var txPassword: UITextField!
    @IBOutlet weak var txLogin: UITextField!
    @IBOutlet weak var forgetPasswordText2: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    
    var loginViewSize = CGSize()
    
    var isShowforgetPasswordView = false
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    
    let employeeHelper = EmployeeHelper()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    var employee = NSDictionary()

    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        loginViewSize = loginView.frame.size
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField()
        
        txLogin.delegate = self
        txPassword.delegate = self
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideKeyboard()
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        doLogin(txLogin.text!, withPassword: txPassword.text!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func prepareTextField(){
        
        txLogin.setLeftPaddingPoints(10)
        txPassword.setLeftPaddingPoints(10)
        
        txLogin.setRightPaddingPoints(10)
        txPassword.setRightPaddingPoints(10)
        
        
    }
    
    
    func doLogin(_ userCode : String , withPassword password: String) {
        
        
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
                    
                    checkNationalAccountStatus(resp : employee)
                    
                }else{
                    
                    let respMessage = resp["StatusMsg"] as! String
                    
                    employee = NSDictionary()
                    
                    let alertController = UIAlertController(title: "", message:
                        "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action : UIAlertAction!) in self.hideKeyboard()
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
            }
        }catch {
            
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                (action : UIAlertAction!) in self.hideKeyboard()
            }))
            
            //present(alertController, animated: true, completion: nil)
            
            
            
        }
        
    }
    
    func checkNationalAccountStatus(resp : NSDictionary) {
        
        let accountStatusArray = resp.object(forKey: "StatusList") as! NSMutableArray
        
        for object in accountStatusArray {
            
            let accountStatus = object as! NSDictionary
            
            if accountStatus.object(forKey: "FunctionCode") as! String == "03" {
                
                let status = accountStatus.object(forKey: "StatusFlag") as! String
                
                
                switch status {
                case "01" :
                    
                    let alertController = UIAlertController(title: "เข้าระบบสำเร็จ", message:
                        "เข้าระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action:UIAlertAction!) in self.checkDestinationAfterLogin()
                    }
                    ))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                case "02" :
                    
                    let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                        "ท่านถูกระงับการใช้งานในส่วนของงานต่างประเทศ กรุณาติดต่อเจ้าหน้าที่สำนักงานจัดหางาน", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action : UIAlertAction!) in self.hideKeyboard()
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                case "03" :
                    
                    let alertController = UIAlertController(title: "เข้าระบบสำเร็จ", message:
                        "เข้าระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action:UIAlertAction!) in self.checkDestinationAfterLogin()
                    }
                    ))
                    
                    self.present(alertController, animated: true, completion: nil)

                    
//                    let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
//                        "ขึ้นว่าไม่พบสถานะ ตามที่ออกแบบ ui", preferredStyle: UIAlertControllerStyle.alert)
//                    
//                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
//                        (action : UIAlertAction!) in self.hideKeyboard()
//                    }))
//                    
//                    self.present(alertController, animated: true, completion: nil)
                default :
                    break
                }
                
            }
            
        }
        
        
    }
    
    func checkDestinationAfterLogin() {
    
        let employee = appDelegate.employee
        
        if employee.object(forKey: "OneAccountFlag") as! String == "true" {
        
            performSegue(withIdentifier: "NationJobLoginCompleteSegue", sender: self)
        
        }else {
        
            performSegue(withIdentifier: "NationJobOnePasswordSegue", sender: self)
        
            
        }
    
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NationJobOnePasswordSegue" {
            let view : OnePasswordNationJobViewController = segue.destination as! OnePasswordNationJobViewController
            
            view.employee = employee
        }
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    
    func hideKeyboard() {
        
        txLogin.resignFirstResponder()
        
        txPassword.resignFirstResponder()
        
    }
    

}
