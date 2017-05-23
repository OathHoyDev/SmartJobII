//
//  EmployeeProfileOrRegisterViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/23/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeProfileOrRegisterViewController: UIViewController , UITextFieldDelegate , UIPickerViewDataSource ,UIPickerViewDelegate {
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var logoutButt: UIBarButtonItem!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var idLb: UITextField!
    @IBOutlet weak var titleLb: UITextField!
    @IBOutlet weak var nameLb: UITextField!
    @IBOutlet weak var surnameLb: UITextField!
    @IBOutlet weak var birthDayLb: UITextField!
    @IBOutlet weak var sexLb: UITextField!
    @IBOutlet weak var provinceLb: UITextField!
    @IBOutlet weak var amphoeLb: UITextField!
    @IBOutlet weak var tambonLb: UITextField!
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var usernameLb: UITextField!
    @IBOutlet weak var passwordLb: UITextField!
    @IBOutlet weak var positionLb: UITextField!
    @IBOutlet weak var suggestJobLb: UITextField!
    @IBOutlet weak var degreeLb: UITextField!
    @IBOutlet weak var departmentLb: UITextField!
    
    @IBOutlet weak var addressNoLb: UITextField!
    @IBOutlet weak var zipcodeLb: UITextField!
    @IBOutlet weak var jobProvinceLb: UITextField!
    
    
    @IBOutlet weak var loadingView: UIView!
    
    var activeTextField : UITextField!
    
    var employeeProfile = NSMutableDictionary()
    var memberDataDict = NSMutableDictionary()
    
    var usercode = ""
    var userID = ""
    
    var pageType = ""
    var moveView = CGFloat()
    var isMove = false
    //var keyboardHeight = CGFloat()
    
    @IBOutlet weak var confirmButt: UIButton!
    
    var titlePickerView = UIPickerView()
    var birthDayPickerView = UIPickerView()
    var birthMonthPickerView = UIPickerView()
    var birthYearPickerView = UIPickerView()
    var sexPickerView = UIPickerView()
    var provincePickerView = UIPickerView()
    var amphoePickerView = UIPickerView()
    var tambonPickerView = UIPickerView()
    var degreePickerView = UIPickerView()
    var departmentPickerView = UIPickerView()
    var suggestJobPickerView = UIPickerView()
    
    var jobProvincePickerView = UIPickerView()
    
    var titleID = ""
    var birthDate = [0,0,0]
    var sexID = ""
    var provinceID = ""
    var amphoeID = ""
    var tambonID = ""
    var degreeID = ""
    var departmentID = ""
    var jobPositionID = ""
    var jobPositionSuggestName = ""
    var jobPosition = ""
    
    var jobProvinceId = ""
    
    var isSearchSuggestJob = false
    
    var titleArray = NSMutableArray()
    var sexArray = NSMutableArray()
    var provinceArray = NSMutableArray()
    var amphoeArray = NSMutableArray()
    var tambonArray = NSMutableArray()
    var degreeArray = NSMutableArray()
    var departmentArray = NSMutableArray()
    var dayArray = NSMutableArray()
    var yearArray = NSMutableArray()
    var monthArray = NSMutableArray()
    var suggestJobArray = NSMutableArray()
    
    var birthDateArray : [NSMutableArray] = []
    
    var jobProvinceArray = NSMutableArray()
    
    let empuiHelper = EmpuiHelper()
    let employerHelper = EmployerHelper()
    let employeeHelper = EmployeeHelper()
    let masterDataHelper = MasterDataHelper()
    let memberHelper = MemberHelper()
    let egaHelper = EGAHelper()
    //let keychainWrapper = KeychainWrapper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    func hideKeyboard(){
        
        
        
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.idLb.resignFirstResponder()
                self.titleLb.resignFirstResponder()
                self.nameLb.resignFirstResponder()
                self.surnameLb.resignFirstResponder()
                self.birthDayLb.resignFirstResponder()
                self.sexLb.resignFirstResponder()
                self.provinceLb.resignFirstResponder()
                self.amphoeLb.resignFirstResponder()
                self.tambonLb.resignFirstResponder()
                self.phoneLb.resignFirstResponder()
                self.passwordLb.resignFirstResponder()
                self.positionLb.resignFirstResponder()
                self.suggestJobLb.resignFirstResponder()
                self.degreeLb.resignFirstResponder()
                self.departmentLb.resignFirstResponder()
                
                self.addressNoLb.resignFirstResponder()
                self.zipcodeLb.resignFirstResponder()
                self.jobProvinceLb.resignFirstResponder()
                
                
                self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
            })
            moveView = 0;
            isMove = false
            
        
        
        
        
    }
    
    func setNavigationItem(_ title : String) {
        
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
        
        label.attributedText = NSAttributedString(string: title , attributes:attributes)
        
        
        self.navigationItem.titleView = label
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if textField == idLb {
            let maxLength = 13
            let currentString: NSString = textField.text! as NSString
            
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            if newString.length == maxLength {
                hideKeyboard()
                showCitizenDetail(newString as String)
            }
            
            
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...31  {
            self.dayArray.insert("\(i)", at: i-1)
        }
        
        let calendar = Calendar.current
        let currentYearInt = ((calendar as NSCalendar).component(NSCalendar.Unit.year, from: Date())) + 543
        
        for i in 2500...currentYearInt {
            self.yearArray.insert("\(i)", at: i-2500)
        }
        
        self.monthArray.insert("มกราคม", at: 0)
        self.monthArray.insert("กุมภาพันธ์", at: 1)
        self.monthArray.insert("มีนาคม", at: 2)
        self.monthArray.insert("เมษายน", at: 3)
        self.monthArray.insert("พฤษภาคม", at: 4)
        self.monthArray.insert("มิถุนายน", at: 5)
        self.monthArray.insert("กรกฎาคม", at: 6)
        self.monthArray.insert("สิงหาคม", at: 7)
        self.monthArray.insert("กันยายน", at: 8)
        self.monthArray.insert("ตุลาคม", at: 9)
        self.monthArray.insert("พฤศจิกายน", at: 10)
        self.monthArray.insert("ธันวาคม", at: 11)
        
        birthDateArray = [ dayArray , monthArray , yearArray ]
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmployeeProfileOrRegisterViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        preparePickerView()
    }
    
    func preparePickerView(){
        
        titlePickerView.dataSource = self
        birthDayPickerView.dataSource = self
        birthMonthPickerView.dataSource = self
        birthYearPickerView.dataSource = self
        sexPickerView.dataSource = self
        provincePickerView.dataSource = self
        amphoePickerView.dataSource = self
        tambonPickerView.dataSource = self
        degreePickerView.dataSource = self
        departmentPickerView.dataSource = self
        suggestJobPickerView.dataSource = self
        jobProvincePickerView.dataSource = self
        
        titlePickerView.delegate = self
        birthDayPickerView.delegate = self
        birthMonthPickerView.delegate = self
        birthYearPickerView.delegate = self
        sexPickerView.delegate = self
        provincePickerView.delegate = self
        amphoePickerView.delegate = self
        tambonPickerView.delegate = self
        degreePickerView.delegate = self
        departmentPickerView.delegate = self
        suggestJobPickerView.delegate = self
        jobProvincePickerView.delegate = self
        
        
        titleLb.inputView = titlePickerView
        birthDayLb.inputView = birthDayPickerView
        sexLb.inputView = sexPickerView
        provinceLb.inputView = provincePickerView
        amphoeLb.inputView = amphoePickerView
        tambonLb.inputView = tambonPickerView
        degreeLb.inputView = degreePickerView
        departmentLb.inputView = departmentPickerView
        jobProvinceLb.inputView = jobProvincePickerView
        
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            resp = try masterDataHelper.getTitleName()
            
            if let value = resp["RespBody"] as? NSMutableArray {
                titleArray = value
            }
            
            sexArray = masterDataHelper.getSexList()
            
            resp = try masterDataHelper.getProvince()
            
            if let value = resp["RespBody"] as? NSMutableArray{
                provinceArray = value
            }
            
            resp = try masterDataHelper.getEducation()
            
            if let value = resp["RespBody"] as? NSMutableArray {
                degreeArray = value
            }
            
            resp = try empuiHelper.getProvince()
            
            if let value = resp["RespBody"] as? NSMutableArray {
                jobProvinceArray = value
            }
            
            loadingView.isHidden = true
            
            
        }catch{
            
            loadingView.isHidden = true
            
            
            
        }
        
    }
    
    func prepareMemberDictionary(){
        
        memberDataDict.setValue(idLb.text!, forKey: "personalID")
        memberDataDict.setValue(passwordLb.text!, forKey: "password")
        memberDataDict.setValue(surnameLb.text!, forKey: "lastName")
        memberDataDict.setValue(phoneLb.text!, forKey: "telephone")
        memberDataDict.setValue(sexID, forKey: "sex")
        memberDataDict.setValue(titleID, forKey: "prefixID")
        memberDataDict.setValue(birthDate, forKey: "birthDate")
        memberDataDict.setValue(provinceID, forKey: "provinceID")
        memberDataDict.setValue(positionLb.text!, forKey: "requestPosition")
        memberDataDict.setValue(jobPositionID, forKey: "jobPositionID")
        memberDataDict.setValue(positionLb.text!, forKey: "jobPosition")
        memberDataDict.setValue(degreeID, forKey: "degreeID")
        memberDataDict.setValue(departmentID, forKey: "departmentID")
        memberDataDict.setValue(addressNoLb.text!, forKey: "addrNumber")
        memberDataDict.setValue(zipcodeLb.text!, forKey: "zipCode")
        memberDataDict.setValue(jobProvinceId, forKey: "workProvinceID")
        
        
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight:CGFloat = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height {
//                if ((view.frame.size.height - self.activeTextField.frame.origin.y - view.frame.size.height * 0.1) < keyboardHeight) && !isMove {
//                    moveView =  (keyboardHeight - (view.frame.size.height - self.activeTextField.frame.origin.y)) + (view.frame.size.height * 0.1)
//                    //                    print("moveView : \(moveView)")
//                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
//                        self.view.frame.origin.y = (self.view.frame.origin.y - self.moveView)
//                    })
//                    isMove = true
//                }
                if ((self.activeTextField.frame.origin.y) > keyboardHeight) && !isMove {
                    moveView =  (keyboardHeight - (self.activeTextField.superview?.frame.origin.y)!)
                        //                    print("moveView : \(moveView)")
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.view.frame.origin.y = (self.view.frame.origin.y - self.moveView)
                    })
                    isMove = true
                }
            }
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        if let userInfo = sender.userInfo {
            //            if activeTextField == idLb {
            //                showCitizenDetail(idLb.text!)
            //            }
            //            hideKeyboard()
        }
        
        
        
    }
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.activeTextField = sender
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNavigationItem()
        
        loadingView.isHidden = true
        
        activeTextField = UITextField()
        activeTextField.tag = -1
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        switch pageType {
            
        case ServiceConstant.EMPLOYEE_PROFILE_PAGE_TYPE_REGISTER :
            newRegisFunction()
            setNavigationItem(ServiceConstant.TITLE_EMPLOYER_REGISTRATION)
            
        case ServiceConstant.EMPLOYEE_PROFILE_PAGE_TYPE_EDIT_PROFILE :
            
            let employee = appDelegate.employee
            usercode = appDelegate.usercode
            
            let employeeProfile = getEmployeeDetail(employee, andUserCode: usercode)
            
            let respStatus = employeeProfile.object(forKey: "RespStatus") as! NSDictionary
            
            if respStatus.object(forKey: "StatusID") as! NSNumber == 1 {
                
                let profile = employeeProfile["RespBody"] as! NSMutableArray
                
                setProfileInTextView(profile.object(at: 0) as! NSDictionary)
                editProfileFunction()
                setNavigationItem(ServiceConstant.TITLE_EMPLOYER_EDIT_PROFILE)
                
            }
            
        default :
            let employee = appDelegate.employee
            usercode = appDelegate.usercode
            
            let employeeProfile = getEmployeeDetail(employee, andUserCode: usercode)
            
            let respStatus = employeeProfile.object(forKey: "RespStatus") as! NSDictionary
            
            if respStatus.object(forKey: "StatusID") as! NSNumber == 1 {
                
                let profile = employeeProfile["RespBody"] as! NSMutableArray
                
                setProfileInTextView(profile.object(at: 0) as! NSDictionary)
                editProfileFunction()
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmployeeProfileOrRegisterViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        hideKeyboard()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func getEmployeeDetail(_ employee : NSDictionary , andUserCode userCode : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        if let user = employee.object(forKey: "UserID") as? String {
            
            userID = user
            
            Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
            
            do {
                
                try resp = memberHelper.getMemberDetail(userID, andUserCode: userCode)
                
                loadingView.isHidden = true
                
            }catch {
                
                loadingView.isHidden = true
                
                let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                    "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
            }
            
        }
        
        return resp
    }
    
    func getSuggestJobPosition(_ keyword : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = masterDataHelper.getSuggestJobPosition(keyword)
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newRegisFunction() {
        
        self.title = ServiceConstant.TITLE_EMPLOYER_REGISTRATION
        
        logoutButt.isEnabled = false
        logoutButt.title = ""
        
        usernameLb.backgroundColor = UIColor.lightGray
        usernameLb.isEnabled = false
        
        confirmButt.tag = 20
        
        let imageRegisterComplete = UIImage(named: "Button_Login_Regis") as UIImage?
        confirmButt.setBackgroundImage(imageRegisterComplete, for: UIControlState())
    }
    
    func setProfileInTextView(_ profile : NSDictionary) {
        
        
        idLb.text = (profile["UserCode"] as! String)
        
        titleLb.text = masterDataHelper.getValueInArray(titleArray , withType: "NSNumber" , byKeyName: "PrefixID", andKeyValue: profile["PrefixID"] as! String, forDataName: "PrefixName")
        titleID = profile["PrefixID"] as! String
        
        nameLb.text = (profile["FirstName"] as! String)
        surnameLb.text = (profile["LastName"] as! String)
        
        let birthDateAndTime = profile["BirthDay"] as! String
        let birthDate = birthDateAndTime.substring(to: birthDateAndTime.range(of: " ")!.lowerBound)
        let birthDateArray = birthDate.components(separatedBy: "-")
        self.birthDate[0] = Int(birthDateArray[2])!
        self.birthDate[1] = Int(birthDateArray[1])!
        self.birthDate[2] = Int(birthDateArray[0])! + 543
        
        
        birthDayLb.text = String(self.birthDate[0]) + " " + (monthArray[self.birthDate[1] - 1] as! String) + " " + String(self.birthDate[2])
        
        sexLb.text = masterDataHelper.getValueInArray(sexArray,withType: "String" , byKeyName: "SexID", andKeyValue: profile["Sex"] as! String, forDataName: "SexName")
        sexID = profile["Sex"] as! String
        
        provinceLb.text = masterDataHelper.getValueInArray(provinceArray,withType: "NSNumber" , byKeyName: "ProvinceID", andKeyValue: profile["ProvinceID"] as! String, forDataName: "ProvinceName")
        provinceID = profile["ProvinceID"] as! String
        
        amphoeArray = getAmphoe(profile["ProvinceID"] as! String)
        amphoeLb.text = masterDataHelper.getValueInArray(amphoeArray,withType: "NSNumber" , byKeyName: "AmphoeID", andKeyValue: profile["AmphoeID"] as! String, forDataName: "AmphoeName")
        amphoeID = profile["AmphoeID"] as! String
        
        tambonArray = getTambon(profile["AmphoeID"] as! String)
        tambonLb.text = masterDataHelper.getValueInArray(tambonArray,withType: "NSNumber" , byKeyName: "TambonID", andKeyValue: profile["TambonID"] as! String, forDataName: "TambonName")
        tambonID = profile["TambonID"] as! String
        
        usernameLb.text = "\(usercode)"
        
        
        let password = UserDefaults.standard.value(forKey: "password") as? String
        passwordLb.text = password
        
        phoneLb.text = profile["Telephone"] as! String
        
        //jobPosition = profile["JobPosition"] as! String
        
        positionLb.text = profile["RequestPosition"] as! String
        
        suggestJobLb.text = profile["JobPosition"] as! String
        
        if let value = profile["JobPositionID"] as? String{
            jobPositionID = value
        }
        
        
        jobProvinceLb.text = masterDataHelper.getValueInArray(jobProvinceArray,withType: "NSTaggedPointerString" , byKeyName: "PvId", andKeyValue: "\(profile["WorkProvinceID"] as! NSNumber)" , forDataName: "PvName")
        jobProvinceId = "\(profile["WorkProvinceID"] as! NSNumber)"
        
        degreeArray = getDegree()
        degreeLb.text = masterDataHelper.getValueInArray(degreeArray,withType: "NSNumber" , byKeyName: "DegreeId", andKeyValue: profile["DegreeID"] as! String, forDataName: "DegreeName")
        degreeID = profile["DegreeID"] as! String
        
        departmentArray = getDepartment(degreeID)
        departmentLb.text = masterDataHelper.getValueInArray(departmentArray,withType: "NSNumber" , byKeyName: "DepartmentId", andKeyValue: profile["DepartmentID"] as! String, forDataName: "DepartmentName")
        departmentID = profile["DepartmentID"] as! String
        
        addressNoLb.text = "\(profile["AddrNumber"] as! String)"
        
        zipcodeLb.text = "\(profile["ZipCode"] as! NSNumber)"
        
        employeeProfile = profile as! NSMutableDictionary
        
        
        
    }
    
    func getDegree() -> NSMutableArray {
        
        var resp = NSDictionary()
        var array = NSMutableArray()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            resp = try masterDataHelper.getEducation()
            array = resp["RespBody"] as! NSMutableArray
            
        }catch{
            
            loadingView.isHidden = true
            
        }
        
        return array
    }
    
    func clearEGAData() {
        
        titleLb.text = ""
        usernameLb.text = ""
        nameLb.text = ""
        surnameLb.text = ""
        birthDayLb.text = ""
        sexLb.text = ""
        sexID = ""
        provinceLb.text = ""
        provinceID = ""
        amphoeLb.text = ""
        amphoeID = ""
        tambonLb.text = ""
        tambonID = ""
        addressNoLb.text = ""
    }
    
    
    func setProfileFromEGAInTextView(_ profile : NSDictionary) {
        
        
        titleLb.text = profile["NameTH_Prefix"] as! String
        var title = titleLb.text
        if title == "น.ส." {
            title = "นางสาว"
        }
        titleID = masterDataHelper.getKeyInArray(titleArray,withType: "NSNumber" , byKeyName: "PrefixID", andValue: title!, forDataName: "PrefixName")
        
        if titleID == "" {
            titleID = masterDataHelper.getKeyInArray(titleArray,withType: "NSNumber" , byKeyName: "PrefixID", andValue: "อื่นๆ", forDataName: "PrefixName")
        }
        
        nameLb.text = profile["NameTH_FirstName"] as! String
        surnameLb.text = profile["NameTH_SurName"] as! String
        
        let birthDateStr = profile["BirthDate"] as! String
        birthDate[2] = Int(birthDateStr[birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 0)...birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 3)])!
        birthDate[1] = Int(birthDateStr[birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 4)...birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 5)])!
        birthDate[0] = Int(birthDateStr[birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 6)...birthDateStr.characters.index(birthDateStr.startIndex, offsetBy: 7)])!
        
        
        birthDayLb.text = String(birthDate[0]) + " " + (monthArray[birthDate[1] - 1] as! String) + " " + String(birthDate[2])
        
        sexID = String(describing: profile["SexID"] as! NSNumber)
        sexLb.text = profile["Sex"] as! String
        
        provinceLb.text = profile["Address_Province"] as! String
        provinceID = masterDataHelper.getKeyInArray(provinceArray,withType: "NSNumber" , byKeyName: "ProvinceID", andValue: profile["Address_Province"] as! String, forDataName: "ProvinceName")
        
        amphoeArray = getAmphoe(provinceID)
        amphoeLb.text = profile["Address_Amphur"] as! String
        amphoeID = masterDataHelper.getKeyInArray(amphoeArray,withType: "NSNumber" , byKeyName: "AmphoeID", andValue: profile["Address_Amphur"] as! String, forDataName: "AmphoeName")
        
        if amphoeID == "" {
            amphoeID = masterDataHelper.getKeyWithConcatInArray(amphoeArray, withType: "NSNumber", byKeyName: "AmphoeID", andConcatWord: "\(provinceLb.text!)", andValue: profile["Address_Amphur"] as! String, forDataName: "AmphoeName")
        }
        
        tambonArray = getTambon(amphoeID)
        tambonLb.text = profile["Address_Tumbol"] as! String
        tambonID = masterDataHelper.getKeyInArray(tambonArray,withType: "NSNumber" , byKeyName: "TambonID", andValue: profile["Address_Tumbol"] as! String, forDataName: "TambonName")
        
        if tambonID == "" {
            tambonID = masterDataHelper.getKeyWithConcatInArray(tambonArray, withType: "NSNumber", byKeyName: "TambonID", andConcatWord: "\(tambonLb.text!)", andValue: profile["Address_Tumbol"] as! String, forDataName: "TambonName")
        }
        
        addressNoLb.text = profile["Address_No"] as! String
        
        
    }
    
    func editProfileFunction() {
        
        self.title = ServiceConstant.TITLE_EMPLOYER_EDIT_PROFILE
        
        idLb.isEnabled = false
        titleLb.isEnabled = false
        nameLb.isEnabled = false
        surnameLb.isEnabled = false
        birthDayLb.isEnabled = false
        sexLb.isEnabled = false
        usernameLb.isEnabled = false
        
        idLb.backgroundColor = UIColor.lightGray
        titleLb.backgroundColor = UIColor.lightGray
        nameLb.backgroundColor = UIColor.lightGray
        surnameLb.backgroundColor = UIColor.lightGray
        birthDayLb.backgroundColor = UIColor.lightGray
        sexLb.backgroundColor = UIColor.lightGray
        usernameLb.backgroundColor = UIColor.lightGray
        
        let imageEditComplete = UIImage(named: "Button_Edit") as UIImage?
        confirmButt.setBackgroundImage(imageEditComplete, for: UIControlState())
        confirmButt.tag = 30
    }
    
    func getProvince() -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = masterDataHelper.getProvince()
            
            loadingView.isHidden = true
            
            return soapResp["RespBody"] as! NSMutableArray
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
    }
    
    func getAmphoe(_ provinceID : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = masterDataHelper.getAmphoe(provinceID)
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
        
    }
    
    func getTambon(_ amphoeID : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = masterDataHelper.getTambon(amphoeID)
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
        
    }
    
    func getSex() -> NSMutableArray {
        
        return masterDataHelper.getSexList()
        
    }
    
    func getDepartment(_ degreeID : String) -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = masterDataHelper.getDepartment(degreeID)
            
            loadingView.isHidden = true
            
            return soapResp["RespBody"] as! NSMutableArray
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView == birthDayPickerView {
            return 3
        }else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case titlePickerView :
            return titleArray.count
        case sexPickerView :
            return sexArray.count
        case provincePickerView :
            return provinceArray.count
        case amphoePickerView :
            return amphoeArray.count
        case tambonPickerView :
            return tambonArray.count
        case degreePickerView :
            return degreeArray.count
        case departmentPickerView :
            return departmentArray.count
        case birthDayPickerView :
            return birthDateArray[component].count
        case suggestJobPickerView :
            return suggestJobArray.count
        case jobProvincePickerView :
            return jobProvinceArray.count
            
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case titlePickerView :
            if let item = titleArray.object(at: row) as? NSDictionary {
                return item["PrefixName"] as? String
            }else{
                return ""
            }
        case sexPickerView :
            if let item = sexArray.object(at: row) as? NSDictionary {
                return item["SexName"] as? String
            }else{
                return ""
            }
        case provincePickerView :
            if let item = provinceArray.object(at: row) as? NSDictionary {
                return item["ProvinceName"] as? String
            }else{
                return ""
            }
        case amphoePickerView :
            if let item = amphoeArray.object(at: row) as? NSDictionary {
                return item["AmphoeName"] as? String
            }else {
                return ""
            }
        case tambonPickerView :
            if let item = tambonArray.object(at: row) as? NSDictionary {
                return item["TambonName"] as? String
            }else{
                return ""
            }
        case degreePickerView :
            if let item = degreeArray.object(at: row) as? NSDictionary{
                return item["DegreeName"] as? String
            }else{
                return ""
            }
        case departmentPickerView :
            if let item = departmentArray.object(at: row) as? NSDictionary{
                return item["DepartmentName"] as? String
            }else{
                return ""
            }
        case birthDayPickerView :
            return (birthDateArray[component].object(at: row) as! String)
        case suggestJobPickerView :
            if let item = suggestJobArray.object(at: row) as? NSDictionary{
                return item["JobPositionName"] as? String
            }else{
                return ""
            }
        case jobProvincePickerView :
            if let item = jobProvinceArray.object(at: row) as? NSDictionary {
                return item["PvName"] as? String
            }else{
                return ""
            }
        default :
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case titlePickerView :
            let item = titleArray.object(at: row) as! NSDictionary
            titleID = String(describing: item["PrefixID"] as! NSNumber)
            titleLb.text = (item["PrefixName"] as! String)
        case sexPickerView :
            let item = sexArray.object(at: row) as! NSDictionary
            sexID = item["SexID"] as! String
            sexLb.text = (item["SexName"] as! String)
        case provincePickerView :
            let item = provinceArray.object(at: row) as! NSDictionary
            provinceID = String(describing: item["ProvinceID"] as! NSNumber)
            provinceLb.text = (item["ProvinceName"] as! String)
        case amphoePickerView :
            let item = amphoeArray.object(at: row) as! NSDictionary
            amphoeID = String(describing: item["AmphoeID"] as! NSNumber)
            amphoeLb.text = (item["AmphoeName"] as! String)
        case tambonPickerView :
            let item = tambonArray.object(at: row) as! NSDictionary
            tambonID = String(describing: item["TambonID"] as! NSNumber)
            tambonLb.text = (item["TambonName"] as! String)
        case degreePickerView :
            let item = degreeArray.object(at: row) as! NSDictionary
            degreeID = String(describing: item["DegreeId"] as! NSNumber)
            degreeLb.text = (item["DegreeName"] as! String)
            
            departmentArray = getDepartment(degreeID)
        case departmentPickerView :
            let item = departmentArray.object(at: row) as! NSDictionary
            departmentID = String(describing: item["DepartmentId"] as! NSNumber)
            departmentLb.text = (item["DepartmentName"] as! String)
        case jobProvincePickerView :
            let item = provinceArray.object(at: row) as! NSDictionary
            jobProvinceId = String(describing: item["ProvinceID"] as! NSNumber)
            jobProvinceLb.text = (item["ProvinceName"] as! String)
            
        case birthDayPickerView :
            
            switch component {
                
            case 0 :
                birthDate[0] = birthDateArray[0][row] as! Int
            case 1 :
                birthDate[1] = birthDateArray[1][row] as! Int
            case 2 :
                birthDate[2] = birthDateArray[2][row] as! Int
            default :
                ""
                
            }
            
            birthDayLb.text = String(describing: birthDateArray[0][birthDate[0]]) + " " + String(describing: birthDateArray[1][birthDate[1]]) + " " + String(describing: birthDateArray[2][birthDate[2]])
            
        case suggestJobPickerView :
            let item = suggestJobArray.object(at: row) as! NSDictionary
            jobPositionID = String(describing: item["JobPositionID"] as! NSNumber)
            suggestJobLb.text = (item["JobPositionName"] as! String)
            jobPositionSuggestName = (item["JobPositionName"] as! String)
            
        case jobProvincePickerView :
            let item = jobProvinceArray.object(at: row) as! NSDictionary
            jobProvinceLb.text = item["PvName"] as? String
            jobProvinceId = "\(item["PvId"] as! NSString)"
            
        default : break
            //            print("")
        }
    }
    
    func clearSuggestJobAction() {
        
        suggestJobLb.resignFirstResponder()
        suggestJobLb.inputView = nil
        suggestJobLb.becomeFirstResponder()
        
    }
    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        //        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        //        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true);
        
        performSegue(withIdentifier: "EmployeeLogoutSegue", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endTextField(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if textField == suggestJobLb && jobPositionID == ""  {
            
            if  !isSearchSuggestJob {
                
                hideKeyboard()
        
                let alertController = UIAlertController(title: "", message:
                    "กรุณากด Done เพื่อเลือกตำแหน่งงานมาตรฐานอาชีพ ตามคำค้นที่ระบุ", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                    
                    textField.becomeFirstResponder()
                    
                }))
                
                present(alertController, animated: true, completion: nil)
                
            }else{
                textField.becomeFirstResponder()
            }
            
        }else{
            hideKeyboard()
        }
        
        
    }
    
    @IBAction func endTextField(_ textField : UITextField) {
        
        
        var tag = textField.tag
        
        if textField == provinceLb {
            
            if provinceLb.text != "" {
                amphoeLb.isEnabled = true
                amphoeLb.backgroundColor = UIColor.white
            }else{
                amphoeLb.isEnabled = false
                amphoeLb.backgroundColor = UIColor.lightGray
            }
            
        }else if textField == amphoeLb {
            
            if amphoeLb.text != "" {
                tambonLb.isEnabled = true
                tambonLb.backgroundColor = UIColor.white
            }else{
                tambonLb.isEnabled = false
                tambonLb.backgroundColor = UIColor.lightGray
            }
            
        }else if textField == idLb {
            
            showCitizenDetail(idLb.text!)
            
            textField.resignFirstResponder()
            
        }
        
        if textField == suggestJobLb && textField.inputView != suggestJobPickerView {
            
            suggestJobArray = getSuggestJobPosition(suggestJobLb.text!)
            
            if suggestJobArray.count > 0 {
                
                isSearchSuggestJob = true
                
                textField.inputView = suggestJobPickerView
                textField.reloadInputViews()
                
                tag = 12
            }else{
                isSearchSuggestJob = false
                tag = 55
                textField.inputView = nil
                let alertController = UIAlertController(title: "", message:
                    "ไม่พบตำแหน่งงานที่ค้นหา", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                    //self.hideKeyboard()
                }))
                
                present(alertController, animated: true, completion: nil)
            }
            
        }
        
        
        if tag > 0 && tag < 15 {
            let nextTextField:UITextField = view.viewWithTag(tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        
        
    }
    
    func showCitizenDetail(_ citizenID : String) {
        
        var profile = NSDictionary()
        
        idLb.text = citizenID
        usercode = citizenID
        userID = citizenID
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            profile = try showCitizenProfileFromEGAService(citizenID)
            
            loadingView.isHidden = true
            
            if profile.count > 1 {
                
                registerButton.isEnabled = true
                
                setProfileFromEGAInTextView(profile)
                
                
            }else{
                
                idLb.text = ""
                
                registerButton.isEnabled = false
                
                if let errorMessage = profile["Message"] as? String {
                
                    if errorMessage.range(of: "[") != nil {
                        
                        let c = errorMessage.characters
                        
                        let range = errorMessage.index(after: c.index(of: "[")!)..<errorMessage.index(c.index(of: "]")!, offsetBy: 0)
                        
                        let errorcode = errorMessage.substring(with: range)
                        
                        print("ErrorMessage : \(errorMessage)")
                        
                        print("ErrorCode : \(errorcode)")
                        
                        
                        if errorcode == "90005" {
                            
                            let alertController = UIAlertController(
                                title: "",
                                message: "หากท่านต้องการลงทะเบียนนอกเวลาราชการ สามารถลงทะเบียนผ่าน http://smartjob.doe.go.th และท่านสามารถใช้บริการหางาน หาคน บน Mobile Application ได้ตลอด 24 ชั่วโมง ขออภัยในความไม่สะดวก",
                                preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                            alertController.addAction(okAction)
                            
                            let openAction = UIAlertAction(title: "ไปยังเว็บไซต์", style: .default) { (action) in
                                if let url = URL(string:"http://smartjob.doe.go.th/Registration.aspx") {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            alertController.addAction(openAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }else if errorcode == "00815"{
                            let alertController = UIAlertController(title: "", message:
                                "กรุณาตรวจสอบเลขที่บัตรประชาชน", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                                //textField.resignFirstResponder()
                            }))
                            
                            present(alertController, animated: true, completion: nil)
                            
                        }else {
                            
                            let alertController = UIAlertController(
                                title: "",
                                message: "หากท่านต้องการลงทะเบียนนอกเวลาราชการ สามารถลงทะเบียนผ่าน http://smartjob.doe.go.th และท่านสามารถใช้บริการหางาน หาคน บน Mobile Application ได้ตลอด 24 ชั่วโมง ขออภัยในความไม่สะดวก",
                                preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                            alertController.addAction(okAction)
                            
                            let openAction = UIAlertAction(title: "ไปยังเว็บไซต์", style: .default) { (action) in
                                if let url = URL(string:"http://smartjob.doe.go.th/Registration.aspx") {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            alertController.addAction(openAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else if errorMessage == "CitizenID is not valid" {
                        let alertController = UIAlertController(title: "", message:
                            "กรุณาตรวจสอบเลขที่บัตรประชาชน", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                        
                        present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(
                            title: "",
                            message: "หากท่านต้องการลงทะเบียนนอกเวลาราชการ สามารถลงทะเบียนผ่าน http://smartjob.doe.go.th และท่านสามารถใช้บริการหางาน หาคน บน Mobile Application ได้ตลอด 24 ชั่วโมง ขออภัยในความไม่สะดวก",
                            preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                        alertController.addAction(okAction)
                        
                        let openAction = UIAlertAction(title: "ไปยังเว็บไซต์", style: .default) { (action) in
                            if let url = URL(string:"http://smartjob.doe.go.th/Registration.aspx") {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        alertController.addAction(openAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }else{
                    let alertController = UIAlertController(
                        title: "",
                        message: "หากท่านต้องการลงทะเบียนนอกเวลาราชการ สามารถลงทะเบียนผ่าน http://smartjob.doe.go.th และท่านสามารถใช้บริการหางาน หาคน บน Mobile Application ได้ตลอด 24 ชั่วโมง ขออภัยในความไม่สะดวก",
                        preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    
                    let openAction = UIAlertAction(title: "ไปยังเว็บไซต์", style: .default) { (action) in
                        if let url = URL(string:"http://smartjob.doe.go.th/Registration.aspx") {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertController.addAction(openAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }catch {
            
            idLb.text = ""
            
            loadingView.isHidden = true
            
            registerButton.isEnabled = false
            
            let alertController = UIAlertController(
                title: "",
                message: "หากท่านต้องการลงทะเบียนนอกเวลาราชการ สามารถลงทะเบียนผ่าน http://smartjob.doe.go.th และท่านสามารถใช้บริการหางาน หาคน บน Mobile Application ได้ตลอด 24 ชั่วโมง ขออภัยในความไม่สะดวก",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            
            let openAction = UIAlertAction(title: "ไปยังเว็บไซต์", style: .default) { (action) in
                if let url = URL(string:"http://smartjob.doe.go.th/Registration.aspx") {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        usernameLb.text = idLb.text
        
    }
    
    func showCitizenProfileFromEGAService(_ citizenID : String) throws -> NSDictionary {
        
        var tokenResp = NSDictionary()
        var profileResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeProfileOrRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try tokenResp = egaHelper.getTokenByCitizenID(idLb.text!)
            
            loadingView.isHidden = true
            
            if tokenResp.count > 0 {
                let token = tokenResp["Result"] as! String
                
                try profileResp = egaHelper.getSimpleProfileByCitizenID(citizenID, withToken: token)
                
                
                
                return profileResp
                
            }else {
                
                return NSDictionary()
                
            }
            
        }catch {
            
            loadingView.isHidden = true
            
            throw error
            
            
            
        }
        
        
        
    }
    
    func donePicker(){
        
        textFieldShouldReturn(self.activeTextField)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 20
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        spaceButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let nextButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployeeProfileOrRegisterViewController.donePicker))
        nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let clearTextButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployeeProfileOrRegisterViewController.clearSuggestJobAction))
        clearTextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        toolbar.isUserInteractionEnabled = true
        if textField == suggestJobLb {
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
        }else{
            toolbar.setItems([spaceButton , nextButton], animated: false)
        }
        textField.inputAccessoryView = toolbar
        
        self.activeTextField = textField
        
        
        switch textField {
            
        case idLb :
            clearEGAData()
            
        case suggestJobLb :
            jobPositionID = ""
            isSearchSuggestJob = false
            
            
        default : break
            //            print("")
        }
        
        
        
        return true
    }
    
    @IBAction func registrationAction(_ sender: AnyObject) {
        
        if confirmButt.tag == 20 {
            if checkFillComplete() == false {
                
                if jobPositionID == "" {
                    
                    let alertController = UIAlertController(title: "", message:
                        "กรุณาระบุอาชีพมาตรฐาน", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                
                }else{
                
                    let alertController = UIAlertController(title: "", message:
                        "กรุณาระบุข้อมูลให้ครบทุกช่อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                }
                
            }else {
                
                registration()
                
            }
        }else if confirmButt.tag == 30 {
            
            if checkFillComplete() == false {
                
                if jobPositionID == "" {
                    
                    let alertController = UIAlertController(title: "", message:
                        "กรุณาระบุอาชีพมาตรฐาน", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }else{
                    
                    let alertController = UIAlertController(title: "", message:
                        "กรุณาระบุข้อมูลให้ครบทุกช่อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                }

                
            }else {
                registration()
            }
        }
        
    }
    
    func registration() {
        
        let day = birthDate[0]
        let month = birthDate[1]
        let year = birthDate[2] - 543
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: "\(year)-\(month)-\(day)")
        
        let strBirthDate = dateFormatter.string(from: date!)
        
        employeeProfile.setValue(userID , forKey: "UserID")
        employeeProfile.setValue(idLb.text!, forKey: "PersonalID")
        employeeProfile.setValue(nameLb.text!, forKey: "FirstName")
        employeeProfile.setValue(surnameLb.text!, forKey: "LastName")
        employeeProfile.setValue(sexID, forKey: "Sex")
        employeeProfile.setValue(titleID, forKey: "PrefixID")
        employeeProfile.setValue(strBirthDate, forKey: "BirthDay")
        employeeProfile.setValue(provinceID, forKey: "ProvinceID")
        employeeProfile.setValue(amphoeID, forKey: "AmphoeID")
        employeeProfile.setValue(tambonID, forKey: "TambonID")
        employeeProfile.setValue(addressNoLb.text!, forKey: "addrNumber")
        
        
        if zipcodeLb.text! != "" {
            employeeProfile.setValue(zipcodeLb.text!, forKey: "zipCode")
        }
        
        if phoneLb.text! != "" {
            employeeProfile.setValue(phoneLb.text!, forKey: "Telephone")
        }
        if passwordLb.text! != "" {
            employeeProfile.setValue(passwordLb.text!, forKey: "Password")
        }
        if positionLb.text! != "" {
            employeeProfile.setValue(positionLb.text!, forKey: "RequestPosition")
        }else{
            employeeProfile.setValue(jobPosition, forKey: "RequestPosition")
        }
        
        employeeProfile.setValue(jobPositionID, forKey: "JobPositionID")
        employeeProfile.setValue(jobPositionSuggestName, forKey: "JobPosition")
        employeeProfile.setValue(degreeID, forKey: "DegreeID")
        employeeProfile.setValue(departmentID, forKey: "DepartmentID")
        employeeProfile.setValue(jobProvinceId, forKey: "workProvinceID")
        
        
        if confirmButt.tag == 20 {
            
            performSegue(withIdentifier: "EmployeeRegistrationSegue", sender: self)
            
        }else if confirmButt.tag == 30 {
            
            let employee = appDelegate.employee
            
            if employee.count > 0 {
                
                let accountStatusArray = employee.object(forKey: "StatusList") as! NSMutableArray
                
                for object in accountStatusArray {
                    
                    let accountStatus = object as! NSDictionary
                    
                    if accountStatus.object(forKey: "FunctionCode") as! String == "02" {
                        
                        let status = accountStatus.object(forKey: "StatusFlag") as! String
                        
                        switch status {
                        case "01" :
                            
                            employeeProfile.setValue("1", forKey: "createFunctionFlag")
                            break
                            
                        default :
                            employeeProfile.setValue("0", forKey: "createFunctionFlag")
                        }
                        
                    }
                }
                
            }
            
            updateProfileAction()
        }
        
    }
    
    func checkFillComplete() -> Bool {
        
        clearBorderTextField()
        
        if userID == "" ||
            idLb.text! == "" ||
            nameLb.text! == "" ||
            surnameLb.text! == "" ||
            sexLb.text! == "" ||
            titleLb.text! == "" ||
            birthDayLb.text! == "" ||
            provinceLb.text! == "" ||
            addressNoLb.text! == "" ||
            amphoeLb.text! == "" ||
            tambonLb.text! == "" ||
            zipcodeLb.text! == "" ||
            phoneLb.text! == "" ||
            passwordLb.text! == "" ||
            positionLb.text! == "" ||
            suggestJobLb.text! == "" ||
            degreeLb.text! == "" ||
            departmentLb.text! == "" ||
            jobProvinceLb.text! == ""
        {
            setBorderTextField()
            return false
        }else{
            return true
        }
        
        
        
    }
    
    func clearBorderTextField() {
        
        
        
        idLb.layer.borderColor = UIColor.clear.cgColor
        idLb.layer.borderWidth = 1
        
        idLb.layer.borderColor = UIColor.clear.cgColor
        idLb.layer.borderWidth = 1
        
        nameLb.layer.borderColor = UIColor.clear.cgColor
        nameLb.layer.borderWidth = 1
        
        surnameLb.layer.borderColor = UIColor.clear.cgColor
        surnameLb.layer.borderWidth = 1
        
        sexLb.layer.borderColor = UIColor.clear.cgColor
        sexLb.layer.borderWidth = 1
        
        titleLb.layer.borderColor = UIColor.clear.cgColor
        titleLb.layer.borderWidth = 1
        
        birthDayLb.layer.borderColor = UIColor.clear.cgColor
        birthDayLb.layer.borderWidth = 1
        
        zipcodeLb.layer.borderColor = UIColor.clear.cgColor
        zipcodeLb.layer.borderWidth = 1
        
        provinceLb.layer.borderColor = UIColor.clear.cgColor
        provinceLb.layer.borderWidth = 1
        
        amphoeLb.layer.borderColor = UIColor.clear.cgColor
        amphoeLb.layer.borderWidth = 1
        
        tambonLb.layer.borderColor = UIColor.clear.cgColor
        tambonLb.layer.borderWidth = 1
        
        phoneLb.layer.borderColor = UIColor.clear.cgColor
        phoneLb.layer.borderWidth = 1
        
        passwordLb.layer.borderColor = UIColor.clear.cgColor
        passwordLb.layer.borderWidth = 1
        
        positionLb.layer.borderColor = UIColor.clear.cgColor
        positionLb.layer.borderWidth = 1
        
        suggestJobLb.layer.borderColor = UIColor.clear.cgColor
        suggestJobLb.layer.borderWidth = 1
        
        degreeLb.layer.borderColor = UIColor.clear.cgColor
        degreeLb.layer.borderWidth = 1
        
        departmentLb.layer.borderColor = UIColor.clear.cgColor
        departmentLb.layer.borderWidth = 1
        
        jobProvinceLb.layer.borderColor = UIColor.clear.cgColor
        jobProvinceLb.layer.borderWidth = 1
        
    }
    
    func setBorderTextField(){
        let borderColor : UIColor = UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )
        
        if userID == "" {
            idLb.layer.borderColor = borderColor.cgColor
            idLb.layer.borderWidth = 2
        }
        if idLb.text! == "" {
            idLb.layer.borderColor = borderColor.cgColor
            idLb.layer.borderWidth = 2
        }
        if nameLb.text! == "" {
            nameLb.layer.borderColor = borderColor.cgColor
            nameLb.layer.borderWidth = 2
        }
        if surnameLb.text! == "" {
            surnameLb.layer.borderColor = borderColor.cgColor
            surnameLb.layer.borderWidth = 2
        }
        if sexLb.text! == "" {
            sexLb.layer.borderColor = borderColor.cgColor
            sexLb.layer.borderWidth = 2
        }
        if titleLb.text! == "" {
            titleLb.layer.borderColor = borderColor.cgColor
            titleLb.layer.borderWidth = 2
        }
        if birthDayLb.text! == "" {
            birthDayLb.layer.borderColor = borderColor.cgColor
            birthDayLb.layer.borderWidth = 2
        }
        if zipcodeLb.text! == "" {
            zipcodeLb.layer.borderColor = borderColor.cgColor
            zipcodeLb.layer.borderWidth = 2
        }
        if provinceLb.text! == "" {
            provinceLb.layer.borderColor = borderColor.cgColor
            provinceLb.layer.borderWidth = 2
        }
        if amphoeLb.text! == "" {
            amphoeLb.layer.borderColor = borderColor.cgColor
            amphoeLb.layer.borderWidth = 2
        }
        if tambonLb.text! == "" {
            tambonLb.layer.borderColor = borderColor.cgColor
            tambonLb.layer.borderWidth = 2
        }
        if phoneLb.text! == "" {
            phoneLb.layer.borderColor = borderColor.cgColor
            phoneLb.layer.borderWidth = 2
        }
        if passwordLb.text! == "" {
            passwordLb.layer.borderColor = borderColor.cgColor
            passwordLb.layer.borderWidth = 2
        }
        if positionLb.text! == "" {
            positionLb.layer.borderColor = borderColor.cgColor
            positionLb.layer.borderWidth = 2
        }
        if suggestJobLb.text! == "" {
            suggestJobLb.layer.borderColor = borderColor.cgColor
            suggestJobLb.layer.borderWidth = 2
        }
        if degreeLb.text! == "" {
            degreeLb.layer.borderColor = borderColor.cgColor
            degreeLb.layer.borderWidth = 2
        }
        if departmentLb.text! == "" {
            departmentLb.layer.borderColor = borderColor.cgColor
            departmentLb.layer.borderWidth = 2
        }
        if jobProvinceLb.text! == "" {
            jobProvinceLb.layer.borderColor = borderColor.cgColor
            jobProvinceLb.layer.borderWidth = 2
        }
    }
    
    func ws_insertEmployeeRegister() {
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(ConfirmEmployeeRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = employeeHelper.employeeRegistration(employeeProfile)
            
            loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                //                print("Register Resp : \(resp)")
                
                if resp["StatusID"] as! NSNumber == 1 {
                    //let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    if resp["oneAccountFlag"] as! String == "true" {
                        performSegue(withIdentifier: "EmployeeRegistrationSegue", sender: self)
                    }else{
                        performSegue(withIdentifier: "OnePasswordSegue", sender: self)
                    }
                    
                    
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
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                "\(error)", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func updateProfileAction() {
        
        var soapResp = NSDictionary()
        
        do{
            
            try soapResp = employeeHelper.updateMemberDetail(employeeProfile)
            
            
            if soapResp.count > 0 {
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                if resp["StatusID"] as! NSNumber == 1 {
                    //let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    let alertController = UIAlertController(title: "การแก้ไขข้อมูลเรียบร้อยแล้ว", message:
                        "การแก้ไขข้อมูลเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }else {
                    let errorMsg = resp["StatusMsg"] as! String
                    let alertController = UIAlertController(title: "การแก้ไขข้อมูลขัดข้อง!", message:
                        "\(errorMsg)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
            }else {
                let alertController = UIAlertController(title: "การแก้ไขข้อมูลขัดข้อง!", message:
                    "การแก้ไขข้อมูลขัดข้อง กรุณาลองอีกครั้ง", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
                
            }
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmployeeRegistrationSegue" {
            let viewController:ConfirmEmployeeRegisterViewController = segue.destination as! ConfirmEmployeeRegisterViewController
            
            viewController.employeeProfile = employeeProfile
            
        }else if segue.identifier == "OnePasswordSegue" {
            let viewController:OnePasswordForRegistrationViewController = segue.destination as! OnePasswordForRegistrationViewController
            
            viewController.employeeProfile = employeeProfile
            
        }
        
        
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    
}
