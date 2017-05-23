//
//  EmployerLoginViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/14/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployerLoginViewController: UIViewController , UIPickerViewDataSource ,UIPickerViewDelegate , UITextFieldDelegate {
    @IBOutlet weak var findStaffLabel: UILabel!
    @IBOutlet weak var findStaffHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userCodeTx: UITextField!
    @IBOutlet weak var branchIDTx: UITextField!
    @IBOutlet weak var passwordTx: UITextField!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UIButton!
    
    
    var branchPickerView = UIPickerView()
    var branchArray = NSMutableArray()
    var branch = NSDictionary()
    
    var employer = NSDictionary()
    
    let employerHelper = EmployerHelper()
    //let keychainWrapper = KeychainWrapper()
    
    var justLogin = false
    
    var isMove = false
    var activeTextField : UITextField!
    var moveView = CGFloat()
    
    var branchID = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var loadingView: UIView!
    
    func clearTextField() {
        
        userCodeTx.text = ""
        branchIDTx.text = ""
        passwordTx.text = ""
        branchID = ""
    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        branchIDTx.isUserInteractionEnabled = false
        branchIDTx.backgroundColor = UIColor.lightGray
        
        clearTextField()
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationController?.isNavigationBarHidden = false
        checkLogin()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            
            findStaffHeightConst.constant = 40
            
            findStaffLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb3?.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        }else{
            findStaffHeightConst.constant = 30
            
            findStaffLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb3?.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmployerLoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin {
            UIView.setAnimationsEnabled(false)
            performSegue(withIdentifier: "employerHomeSegue", sender: self)
        }else {
            appDelegate.employer = NSDictionary()
            appDelegate.usercode = ""
            UIView.setAnimationsEnabled(true)
        }
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNavigationItem()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 12
        let attributes = [NSParagraphStyleAttributeName : style]
        
        registerButton.titleLabel?.attributedText = NSAttributedString(string: ">> ลงทะเบียน <<", attributes:attributes)
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmployerLoginViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        branchPickerView.delegate = self
        branchPickerView.dataSource = self
        
        branchIDTx.inputView = branchPickerView
        
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.activeTextField = sender
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            let originTextFieldY = self.activeTextField.frame.origin.y + (self.activeTextField.superview!.frame.origin.y) + (self.activeTextField.superview!.superview!.frame.origin.y)
            //print(originTextFieldY)
            if let keyboardHeight:CGFloat = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height {
                if ((view.frame.size.height - originTextFieldY - view.frame.size.height * 0.1) < keyboardHeight) && !isMove {
                    moveView =  (keyboardHeight - (view.frame.size.height - originTextFieldY)) + (view.frame.size.height * 0.1)
//                    print("moveView : \(moveView)")
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.view.frame.origin.y = (self.view.frame.origin.y - self.moveView)
                    })
                    isMove = true
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branchArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let branch = branchArray.object(at: row) as! NSDictionary
        return branch["BranchName"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let branch = branchArray.object(at: row) as! NSDictionary
        branchIDTx.text = branch["BranchName"] as? String
        
        branchID = branch["BranchID"] as! String
    }
    
    func keyboardWillHide() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.userCodeTx.resignFirstResponder()
            self.branchIDTx.resignFirstResponder()
            self.passwordTx.resignFirstResponder()
            
            self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
        })
        moveView = 0;
        isMove = false
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        keyboardWillHide()
        
        if userCodeTx.text != "" {
            loadBranch(userCodeTx.text!)
            
            if branchArray.count > 0 {
                branchIDTx.isUserInteractionEnabled = true
                branchIDTx.backgroundColor = UIColor.white
            }else{
                branchIDTx.isUserInteractionEnabled = false
                branchIDTx.backgroundColor = UIColor.lightGray
            }
        }else{
            branchArray.removeAllObjects()
            branchIDTx.isUserInteractionEnabled = false
            branchIDTx.backgroundColor = UIColor.lightGray
        }

        
        
    }
    
    func loadBranch(_ userCode : String) {
        
        Thread.detachNewThreadSelector(#selector(EmployerLoginViewController.startIndicator), toTarget: self, with: nil)
        
        branchArray.removeAllObjects()
        
        let xmlStr = "<ws_employerBranchName xmlns='http://tempuri.org/'><userCode>\(userCode)</userCode></ws_employerBranchName>"
        
        var resp = NSDictionary()
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_LIST)
            
            loadingView.isHidden = true
            
            let response = resp["RespStatus"] as! NSDictionary
            
            if response["StatusID"] as! NSNumber == 1 {
                branchArray = resp["RespBody"] as! NSMutableArray
                branchIDTx.isUserInteractionEnabled = true
                branchIDTx.backgroundColor = UIColor.white
            }else if response["StatusID"] as! NSNumber == 4 {
                branchID = "0000"
                self.branch = NSMutableDictionary()
            }else if response["StatusID"] as! NSNumber == 2 {
                branchID = ""
                self.branch = NSMutableDictionary()
            }
            
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func login() -> Bool {
    
        if userCodeTx.text! != "" && passwordTx.text! != "" && branchID != "" {
            
            Thread.detachNewThreadSelector(#selector(EmployerLoginViewController.startIndicator), toTarget: self, with: nil)
            
            let userCode = userCodeTx.text!
            let password = passwordTx.text!
            let branchID = self.branchID
            
            
            var soapResp = NSDictionary()
            
            do{
                
                try soapResp = employerHelper.login(userCode, withPassword: password, withBranch: branchID)
                
                loadingView.isHidden = true
                
                if soapResp.count > 0 {
                    
                    let resp = soapResp["RespStatus"] as! NSDictionary
                    
                    if resp["StatusID"] as! NSNumber == 1 {
                        let respBody = soapResp["RespBody"] as! NSMutableArray
                        
                        if respBody.count > 0 {
                        
                            employer = respBody.object(at: 0) as! NSDictionary
                            
                            appDelegate.employer = employer
                            appDelegate.usercode = userCodeTx.text!
                            appDelegate.branch = self.branch
                            
                            UserDefaults.standard.setValue(userCode, forKey: "usercode")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            UserDefaults.standard.setValue(branchID, forKey: "branchID")
                            UserDefaults.standard.set(true, forKey: "hasLogin")
                            UserDefaults.standard.setValue("Employer", forKey: "userType")
                            UserDefaults.standard.synchronize()
                             
                            justLogin = true

                            
                            return true
                            
                        }else{
                            let alertController = UIAlertController(title: "", message:
                                "กรุณากรอกรหัสผู้ใช้งานให้ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                            
                            present(alertController, animated: true, completion: nil)
                            
                            return false

                        }
                        
                    }else {
                        let alertController = UIAlertController(title: "", message:
                            "กรุณากรอกรหัสผู้ใช้งานให้ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                        
                        present(alertController, animated: true, completion: nil)
                        
                        return false
                    }
                    
                }else {
                    let alertController = UIAlertController(title: "", message:
                        "กรุณากรอกรหัสผู้ใช้งานให้ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                    return false
                }
                
                
                
            }catch {
                
                loadingView.isHidden = true
                
                let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                    "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
                
                return false
            }
            
        }else{
            
            let alertController = UIAlertController(title: "ใส่ข้อมูลไม่ครบ !", message:
                "กรุณาใส่ข้อมูลให้ครับถ้วน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)

            
            return false
        }
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "employerHomeSegue"){
            
            let loginResult = login()
            
            if loginResult {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        //navigationController?.popViewControllerAnimated(true)
        login()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController:EmployerHomeViewController = segue.destination as! EmployerHomeViewController
        viewController.employer = employer
        viewController.branch = branch
        viewController.justLogin = justLogin
        
    }
    
    @IBAction func linkToWebsite(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string:"http://smartjob.doe.go.th/RegistrationEmployer.aspx")!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField.tag {
        
        case 1 :
            branchArray.removeAllObjects()
            loadBranch(userCodeTx.text!)
            
            branchIDTx.becomeFirstResponder()
            
        case 2 :
            passwordTx.becomeFirstResponder()
            
        default :
            textField.resignFirstResponder()
            
        }
        
        keyboardWillHide()
        
        return true
    }
    
    func nextPicker() {
        
        branchIDTx.resignFirstResponder()
        passwordTx.becomeFirstResponder()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            
            branchIDTx.text = ""
        
        }else if textField.tag == 2 {
        
            let toolbar = UIToolbar()
            toolbar.barStyle = UIBarStyle.default
            toolbar.sizeToFit()
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployerLoginViewController.nextPicker))
            
            toolbar.setItems([spaceButton , nextButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            
            textField.inputAccessoryView = toolbar
            
            loadBranch(userCodeTx.text!)
            if branchArray.count > 0 {
                let branch = branchArray.object(at: 0) as! NSDictionary
                textField.text = branch["BranchName"] as? String
                
                branchID = (branch["BranchID"] as? String)!
                
                self.branch = branch
            }
        
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
            
            if newString.length == maxLength {
                loadBranch(newString as String)
            }
            
            //
            
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
    
    
}
