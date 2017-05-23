//
//  InsuredProfileOrRegistrationViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 29/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredProfileOrRegistrationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //@IBOutlet weak var logoutButt: UIBarButtonItem!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var idLb: UITextField!
    @IBOutlet weak var cvvLb: UITextField!
    @IBOutlet weak var titleLb: UITextField!
    @IBOutlet weak var nameLb: UITextField!
    @IBOutlet weak var surnameLb: UITextField!
    @IBOutlet weak var birthDayLb: UITextField!
    @IBOutlet weak var sexLb: UITextField!
    @IBOutlet weak var addressNoLb: UITextField!
    
    @IBOutlet weak var addressMooLb: UITextField!
    @IBOutlet weak var addressSoiLb: UITextField!
    @IBOutlet weak var addressStreetLb: UITextField!
    
    @IBOutlet weak var zipcodeLb: UITextField!
    
    @IBOutlet weak var provinceLb: UITextField!
    @IBOutlet weak var amphoeLb: UITextField!
    @IBOutlet weak var tambonLb: UITextField!
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var emailLb: UITextField!
    @IBOutlet weak var usernameLb: UITextField!
    @IBOutlet weak var passwordLb: UITextField!
//    @IBOutlet weak var positionLb: UITextField!
//    @IBOutlet weak var suggestJobLb: UITextField!
//    @IBOutlet weak var degreeLb: UITextField!
//    @IBOutlet weak var departmentLb: UITextField!
    
    @IBOutlet weak var loadingView: UIView!
    
//    @IBOutlet weak var jobProvinceLb: UITextField!
    var activeTextField : UITextField!
    
    var employeeProfile = NSMutableDictionary()
    var memberDataDict = NSMutableDictionary()
    
    var usercode = ""
    var userID = ""
    
    var pageType = ""
    var moveView = CGFloat()
    var isMove = false
    //var keyboardHeight = CGFloat()
    
