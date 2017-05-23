//
//  EmptyJobRegulationViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 29/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredRegulationViewController: UIViewController , UITextFieldDelegate {
    
    var smartjobLogoViewSize = CGSize()
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var regulationView: UIView!
    
    @IBOutlet weak var inputIdView: UIView!
   
    var isConfirmRegulation = false
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var lacerCode: UITextField!
    
    @IBOutlet weak var btRadioConfirm: UIButton!
    @IBOutlet weak var radioConfirm: UIButton!
    @IBOutlet weak var btConfirm: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var lbSampleInput2: UILabel!
    @IBOutlet weak var lbSampleInput: UILabel!
    @IBOutlet weak var lbRegulationDetail: UITextView!
    @IBOutlet weak var lbRegulation: UILabel!
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    
    
    @IBOutlet weak var btOK: UIButton!
    var imageRadioCheck : UIImage = UIImage(named:"radio_check")!
    
    var imageRadioUncheck : UIImage = UIImage(named:"radio_uncheck")!
    
    var lacerCodeId = ""
    
    var isSideMenuShow = false
    
    var employee = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let empuiHelper = EmpuiHelper()
    let egaHelper = EGAHelper()
    
    @IBOutlet weak var sideMenuView: UIView!
    
    // SideMenu outlet
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var smartJobLb: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var employeeProfileBt: UIButton!
    @IBOutlet weak var logoutBt: UIButton!
    @IBOutlet weak var loginBt: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        
        btOK.isEnabled = false
        btOK.alpha = 0.5
        
        isConfirmRegulation = false
        
