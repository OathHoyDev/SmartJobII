//
//  EmptyJobLoginViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 21/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredLoginViewController: UIViewController , UITextFieldDelegate{
    
    var logingFrom = ""
    
    let employeeHelper = EmployeeHelper()
    var employee = NSDictionary()
    
    @IBOutlet weak var loadingView: UIView!
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var moveConstraint = CGFloat()
    
    @IBOutlet weak var txPassword: UITextField!
    @IBOutlet weak var txLogin: UITextField!
    
    @IBOutlet weak var loginView: UIView!
    
    // Forget Password View
    @IBOutlet weak var forgetPasswordView: UIView!
    
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var personalId: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var verifiyIdButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var birthDateValue = ""
    
    var activeTextField : UITextField!
    
    var loginViewSize = CGSize()
    
    var isShowforgetPasswordView = false
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
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
        loginView.addDashedBorder(size: loginViewSize, color: ServiceConstant.ENABLE_LABEL_COLOR)
        checkLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        txLogin.delegate = self
        txPassword.delegate = self
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        birthDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        if activeTextField != nil {
            hideKeyboard(textField: activeTextField)
        }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
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
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        let date: Date = sender.date
        
        birthDate.text = dateFormatter.string(from: sender.date)
        birthDateValue = dateFormatter.string(from: sender.date)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard(textField: textField)
        return true
    }
    
    func hideKeyboard(textField : UITextField) {
        
        textField.resignFirstResponder()
        activeTextField = nil
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.frame.origin.y = 0
            
        })
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        employee = doLogin(userCode: txLogin.text!, password: txPassword.text!)
        
        if employee.count > 0 {
            
            let accountStatusArray = employee.object(forKey: "StatusList") as! NSMutableArray
            
            for object in accountStatusArray {
                
                let accountStatus = object as! NSDictionary
                
                if accountStatus.object(forKey: "FunctionCode") as! String == "02" {
            
                    let statusFlag = accountStatus.object(forKey: "StatusFlag") as! String
                    
                    //statusFlag = "01"
                    
                    switch statusFlag {
                        
                    case "01":
                        if employee.object(forKey: "OneAccountFlag") as! String == "false" {
                            
                            performSegue(withIdentifier: "InsuredOnePasswordSegue", sender: self)
                            
                        }else {
                            
                            checkLoginLevel(employee: employee)
                            
                        }
                    case "02" :
                        
                        let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                            "ท่านถูกระงับการใช้งานในส่วนของผู้ประกันตน", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil
                        ))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    case "03" :
                        let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                            "กรุณากรอกข้อมูลเพิ่มเติม เพื่อเข้าใช้งานระบบขึ้นทะเบียนผู้ประกันตน", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                            (action:UIAlertAction!) in
                            self.logout()
                            self.performSegue(withIdentifier: "InsuredProfileSegue", sender: self)
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    default:
                        break
                    }
                    
                }
                
            }
        }
        
    }
    
    func logout() {
        
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
    }
    
    func prepareTextField(){
        
        txLogin.setLeftPaddingPoints(10)
        txPassword.setLeftPaddingPoints(10)
        
        txLogin.setRightPaddingPoints(10)
        txPassword.setRightPaddingPoints(10)
        
        
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin {
            
            let userType = UserDefaults.standard.value(forKey: "userType") as? String
            
            if userType == "Employee" {
                let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
                let password = UserDefaults.standard.value(forKey: "password") as? String
                
                self.loadingView.isHidden = false
                
                dispatchQueue.async {
                    
                    self.employee = self.doLogin(userCode: usercode!, password: password!)
                    
                    
                    OperationQueue.main.addOperation() {
                        
                        self.loadingView.isHidden = true
                        
                        if self.employee.count > 0 {
                        
                            let accountStatusArray = self.employee.object(forKey: "StatusList") as! NSMutableArray
                            
                            for object in accountStatusArray {
                                
                                let accountStatus = object as! NSDictionary
                                
                                if accountStatus.object(forKey: "FunctionCode") as! String == "02" {
                                    
                                    let status = accountStatus.object(forKey: "StatusFlag") as! String
                                    
                                    switch status {
                                    case "01" :
                                        
                                        if self.employee.object(forKey: "OneAccountFlag") as! String == "false" {
                                            
                                            self.performSegue(withIdentifier: "InsuredOnePasswordSegue", sender: self)
                                            
                                        }else {
                                            
                                            self.checkLoginLevel(employee: self.employee)
                                            
                                        }
                                    case "02" :
                                        let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                                            "ท่านถูกระงับการใช้งานในส่วนของผู้ประกันตน กรุณาติดต่อเจ้าหน้าที่สำนักงานจัดหางาน", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                    case "03" :
                                        let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                                            "กรุณากรอกข้อมูลเพิ่มเติม เพื่อเข้าใช้งานระบบขึ้นทะเบียนผู้ประกันตน", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                                            (action:UIAlertAction!) in
                                            self.logout()
                                            self.performSegue(withIdentifier: "InsuredProfileSegue", sender: self)
                                            
                                        }))
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                    default :
                                        break
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            
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


                }else{
                    
                    let respMessage = resp["StatusMsg"] as! String
                    
                    employee = NSDictionary()
                
                    let alertController = UIAlertController(title: "", message:
                        "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                
                }
            }
        }catch {
            
            employee = NSDictionary()
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            appDelegate.employee = NSDictionary()
            appDelegate.usercode = ""
            
            UserDefaults.standard.setValue(nil, forKey: "usercode")
            UserDefaults.standard.setValue(nil, forKey: "password")
            UserDefaults.standard.set(false, forKey: "hasLogin")
            UserDefaults.standard.setValue(nil, forKey: "userType")
            UserDefaults.standard.synchronize()
            
            present(alertController, animated: true, completion: nil)
            
            
            
        }
    
        return employee
    
    }
    
    func checkLoginLevel(employee : NSDictionary){
        
        
        let registerFlag : String = employee.object(forKey: "RegisterFlag") as! String
        
        switch registerFlag {
        case "0":
            print("Case : 0")
        case "1":
            performSegue(withIdentifier: "InsuredReportDayListSegue", sender: self)
        case "2":
            performSegue(withIdentifier: "InsuredConfirmSegue", sender: self)
        default:
            break
            
        }
        
        
    
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        loginViewSize = loginView.frame.size
        
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        if(!isShowforgetPasswordView){
            
            forgetPasswordView.isHidden = false
            
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InsuredProfileSegue" {
        
            let view : InsuredProfileOrRegistrationViewController = segue.destination as! InsuredProfileOrRegistrationViewController
            
            view.employee = self.employee
        
        }
    }
    
    @IBAction func doForgetPassword(_ sender: Any) {
        
        birthDate.isHidden = false
        personalId.isHidden = false
        
        confirmPassword.isHidden = true
        newPassword.isHidden = true
        
        verifiyIdButton.isHidden = false
        changePasswordButton.isHidden = true
        
        forgetPasswordView.isHidden = false
        
        
    }
    
    @IBAction func doHideForgetPasswordView(_ sender: Any) {
        
        hideForgetPasswordView()
    }
    
    
    func hideForgetPasswordView(){
        
        birthDate.text = ""
        confirmPassword.text = ""
        personalId.text = ""
        newPassword.text = ""
        
        birthDate.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        personalId.resignFirstResponder()
        newPassword.resignFirstResponder()
        
        if activeTextField != nil {
            hideKeyboard(textField: activeTextField)
        }
        
        forgetPasswordView.isHidden = true
        
        
    }
    
    @IBAction func doVerifyPersonalId(_ sender: Any) {
        
        
        let response = doCheckChangePwd(usercode: personalId.text!, birthDate: birthDate.text!)
        
        if response.count > 0 {
        
            let responseStatus = response.object(forKey: "RespStatus") as! NSDictionary
            
            if responseStatus.object(forKey: "StatusID") as! NSNumber == 1 {
                
                birthDate.isHidden = true
                personalId.isHidden = true
                
                confirmPassword.isHidden = false
                newPassword.isHidden = false
                
                verifiyIdButton.isHidden = true
                changePasswordButton.isHidden = false
                
            }else{
                
                let alertController = UIAlertController(title: "ไม่สามารถกำหนดรหัสผ่านใหม่ได้", message:
                    "ข้อมูลที่ระบุไม่ตรงกับในฐานข้อมูล", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                    (action:UIAlertAction!) in
                    if self.activeTextField != nil {
                        self.hideKeyboard(textField: self.activeTextField)
                    }
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func doPrepareToChangePassword() {
        
        
        
    }
    
    func doCheckChangePwd(usercode : String , birthDate : String) -> NSDictionary{
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.employeeHelper.checkChangePassword(usercode: usercode, birthDate: birthDate)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                (action:UIAlertAction!) in
                if self.activeTextField != nil {
                    self.hideKeyboard(textField: self.activeTextField)
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
        
    }
    @IBAction func doChangePassword(_ sender: Any) {
        
        if (newPassword.text! == "" || confirmPassword.text! == "")  {
            
            let alertController = UIAlertController(title: "", message:
                "กรุณาตรวจสอบรหัสผ่านอีกครั้ง", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }else if (newPassword.text!.characters.count < 8)  {
            
            let alertController = UIAlertController(title: "", message:
                "กรุณารหัสผ่านอย่างน้อย 8 ตัวอีกษร", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }else if (newPassword.text! != confirmPassword.text!)  {
            
            let alertController = UIAlertController(title: "", message:
                "กรุณาระบุรหัสผ่านให้เหมือนกัน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else{
        
            var resp = NSDictionary()
            
            do{
                
                try resp = self.wsChangePassword(usercode: personalId.text!, password: newPassword.text!, birthDate: birthDateValue)
                
                if resp.count > 0 {
                    
                    let response = resp.object(forKey: "RespStatus") as! NSDictionary
                    
                    if response.object(forKey: "StatusID") as! NSNumber == 1 {
                        
                        let alertController = UIAlertController(title: "", message:
                            "เปลี่ยนรหัสผ่านสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                            
                            (action) -> Void in
                            
                            self.hideForgetPasswordView()
                            
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else {
                        
                        let alertController = UIAlertController(title: "เปลี่ยนรหัสผ่านไม่สำเร็จ", message:
                            "\(response.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                            
                            (action) -> Void in
                            
                            self.hideForgetPasswordView()
                            
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }catch {
                
                
                let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                    "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                    (action:UIAlertAction!) in
                    if self.activeTextField != nil {
                        self.hideKeyboard(textField: self.activeTextField)
                    }
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    func wsChangePassword(usercode : String , password : String , birthDate : String) -> NSDictionary{
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.employeeHelper.changePassword(usercode: usercode, password: password, birthDate: birthDate)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                (action:UIAlertAction!) in
                if self.activeTextField != nil {
                    self.hideKeyboard(textField: self.activeTextField)
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
        
    }

    
    
}