//    @IBOutlet weak var confirmButt: UIButton!
    
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
    var cvv = ""
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
    var email = ""
    var jobProvinceId = ""
    
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
    
    var jobProvinceArray = NSMutableArray()
    
    var birthDateArray : [NSMutableArray] = []
    
    
    let employerHelper = EmployerHelper()
    let employeeHelper = EmployeeHelper()
    let masterDataHelper = MasterDataHelper()
    let memberHelper = MemberHelper()
    let egaHelper = EGAHelper()
    let empuiHelper = EmpuiHelper()
    //let keychainWrapper = KeychainWrapper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    var moveConstraint = CGFloat()
    
    var employee = NSDictionary()
    
    var isUpdateProfile = false
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    func hideKeyboard(){
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.idLb.resignFirstResponder()
            //self.cvvLb.resignFirstResponder()
            self.titleLb.resignFirstResponder()
            self.nameLb.resignFirstResponder()
            self.surnameLb.resignFirstResponder()
            self.birthDayLb.resignFirstResponder()
            self.sexLb.resignFirstResponder()
            self.provinceLb.resignFirstResponder()
            self.amphoeLb.resignFirstResponder()
            self.tambonLb.resignFirstResponder()
            self.phoneLb.resignFirstResponder()
            self.emailLb.resignFirstResponder()
            self.passwordLb.resignFirstResponder()
//            self.jobProvinceLb.resignFirstResponder()
//            self.positionLb.resignFirstResponder()
//            self.suggestJobLb.resignFirstResponder()
//            self.degreeLb.resignFirstResponder()
//            self.departmentLb.resignFirstResponder()
            
            self.addressNoLb.resignFirstResponder()
            self.addressMooLb.resignFirstResponder()
            self.addressSoiLb.resignFirstResponder()
            self.addressStreetLb.resignFirstResponder()
            self.zipcodeLb.resignFirstResponder()
            
            
//            self.profileView.frame.origin.y = self.profileView.frame.origin.y + self.moveView
            
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInset
        })
        moveView = 0;
        isMove = false
        
        //        if activeTextField.tag >= 0 && activeTextField == idLb {
        //            showCitizenDetail(idLb.text!)
        //        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItem()
        
        if (employee.object(forKey: "EmployeeID") != nil) {
            
            let employeeProfileResp = getEmployeeDetail(employee)
            
            if let status = employeeProfileResp.object(forKey: "RespStatus") as? NSDictionary {
                
                if status.object(forKey: "StatusID") as! NSNumber == 1 {
                    
                    let respBody = employeeProfileResp.object(forKey: "RespBody") as! NSMutableArray
                    
                    employeeProfile = respBody.object(at: 0) as! NSMutableDictionary
                    
                    setProfileInTextView(employeeProfile)
                    
                }
                
            }
            
            
            
            
        }
    }
    
    func getEmployeeProfile(employeeId : String) -> NSDictionary {
    
        var resp = NSDictionary()
        var respProfile = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = self.employeeHelper.getEmployeeDetail(withEmployeeID: employeeId)
            
            let respBody = resp.object(forKey: "RespBody") as! NSMutableArray
            
            respProfile = respBody.object(at: 0) as! NSDictionary
            
            
            
        }catch {
            
            loadingView.isHidden = true
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return respProfile

    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
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
//        degreeLb.inputView = degreePickerView
//        departmentLb.inputView = departmentPickerView
//        jobProvinceLb.inputView = jobProvincePickerView
        
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
        do {
            
            resp = try masterDataHelper.getTitleName()
            if let value = resp["RespBody"] as? NSMutableArray{
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
            if let value = resp.object(forKey: "RespBody") as? NSMutableArray {
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
//        memberDataDict.setValue(positionLb.text!, forKey: "requestPosition")
        memberDataDict.setValue(jobPositionID, forKey: "jobPositionID")
//        memberDataDict.setValue(positionLb.text!, forKey: "jobPosition")
        memberDataDict.setValue(degreeID, forKey: "degreeID")
        memberDataDict.setValue(departmentID, forKey: "departmentID")
        
    }
    
    func keyboardWillShow(_ sender: Notification) {
        
        if let userInfo = sender.userInfo {
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.scrollView.contentInset = contentInset
        }
        
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        hideKeyboard()
        
        
        
    }
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.activeTextField = sender
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        activeTextField = UITextField()
        activeTextField.tag = -1
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        newRegisFunction()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        hideKeyboard()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func getEmployeeDetail(_ employee : NSDictionary) -> NSDictionary {
        
        var resp = NSDictionary()
        
        userID = employee["UserID"] as! String
        let userCode = employee["PersonalID"] as! String
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        return resp
    }
    
    func getSuggestJobPosition(_ keyword : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        usernameLb.backgroundColor = UIColor.lightGray
        usernameLb.isEnabled = false
        
        registerButton.tag = 20
    }
    
    func setProfileInTextView(_ profile : NSDictionary) {
        
        
        idLb.text = employee.object(forKey: "PersonalID") as! String
        
        showCitizenDetail(idLb.text!)
        
        usernameLb.text = "\(usercode)"
        
        
        let password = UserDefaults.standard.value(forKey: "password") as? String
        passwordLb.text = password
        
        if let value = profile["Telephone"] as? String {
            phoneLb.text = value
        }
        
        employeeProfile = profile as! NSMutableDictionary
        
        
        
    }
    
    func getDegree() -> NSMutableArray {
        
        var resp = NSDictionary()
        var array = NSMutableArray()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
//        cvvLb.text = ""
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
        emailLb.text = ""
        addressNoLb.text = ""
        addressMooLb.text = ""
        addressSoiLb.text = ""
        addressStreetLb.text = ""
        zipcodeLb.text = ""
//        jobProvinceLb.text = ""
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
        addressMooLb.text = profile["Address_Moo"] as! String
        addressSoiLb.text = profile["Address_Soi"] as! String
        addressStreetLb.text = profile["Address_Road"] as! String
        
        
        
    }
    
    func getProvince() -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
            if titleArray.count == 0{
                do{
                    let resp = try masterDataHelper.getTitleName()
                    titleArray = resp["RespBody"] as! NSMutableArray
                }catch{
                
                }
            }
            return titleArray.count
        case sexPickerView :
            if sexArray.count == 0 {
                sexArray = masterDataHelper.getSexList()
            }
            return sexArray.count
        case provincePickerView :
            if provinceArray.count == 0 {
                do {
                    let resp = try masterDataHelper.getProvince()
                    provinceArray = resp["RespBody"] as! NSMutableArray
                }catch{}
            }
            return provinceArray.count
        case amphoePickerView :
            return amphoeArray.count
        case tambonPickerView :
            return tambonArray.count
        case degreePickerView :
            if degreeArray.count == 0{
                do {
                    let resp = try masterDataHelper.getEducation()
                    degreeArray = resp["RespBody"] as! NSMutableArray
                }catch{}
            }
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
            let item = titleArray.object(at: row) as! NSDictionary
            return item["PrefixName"] as? String
        case sexPickerView :
            let item = sexArray.object(at: row) as! NSDictionary
            return item["SexName"] as? String
        case provincePickerView :
            let item = provinceArray.object(at: row) as! NSDictionary
            return item["ProvinceName"] as? String
        case amphoePickerView :
            let item = amphoeArray.object(at: row) as! NSDictionary
            return item["AmphoeName"] as? String
        case tambonPickerView :
            let item = tambonArray.object(at: row) as! NSDictionary
            return item["TambonName"] as? String
        case degreePickerView :
            let item = degreeArray.object(at: row) as! NSDictionary
            return item["DegreeName"] as? String
        case departmentPickerView :
            let item = departmentArray.object(at: row) as! NSDictionary
            return item["DepartmentName"] as? String
        case birthDayPickerView :
            return (birthDateArray[component].object(at: row) as! String)
        case suggestJobPickerView :
            let item = suggestJobArray.object(at: row) as! NSDictionary
            return item["JobPositionName"] as? String
        case jobProvincePickerView :
            let item = jobProvinceArray.object(at: row) as! NSDictionary
            return item["PvName"] as? String
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
//        case degreePickerView :
//            let item = degreeArray.object(at: row) as! NSDictionary
//            degreeID = String(describing: item["DegreeId"] as! NSNumber)
//            degreeLb.text = (item["DegreeName"] as! String)
//        case departmentPickerView :
//            let item = departmentArray.object(at: row) as! NSDictionary
//            departmentID = String(describing: item["DepartmentId"] as! NSNumber)
//            departmentLb.text = (item["DepartmentName"] as! String)
            
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
            
//        case suggestJobPickerView :
//            let item = suggestJobArray.object(at: row) as! NSDictionary
//            jobPositionID = String(describing: item["JobPositionID"] as! NSNumber)
//            suggestJobLb.text = (item["JobPositionName"] as! String)
//            jobPositionSuggestName = (item["JobPositionName"] as! String)
//        case jobProvincePickerView :
//            let item = jobProvinceArray.object(at: row) as! NSDictionary
//            jobProvinceId = "\(item["PvId"] as! NSString)"
//            jobProvinceLb.text = item["PvName"] as! String
        default : break
            //            print("")
        }
    }
    
    func clearSuggestJobAction() {
        
//        suggestJobLb.resignFirstResponder()
//        suggestJobLb.inputView = nil
//        suggestJobLb.becomeFirstResponder()
        
    }
    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        Thread.detachNewThreadSelector(#selector(InsuredProfileOrRegistrationViewController.startIndicator), toTarget: self, with: nil)
        
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endTextField(textField)
        return true
    }
    
    @IBAction func endTextField(_ textField : UITextField) {
        
        hideKeyboard()
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
            
            let checkAccountResp = checkAlreadyAccount(citizenID: textField.text!)
            
            let resp = checkAccountResp["RespBody"] as! NSDictionary
            
            if resp.object(forKey: "EmpuiFlag") as! String == "0" {
                
                showCitizenDetail(idLb.text!)
                
                textField.resignFirstResponder()
                
            }else {
            
                let alertController = UIAlertController(title: "", message:
                    "ลงทะเบียนไว้แล้ว", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
            
            }
            
        }
        
//        if textField == suggestJobLb && textField.inputView != suggestJobPickerView {
//            
//            
//            suggestJobArray = getSuggestJobPosition(suggestJobLb.text!)
//            
//            if suggestJobArray.count > 0 {
//                textField.inputView = suggestJobPickerView
//                tag = 12
//            }else{
//                tag = 55
//                textField.inputView = nil
//                let alertController = UIAlertController(title: "", message:
//                    "ไม่พบตำแหน่งงานที่ค้นหา", preferredStyle: UIAlertControllerStyle.alert)
//                
//                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
//                
//                hideKeyboard()
//                
//                present(alertController, animated: true, completion: nil)
//            }
//            
//        }
//        if (tag > 0 && tag <= 6) {
            if let nextTextField:UITextField = view.viewWithTag(tag+1) as? UITextField {
                nextTextField.becomeFirstResponder()
            }
//        }
    }
    
    func checkAlreadyAccount(citizenID : String) -> NSDictionary {
    
        var resp = NSDictionary()
        
        do{
            
            try resp = self.empuiHelper.checkAccount(personalID: citizenID)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
    
    }
    
    func showCitizenDetail(_ citizenID : String) {
        
        var profile = NSDictionary()
        
        idLb.text = citizenID
        usercode = citizenID
        userID = citizenID
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
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
        
        Thread.detachNewThreadSelector(#selector(InsuredProfileOrRegistrationViewController.startIndicator), toTarget: self, with: nil)
        
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
    
    func keyboardShow(textField : UITextField) {
        
        let textFieldPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        
        let centerY = screenHeight*0.5
        
        
        if (textFieldPoint?.y)! > centerY {
            moveConstraint = (textFieldPoint?.y)! - centerY
            
        }else {
            moveConstraint = 0
            
        }
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = moveConstraint
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.scrollView.contentInset = contentInset
            
        })
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        keyboardShow(textField: textField)
        
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
        if textField != idLb {
            toolbar.setItems([spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
        }
//        else{
//            toolbar.setItems([spaceButton , nextButton], animated: false)
//        }
        
//        toolbar.setItems([spaceButton , nextButton], animated: false)
        
        
        self.activeTextField = textField
        
        
        switch textField {
            
        case idLb :
            clearEGAData()
            
//        case titleLb :
//            let item = titleArray.object(at: 0) as! NSDictionary
//            titleID = String(describing: item["PrefixID"] as! NSNumber)
//            titleLb.text = (item["PrefixName"] as! String)
//        case sexLb :
//            let item = sexArray.object(at: 0) as! NSDictionary
//            sexID = item["SexID"] as! String
//            sexLb.text = (item["SexName"] as! String)
//        case provinceLb :
//            let item = provinceArray.object(at: 0) as! NSDictionary
//            provinceID = String(describing: item["ProvinceID"] as! NSNumber)
//            provinceLb.text = (item["ProvinceName"] as! String)
//        case amphoeLb :
//            if provinceID != "" {
//                amphoeArray = getAmphoe(provinceID)
//                let item = amphoeArray.object(at: 0) as! NSDictionary
//                amphoeID = String(describing: item["AmphoeID"] as! NSNumber)
//                amphoeLb.text = (item["AmphoeName"] as! String)
//            }
//        case tambonLb :
//            if amphoeID != "" {
//                tambonArray = getTambon(amphoeID)
//                let item = tambonArray.object(at: 0) as! NSDictionary
//                tambonID = String(describing: item["TambonID"] as! NSNumber)
//                tambonLb.text = (item["TambonName"] as! String)
//            }
////        case degreeLb :
////            let item = degreeArray.object(at: 0) as! NSDictionary
////            degreeID = String(describing: item["DegreeId"] as! NSNumber)
////            degreeLb.text = (item["DegreeName"] as! String)
////        case departmentLb :
////            if degreeID != "" {
////                departmentArray = getDepartment(degreeID)
////                let item = departmentArray.object(at: 0) as! NSDictionary
////                departmentID = String(describing: item["DepartmentId"] as! NSNumber)
////                departmentLb.text = (item["DepartmentName"] as! String)
////            }
//        case birthDayLb :
//            birthDayLb.text = String(birthDate[0]) + " " + (monthArray[birthDate[1] - 1] as! String) + " " + String(birthDate[2])
////        case suggestJobLb :
////            if suggestJobLb.inputView == suggestJobPickerView {
////                let item = suggestJobArray.object(at: 0) as! NSDictionary
////                jobPositionID = String(describing: item["JobPositionID"] as! NSNumber)
////                suggestJobLb.text = (item["JobPositionName"] as! String)
////                jobPositionSuggestName = (item["JobPositionName"] as! String)
////            }
////        case jobProvinceLb :
////            let item = jobProvinceArray.object(at: 0) as! NSDictionary
////            jobProvinceLb.text = item.object(forKey: "PvName") as! String
////            jobProvinceId = "\(item.object(forKey: "PvId"))"
        default : break
            //            print("")
        }
        
        
        
        return true
    }
    
    @IBAction func registrationAction(_ sender: AnyObject) {
        
//        performSegue(withIdentifier: "InsuredRegistrationSegue", sender: self)
        
        //performSegue(withIdentifier: "OnePasswordSegue", sender: self)
        
        if checkFillComplete() == false {
            
            let alertController = UIAlertController(title: "", message:
                "กรุณาระบุข้อมูลให้ครบทุกช่อง", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }else {
            
            registration()
            
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
        
        let id = idLb.text!
        
        employeeProfile.setValue(id  , forKey: "nationalId")
//        employeeProfile.setValue(cvvLb.text!, forKey: "cvvCode")
        employeeProfile.setValue(nameLb.text!, forKey: "firstName")
        employeeProfile.setValue(surnameLb.text!, forKey: "lastName")
        employeeProfile.setValue(sexID, forKey: "gender")
        employeeProfile.setValue(titleID, forKey: "title")
        employeeProfile.setValue(strBirthDate, forKey: "birthday")
        employeeProfile.setValue(provinceID, forKey: "addrProvinceId")
        employeeProfile.setValue(amphoeID, forKey: "addrDistrictId")
        employeeProfile.setValue(tambonID, forKey: "addrTumbolId")
        
        if addressNoLb.text! != "" {
            employeeProfile.setValue(addressNoLb.text!, forKey: "addrNumber")
        }else{
            employeeProfile.setValue("", forKey: "addrNumber")
        }
        
        employeeProfile.setValue(addressMooLb.text, forKey: "addrMoo")
        
        employeeProfile.setValue(addressSoiLb.text, forKey: "addrSoi")
        
        employeeProfile.setValue(addressStreetLb.text, forKey: "addrStreet")
        
        employeeProfile.setValue(emailLb.text, forKey: "email")
        
        employeeProfile.setValue(phoneLb.text, forKey: "mobileNo")
        
        employeeProfile.setValue(passwordLb.text, forKey: "password")
        
        employeeProfile.setValue(zipcodeLb.text, forKey: "zipcode")
        
        performSegue(withIdentifier: "EmpuiRegistrationSegue", sender: self)
        
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
            amphoeLb.text! == "" ||
            tambonLb.text! == "" ||
            phoneLb.text! == "" ||
            passwordLb.text! == "" ||
            emailLb.text! == ""
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
        
        provinceLb.layer.borderColor = UIColor.clear.cgColor
        provinceLb.layer.borderWidth = 1
        
        amphoeLb.layer.borderColor = UIColor.clear.cgColor
        amphoeLb.layer.borderWidth = 1
        
        tambonLb.layer.borderColor = UIColor.clear.cgColor
        tambonLb.layer.borderWidth = 1
        
        emailLb.layer.borderColor = UIColor.clear.cgColor
        emailLb.layer.borderWidth = 1
        
        phoneLb.layer.borderColor = UIColor.clear.cgColor
        phoneLb.layer.borderWidth = 1
        
        passwordLb.layer.borderColor = UIColor.clear.cgColor
        passwordLb.layer.borderWidth = 1
        
        emailLb.layer.borderColor = UIColor.clear.cgColor
        emailLb.layer.borderWidth = 1
        
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
        if emailLb.text! == "" {
            emailLb.layer.borderColor = borderColor.cgColor
            emailLb.layer.borderWidth = 2
        }

    }
    
    func ws_insertEmployeeRegister() {
        var soapResp = NSDictionary()
        var insuredRegistration = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(ConfirmEmployeeRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = empuiHelper.empuiRegistration(employeeProfile)
            
            loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                //                print("Register Resp : \(resp)")
                
                if resp["StatusID"] as! NSNumber == 1 {
                    
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
        
        if segue.identifier == "EmpuiRegistrationSegue" {
            let viewController:ConfirmEmpuiRegistrationViewController = segue.destination as! ConfirmEmpuiRegistrationViewController
            
            viewController.employeeProfile = employeeProfile
            
        }else if segue.identifier == "OnePasswordSegue" {
            let viewController:OnePasswordForRegistrationViewController = segue.destination as! OnePasswordForRegistrationViewController
            
            viewController.employeeProfile = employeeProfile
            
        }
        
        
    }

    @IBAction func do_BackPage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

    }
    
    
    

}
