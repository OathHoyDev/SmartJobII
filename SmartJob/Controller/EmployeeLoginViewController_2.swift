//
//  EmployeeLoginViewController_2.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/30/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeLoginViewController_2: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var userCodeTx: UITextField!
    @IBOutlet weak var passwordTx: UITextField!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var findJobLabel: UILabel!
    
    var employee = NSDictionary()
    var employeeDetail = NSDictionary()
    
    let employeeHelper = EmployeeHelper()
    //let keychainWrapper = KeychainWrapper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var justLogin = false
    
    var isMove = false
    var activeTextField : UITextField!
    var moveView = CGFloat()
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()

    // Remember Password
    @IBOutlet weak var forgetPasswordView: UIView!
    
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var personalId: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var verifiyIdButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var birthDateValue = ""
    
    func clearTextField() {
        userCodeTx.text = ""
        passwordTx.text = ""
    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        self.userCodeTx.resignFirstResponder()
        self.passwordTx.resignFirstResponder()
        
        clearTextField()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            findJobLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        }else{
            findJobLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(EmployeeLoginViewController_2.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkLogin()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmployeeLoginViewController_2.tap(_:)))
        view.addGestureRecognizer(tapGesture)
//        forgetPasswordView.addGestureRecognizer(tapGesture)
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        birthDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)

    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        let date: Date = sender.date
    
        
        birthDate.text = dateFormatter.string(from: sender.date)
        birthDateValue = dateFormatter.string(from: sender.date)
        
    }
    
    func checkLogin() {
        
        var employeeID = ""
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if let value = appDelegate.employee.object(forKey: "EmployeeID") as? String {
            employeeID = value
        }
        
        if hasLogin && employeeID != "" {
            UIView.setAnimationsEnabled(false)
            performSegue(withIdentifier: "employeeHomeSegue", sender: self)
        }else {
            self.navigationItem.backBarButtonItem?.title = "Back"
            appDelegate.employee = NSDictionary()
            appDelegate.usercode = ""
            UIView.setAnimationsEnabled(true)
            setNavigationItem()
        }
        
    }
    
    
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.activeTextField = sender
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        keyboardWillShow(textField: textField)
        return true
    }
    
    func keyboardWillShow(textField : UITextField) {
        
        let textfieldFrampoint = textField.superview?.convert(textField.frame.origin, to: nil)
        
        let centerY = screenHeight*0.4
        
        
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
        
        if activeTextField != nil {
            hideKeyboard(textField: activeTextField)
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if userCodeTx.text == "" || passwordTx.text == "" {
            let alertController = UIAlertController(title: "", message:
                "กรุณากรอกรหัสผู้ใช้งานหรือรหัสผ่านให้ครบถ้วน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil ))
            
            present(alertController, animated: true, completion: nil)
        }
        
        else if passwordTx.text != "" && (passwordTx.text?.characters.count)! < 8 {
        
            let alertController = UIAlertController(title: "", message:
                "กรุณากรอกรหัสผ่านให้ครบ 8 ตัวอักษร", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil ))
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            login()
        }
    }
    
    func login() {
        
        let userCode = "\(userCodeTx.text!)"
        let password = "\(passwordTx.text!)"
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeLoginViewController_2.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = employeeHelper.login(userCode, withPassword: password)
            
            loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                if resp["StatusID"] as! NSNumber == 1 {
                    let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    
                    employee = respBody.object(at: 0) as! NSDictionary
                    
                    appDelegate.employee = employee
                    appDelegate.usercode = userCodeTx.text!
                    
                    UserDefaults.standard.setValue(userCode, forKey: "usercode")
                    UserDefaults.standard.setValue(password, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "hasLogin")
                    UserDefaults.standard.setValue("Employee", forKey: "userType")
                    UserDefaults.standard.synchronize()
                    
                    justLogin = true
                    
                    checkSmartJobAccountStatus(resp: employee)
                    
                    
                }else {
                    
                    let respMessage = resp["StatusMsg"] as! String
                    
                    employee = NSDictionary()
                    
                    let alertController = UIAlertController(title: "", message:
                        "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action:UIAlertAction!) in
                        
                        if self.activeTextField != nil {
                            self.hideKeyboard(textField: self.activeTextField)
                        }
                    }))
                    
                    present(alertController, animated: true, completion: nil)

                    
                }
                
            }else{
                
                let alertController = UIAlertController(title: "", message:
                    "กรุณาลองใหม่อีกครั้ง", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                    (action:UIAlertAction!) in
                    if self.activeTextField != nil {
                        self.hideKeyboard(textField: self.activeTextField)
                    }
                }))
                
                present(alertController, animated: true, completion: nil)
            
            }
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                (action:UIAlertAction!) in
                if self.activeTextField != nil {
                    self.hideKeyboard(textField: self.activeTextField)
                }
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func checkSmartJobAccountStatus(resp : NSDictionary) {
        
        let accountStatusArray = resp.object(forKey: "StatusList") as! NSMutableArray
        
        for object in accountStatusArray {
            
            let accountStatus = object as! NSDictionary
            
            if accountStatus.object(forKey: "FunctionCode") as! String == "01" {
                
                let status = accountStatus.object(forKey: "StatusFlag") as! String
                
                
                switch status {
                case "01" :
                    
                    let alertController = UIAlertController(title: "เข้าระบบสำเร็จ", message:
                        "เข้าระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action:UIAlertAction!) in
                        
                        if self.employee["OneAccountFlag"] as! String == "true" {
                            self.performSegue(withIdentifier: "employeeHomeSegue", sender: self)
                        }else{
                            self.performSegue(withIdentifier: "OnePasswordSegue", sender: self)
                        }
                    
                    }
                    ))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                case "02" :
                    
                    let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                        "ท่านถูกระงับการใช้งานในส่วนของการหางาน กรุณาติดต่อเจ้าหน้าที่สำนักงานจัดหางาน", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action : UIAlertAction!) in
                        if self.activeTextField != nil {
                            self.hideKeyboard(textField: self.activeTextField)
                        }
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                case "03" :
                    
                    let alertController = UIAlertController(title: "", message:
                        "กรุณากรอกข้อมูลเพิ่มเติมเพื่อเข้าใช้งานระบบหางาน", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action:UIAlertAction!) in
                        self.performSegue(withIdentifier: "EmployeeRegisterSegue", sender: self)
                    }
                    ))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                default :
                    break
                }
                
            }
            
        }
        
        
    }

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Thread.detachNewThreadSelector(#selector(EmployeeLoginViewController_2.startIndicator), toTarget: self, with: nil)
        
        if segue.identifier == "EmployeeRegisterSegue" {
            let viewController:EmployeeProfileOrRegisterViewController = segue.destination as! EmployeeProfileOrRegisterViewController
            
            viewController.pageType = ServiceConstant.EMPLOYEE_PROFILE_PAGE_TYPE_REGISTER
        }else if segue.identifier == "employeeHomeSegue" {
            let viewController:EmployeeHomeViewController_2 = segue.destination as! EmployeeHomeViewController_2
            
            viewController.justLogin = justLogin
        }else if segue.identifier == "OnePasswordSegue" {
        
            let view : SmartJobOnePasswordViewController = segue.destination as! SmartJobOnePasswordViewController
            
            view.employee = employee
        
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool
    {
        if textField == userCodeTx {
            let maxLength = 13
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
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
        
        if personalId.text! != "" && birthDate.text! != "" {
            
            
            let response = doCheckChangePwd(usercode: personalId.text!, birthDate: birthDate.text!)
            
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
            
        }else {
        
            let alertController = UIAlertController(title: "", message:
                "กรุณากรอกข้อมูลให้ครบถ้วน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
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