//        inputIdView.isHidden = true
//        
//        blackView.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doCheckLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLacerCodeForUpdate()

    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func hideKeyboard() {
        
        lacerCode.resignFirstResponder()
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.frame.origin.y = 0
            
        })
    }
    
    @IBAction func doCancelUpdateLacerCode(_ sender: Any) {
        inputIdView.isHidden = true
        blackView.isHidden = true
        
        doLogout(self)
    }
    @IBAction func doUpdateLacerCode(_ sender: Any) {
        
        if let lasercode = lacerCode.text {
        
            if lasercode != "" && lacerCode.text?.characters.count == 12  {
                
                doCheckProfileBeforeUpdateLasercode(laserCode: lacerCode.text!)
                
            }else{
                let alertController = UIAlertController(title: "", message:
                    "ระบุเลขเลเซอร์หลังบัตรไม่ครบ 12 ตำแหน่ง", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                (action) in self.checkLacerCodeForUpdate()
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    @IBAction func doBackPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func checkLacerCodeForUpdate() {
    
        employee = appDelegate.employee
        
        if employee.object(forKey: "EmpuiLaserCode") as! String == "00000000" {
        
            inputIdView.isHidden = false
            blackView.isHidden = false
        
        }else{
            inputIdView.isHidden = true
            blackView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareLayout() {
    
//        imRadioCancel
//        imRadioConfirm
        btRadioConfirm.setFontSize()
        btConfirm.setFontSize()
        btCancel.setFontSize()
        lbSampleInput2.setFontSize()
        lbSampleInput.setFontSize()
        lbRegulationDetail.setFontSize()
        lbRegulation.setFontSize()
        lacerCode.setFontSize()
        
        lacerCode.setLeftPaddingPoints(10)
        lacerCode.setRightPaddingPoints(10)
        
        


    
    }
    
    @IBAction func actionConfirmRegulation(_ sender: Any) {
        
        isConfirmRegulation = true
        
        radioConfirm.setBackgroundImage(#imageLiteral(resourceName: "radio_check"), for: .normal)
        
        btOK.isEnabled = true
        btOK.alpha = 1

    }
  
    
    @IBAction func confirmInputId(_ sender: Any) {
        
        inputIdView.isHidden = true
        blackView.isHidden = true
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if (!isSideMenuShow){
            sideMenu(true)
        }else{
            sideMenu(false)
        }
        
    }
    
    func sideMenu(_ action : Bool){
        
        if (action){
            sideMenuView.isHidden = false
            sideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            isSideMenuShow = true
        }else{
            sideMenuLeadingConstraint.constant = -sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            sideMenuView.isHidden = true
            isSideMenuShow = false
        }
    }
    
    func doCheckProfileBeforeUpdateLasercode(laserCode : String) {
    
        let citizenId = employee.object(forKey: "PersonalID") as! String
        let firstName = employee.object(forKey: "EmpuiFirstname") as! String
        let lastName = employee.object(forKey: "EmpuiLastname") as! String
        var bebBirthDate = employee.object(forKey: "EmpuiBirthDate") as! String
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        let gregorianDate = dateFormatter.date(from: bebBirthDate)
        
        dateFormatter.calendar = Calendar(identifier: .buddhist)
        
        bebBirthDate = dateFormatter.string(from: gregorianDate!)
        
        bebBirthDate = bebBirthDate.replacingOccurrences(of: "-", with: "")
        
        let profile = ["CitizenID" : citizenId ,
                       "FirstName" : firstName ,
                       "LastName" : lastName ,
                       "BEBirthDate" : bebBirthDate ,
                       "LaserCode" : laserCode
        ]
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            do {
                
                let tokenResp = try self.egaHelper.getTokenByCitizenIDForLaserCode(citizenId)
                
                if tokenResp.count > 0 {
                    
                    if let token = tokenResp["Result"] as? String {
                
                        try resp = self.egaHelper.checkLacerCodeByProfile(profile: profile as NSDictionary , withToken: token)
                        
                    }
                    
                }
                
                
            }catch {
                
                let alertController = UIAlertController(title: "", message:
                    "ไม่สามารถแก้ไขเลขเลเซอร์หลังบัตรประชาชนได้", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                    (action) in self.checkLacerCodeForUpdate()
                }
                ))
                
                self.present(alertController, animated: true, completion: nil)

                
            }
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                if let result = resp["Result"] as? Bool {
                
                    if result == true {
                        
                        self.updateLacerCode(laserCode: laserCode)
                        
                    }else {
                        
                        let alertController = UIAlertController(title: "", message:
                            "ไม่สามารถแก้ไขเลขเลเซอร์หลังบัตรประชาชนได้", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                            (action) in self.checkLacerCodeForUpdate()
                        }
                        ))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                }else{
                    
                    
                    let alertController = UIAlertController(title: "", message:
                        "LaserCode ไม่ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action) in self.checkLacerCodeForUpdate()
                    }
                    ))
                    
                    self.present(alertController, animated: true, completion: nil)
                
                }
            }
        }
    
    }
    
    func updateLacerCode(laserCode : String) {
    
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            do {
            
                try resp = self.empuiHelper.updateLaserCode(memberId: self.employee.object(forKey: "EmpuiMemberID") as! String, nationalId: self.employee.object(forKey: "PersonalID") as! String, laserCode: laserCode)
                
                
                
            }catch {
                
                
            
            }
            
            OperationQueue.main.addOperation() {
                
                let updateRespStatus = resp["RespStatus"] as! NSDictionary
                
                if updateRespStatus["StatusID"] as! NSNumber == 1 {
                    
                    let alertController = UIAlertController(title: "", message:
                        "แก้ไขเลขเลเซอร์หลังบัตรประชาชนเรียบร้อย", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action) in self.hideKeyboard()
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }else {
                
                    let alertController = UIAlertController(title: "ไม่สามารถแก้ไขเลขเลเซอร์หลังบัตรประชาชนได้", message:
                        "\(updateRespStatus["StatusMsg"] as! String)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                        (action) in self.checkLacerCodeForUpdate()
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                
                }
                
                self.loadingView.isHidden = true
                
                self.inputIdView.isHidden = true
                self.blackView.isHidden = true
            }
        }

    
    }
    
    func doCheckLogin () {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin {
            
            sideMenuDetail(isLogin: true)
            
        }else {
            
            sideMenuDetail(isLogin: false)
            
        }
        
    }
    
    func sideMenuDetail(isLogin : Bool){
        
        
        
        if (isLogin) {
            
            let employee = appDelegate.employee
            
            loginBt.isHidden = true
            logoutBt.isHidden = false
            employeeProfileBt.isHidden = false
            
            smartJobLb.isHidden = true
            employeeNameLb.isHidden = false
            
            if let value = employee.object(forKey: "EmployeeFullName") as? String {
                employeeNameLb.text = value
            }else{
                employeeNameLb.text = ""
            }
            
            logoImage.image = UIImage(named : "Image_Cartoon_Employee")
            
            
            
        }else {
            
            loginBt.isHidden = false
            logoutBt.isHidden = true
            employeeProfileBt.isHidden = true
            
            smartJobLb.isHidden = false
            employeeNameLb.isHidden = true
            
            logoImage.image = UIImage(named : "logoOnly")
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "InsureRegisInsureSegue" {
        
            if isConfirmRegulation {
            
                return true
            
            }else {
            
                let alertController = UIAlertController(title: "", message:
                    "กรุณากดยืนยันข้อตกลง", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)

                return false
            
            }
        
        }else {
        
            return true
        
        }
    }
    
    @IBAction func doLogout(_ sender: Any) {
        
        inputIdView.isHidden = true
        blackView.isHidden = true
        
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        let alertController = UIAlertController(title: "ออกจากระบบสำเร็จ", message:
            "ออกจากระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
            self.performSegue(withIdentifier: "InsuredLogoutSegue", sender: self)
            self.sideMenuDetail(isLogin: false)
            self.sideMenu(false)
            
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}
