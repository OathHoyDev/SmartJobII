//
//  AdvanceSearchJobViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/23/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class AdvanceSearchJobViewController: UIViewController, UIPickerViewDataSource ,UIPickerViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    var jobTypeArray = NSMutableArray()
    var educationArray = NSMutableArray()
    var provinceArray = NSMutableArray()
    var sexArray = NSMutableArray()
    var ageMinArray = NSMutableArray()
    var ageMaxArray = NSMutableArray()
    
    var pickerName = ""
    
    @IBOutlet weak var ageYearLB: UILabel!
    @IBOutlet weak var ageBtLB: UILabel!
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var disabledLB: UILabel!
    var textFieldTag = 0
    
    let pickerJobType = "jobType"
    let pickerEducation = "Education"
    let pickerProvince = "Province"
    
    let masterDataHelper = MasterDataHelper()
    let employeeHelper = EmployeeHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var buttomConst: NSLayoutConstraint!
    
    
    //    var keyboardShow = false
    //    var keyboardMoveHeight = CGFloat()
    
    var moveView = CGFloat()
    var isMove = false
    var activeTextField : UITextField!
    
    @IBOutlet weak var jobTypeTxt: UITextField!
    @IBOutlet weak var positionTxt: UITextField!
    @IBOutlet weak var degreeMinTxt: UITextField!
    @IBOutlet weak var degreeMaxTxt: UITextField!
    @IBOutlet weak var provinceTxt: UITextField!
    @IBOutlet weak var sexTxt: UITextField!
    @IBOutlet weak var ageMinTxt: UITextField!
    @IBOutlet weak var ageMaxTxt: UITextField!
    @IBOutlet weak var disabilityButton: UIButton!
    
    var disability = false
    
    var jobID = NSNumber()
    var degreeMinId = NSNumber()
    var degreeMaxId = NSNumber()
    var provinceID = NSNumber()
    var sexID = ""
    var jobTypePickerView = UIPickerView()
    var degreeMinPickerView = UIPickerView()
    var degreeMaxPickerView = UIPickerView()
    var provincePickerView = UIPickerView()
    var sexPickerView = UIPickerView()
    var ageMinPickerView = UIPickerView()
    var ageMaxPickerView = UIPickerView()
    
    var jobList = NSDictionary()
    
    var activeField: UITextField?
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        jobTypeArray.removeAllObjects()
        educationArray.removeAllObjects()
        provinceArray.removeAllObjects()
        
        jobTypeArray = getJobType()
        educationArray = getEducation()
        provinceArray = getProvince()
        
        ageMinArray = getAgeArray("min")
        ageMaxArray = getAgeArray("max")
        
        sexArray = masterDataHelper.getSexList()
        
        setFontSize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AdvanceSearchJobViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    
    @IBAction func disabilityButtonAction(_ sender: AnyObject) {
        
        
        if disability {
            let checkedImage = UIImage(named: "Image_Checkbox") as UIImage?
            disabilityButton.setBackgroundImage(checkedImage, for: UIControlState())
            disability = false
        }else{
            let checkedImage = UIImage(named: "Image_Checkbox_Checked") as UIImage?
            disabilityButton.setBackgroundImage(checkedImage, for: UIControlState())
            disability = true
        }
        
    }
    
    func getAgeArray(_ type : String) -> NSMutableArray {
    
        let array = NSMutableArray()
        
        if type == "min" {
            array.add(0)
        }
        
        for age in 18...70 {
            array.add(age)
        }
        
        return array
    
    }
    
    func getMaxAgeArray(_ minAge : String) -> NSMutableArray {
        
        var array = NSMutableArray()
        
        if minAge == "" {
            array = ageMinArray
        }else{
            
            let minAgeInt = Int(minAge)!
        
            for age in minAgeInt...70 {
                array.add(age)
            }
        }
        
        return array
        
    }
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            ageYearLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageBtLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            disabledLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            ageBtLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            disabledLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobTypeTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            positionTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degreeMinTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degreeMaxTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            provinceTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sexTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageMinTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageMaxTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageYearLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)


        }else{
            
            ageYearLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageBtLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            disabledLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            ageBtLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            disabledLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobTypeTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            positionTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degreeMinTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degreeMaxTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            provinceTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sexTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageMinTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageMaxTxt?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageYearLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
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
        
        setNavigationItem()
        
        jobTypePickerView.delegate = self
        jobTypePickerView.dataSource = self
        degreeMinPickerView.delegate = self
        degreeMinPickerView.dataSource = self
        degreeMaxPickerView.delegate = self
        degreeMaxPickerView.dataSource = self
        provincePickerView.delegate = self
        provincePickerView.dataSource = self
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
        ageMinPickerView.delegate = self
        ageMinPickerView.dataSource = self
        ageMaxPickerView.delegate = self
        ageMaxPickerView.dataSource = self
        
        jobTypeTxt.inputView = jobTypePickerView
        degreeMinTxt.inputView = degreeMinPickerView
        degreeMaxTxt.inputView = degreeMaxPickerView
        provinceTxt.inputView = provincePickerView
        sexTxt.inputView = sexPickerView
        
        ageMinTxt.inputView = ageMinPickerView
        ageMaxTxt.inputView = ageMaxPickerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AdvanceSearchJobViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AdvanceSearchJobViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.activeTextField = sender
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            let originTextFieldY = self.activeTextField.frame.origin.y + (self.activeTextField.superview!.frame.origin.y) + (self.activeTextField.superview!.superview!.frame.origin.y)
            //print(originTextFieldY)
            if let keyboardHeight:CGFloat = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height {
//                print("keyboardHeight : \(keyboardHeight)")
//                print(view.frame.size.height - originTextFieldY - view.frame.size.height * 0.1)
                if ((view.frame.size.height - originTextFieldY - view.frame.size.height * 0.1) < keyboardHeight) && !isMove {
                    moveView =  (keyboardHeight - (view.frame.size.height - originTextFieldY)) + (view.frame.size.height * 0.1)
                    //print("moveView : \(moveView)")
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.view.frame.origin.y = (self.view.frame.origin.y - self.moveView)
                    })
                    isMove = true
                }
            }
        }
    }

    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        keyboardWillHide()
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.jobTypeTxt.resignFirstResponder()
            self.positionTxt.resignFirstResponder()
            self.degreeMinTxt.resignFirstResponder()
            self.degreeMaxTxt.resignFirstResponder()
            self.provinceTxt.resignFirstResponder()
            self.sexTxt.resignFirstResponder()
            self.ageMinTxt.resignFirstResponder()
            self.ageMaxTxt.resignFirstResponder()
            
            self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
        })
        moveView = 0;
        isMove = false

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJobType() -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(AdvanceSearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = masterDataHelper.getJobType()
            
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
    
    func getEducation() -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(AdvanceSearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = masterDataHelper.getEducation()
            
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
    
    func getProvince() -> NSMutableArray {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(AdvanceSearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case jobTypePickerView :
            return jobTypeArray.count
        case degreeMinPickerView :
            return educationArray.count
        case degreeMaxPickerView :
            return educationArray.count
        case provincePickerView :
            return provinceArray.count
        case sexPickerView :
            return sexArray.count
        case ageMinPickerView :
            return ageMinArray.count
        case ageMaxPickerView :
            return ageMaxArray.count
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case jobTypePickerView :
            let jobType = jobTypeArray.object(at: row) as! NSDictionary
            return jobType["DepartmentName"] as? String
        case degreeMinPickerView :
            let education = educationArray.object(at: row) as! NSDictionary
            return education["DegreeName"] as? String
        case degreeMaxPickerView :
            let education = educationArray.object(at: row) as! NSDictionary
            return education["DegreeName"] as? String
        case provincePickerView :
            let provice = provinceArray.object(at: row) as! NSDictionary
            return provice["ProvinceName"] as? String
        case sexPickerView :
            let sex = sexArray.object(at: row) as! NSDictionary
            return sex["SexName"] as? String
        case ageMinPickerView :
            let age = ageMinArray.object(at: row) as! NSNumber
            return "\(age)"
        case ageMaxPickerView :
            let age = ageMaxArray.object(at: row) as! NSNumber
            return "\(age)"

        default :
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case jobTypePickerView :
            let jobType = jobTypeArray.object(at: row) as! NSDictionary
            jobID = jobType["DepartmentId"] as! NSNumber
            jobTypeTxt.text = jobType["DepartmentName"] as! String
            
        case degreeMinPickerView :
            let degree = educationArray.object(at: row) as! NSDictionary
            degreeMinId = degree["DegreeId"] as! NSNumber
            degreeMinTxt.text = degree["DegreeName"] as! String
            
        case degreeMaxPickerView :
            let degree = educationArray.object(at: row) as! NSDictionary
            degreeMaxId = degree["DegreeId"] as! NSNumber
            degreeMaxTxt.text = degree["DegreeName"] as! String
            
        case provincePickerView :
            let province = provinceArray.object(at: row) as! NSDictionary
            provinceID = province["ProvinceID"] as! NSNumber
            provinceTxt.text = province["ProvinceName"] as! String
            
        case sexPickerView :
            let sex = sexArray.object(at: row) as! NSDictionary
            sexID = sex["SexID"] as! String
            sexTxt.text = sex["SexName"] as! String
            
        case ageMinPickerView :
            ageMinTxt.text = "\(ageMinArray.object(at: row) as! NSNumber)"
            
            if ageMaxTxt.text != "" {
                if Int(ageMaxTxt.text!) < Int(ageMinTxt.text!) {
                    ageMaxTxt.text = ""
                    ageMaxPickerView.reloadAllComponents()
                    ageMaxPickerView.selectRow(0, inComponent: 0, animated: false)
                }
            }
            
        case ageMaxPickerView :
            ageMaxTxt.text = "\(ageMaxArray.object(at: row) as! NSNumber)"
            
        default : break
            
            
        }
        
    }
    
    @IBAction func advanceSearchAction(_ sender: AnyObject) {
        
        jobList = jobListSearch()
        
        var employeeID = ""
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if let value = appDelegate.employee.object(forKey: "EmployeeID") as? String {
            employeeID = value
        }
        
        if hasLogin && employeeID != "" {
            
            
            performSegue(withIdentifier: "AdvanceJobSearchResultWithLoginSegue", sender: self)
            
        }else {
            
            performSegue(withIdentifier: "AdvanceJobSearchResultSegue", sender: self)
            
        }
        
    }
    
    
    func jobListSearch() -> NSDictionary {
        
        let jobSearchDetail = NSMutableDictionary()
        
        jobSearchDetail.setValue(positionTxt.text!, forKey: "JobPosition")
        jobSearchDetail.setValue(provinceID, forKey: "ProvinceID")
        jobSearchDetail.setValue(jobID, forKey: "DepartmentId")
        jobSearchDetail.setValue(degreeMinId, forKey: "DegreeMinId")
        jobSearchDetail.setValue(degreeMaxId, forKey: "DegreeMaxId")
        jobSearchDetail.setValue(sexID, forKey: "SexID")
        
        if ageMinTxt.text == "" {
            jobSearchDetail.setValue("0", forKey: "AgeMin")
        }else{
            jobSearchDetail.setValue(ageMinTxt.text!, forKey: "AgeMin")
        }
        
        if ageMaxTxt.text == "" {
            jobSearchDetail.setValue("70", forKey: "AgeMax")
        }else{
            jobSearchDetail.setValue(ageMaxTxt.text!, forKey: "AgeMax")
        }
        
        var disabilityString = ""
        if disability {
            disabilityString = "True"
        }else{
            disabilityString = "False"
        }
        jobSearchDetail.setValue(disabilityString, forKey: "Disability")
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(AdvanceSearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employeeHelper.jobListSearch(jobSearchDetail)
            
            loadingView.isHidden = true
            
            return resp
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSDictionary()
        }
        
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AdvanceJobSearchResultSegue" {
            let viewController:JobListViewController = segue.destination as! JobListViewController
            
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_SEARCH
            
            viewController.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
            viewController.jobListData = jobList
        }else if segue.identifier == "AdvanceJobSearchResultWithLoginSegue" {
            let viewController:JobOfEmployeeListViewController = segue.destination as! JobOfEmployeeListViewController
            
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_SEARCH
            
            viewController.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
            viewController.jobListData = jobList
        }
    }
    
    func pickerNext(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
            
        case 1 :
            positionTxt.becomeFirstResponder()
        case 2 :
            degreeMinTxt.becomeFirstResponder()
        case 3:
            degreeMaxTxt.becomeFirstResponder()
        case 4:
            provinceTxt.becomeFirstResponder()
        case 5:
            sexTxt.becomeFirstResponder()
        case 6:
            ageMinTxt.becomeFirstResponder()
        case 7:
            ageMaxTxt.becomeFirstResponder()
            
        default : break
            //print("Default")
        }
        
    }
    
    func pickerDone(){
        
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
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AdvanceSearchJobViewController.pickerDone))
        doneButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AdvanceSearchJobViewController.pickerNext(_:)))
        nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let clearTextButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AdvanceSearchJobViewController.clearTextAction))
        clearTextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        toolbar.isUserInteractionEnabled = true
        
        textFieldTag = textField.tag
        
        switch textField.tag {
            
        case 1 :
            
            
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            nextButton.tag = 1
            
            if jobTypeTxt.text == "" {
            
                let jobType = jobTypeArray.object(at: 0) as! NSDictionary
                jobID = jobType["DepartmentId"] as! NSNumber
                jobTypeTxt.text = jobType["DepartmentName"] as! String
            }
            
            
        case 2 :
            
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            nextButton.tag = 2
            
        case 3:
            
            nextButton.tag = 3
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            if degreeMinTxt.text == "" {
            
                let degreeMin = educationArray.object(at: 0) as! NSDictionary
                degreeMinTxt.text = degreeMin["DegreeName"] as! String
                
                degreeMinId = degreeMin["DegreeId"] as! NSNumber
            }
            
        case 4:
            
            nextButton.tag = 4
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            if degreeMaxTxt.text == "" {
                let degreeMax = educationArray.object(at: 0) as! NSDictionary
                degreeMaxTxt.text = degreeMax["DegreeName"] as! String
                
                degreeMaxId = degreeMax["DegreeId"] as! NSNumber
            }
            
        case 5:
            
            nextButton.tag = 5
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            if provinceTxt.text == "" {
                let province = provinceArray.object(at: 0) as! NSDictionary
                provinceTxt.text = province["ProvinceName"] as! String
                provinceID = province["ProvinceID"] as! NSNumber
            }
            
        case 6:
            
            nextButton.tag = 6
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            if sexTxt.text == "" {
                let sex = sexArray.object(at: 0) as! NSDictionary
                sexTxt.text = sex["SexName"] as! String
                sexID = sex["SexID"] as! String
            }
            
        case 7:
            nextButton.tag = 7
            toolbar.setItems([clearTextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            if ageMinTxt.text == "" {
                let age = ageMinArray.object(at: 0) as! NSNumber
                ageMinTxt.text = "\(age)"
            }
            
        case 8:
            nextButton.tag = 8
            
            if ageMinTxt.text != "" {
                ageMaxArray = getMaxAgeArray(ageMinTxt.text!)
            }else{
                ageMaxArray = getAgeArray("Max")
            }
            
            if ageMaxTxt.text == "" {
                let age = ageMaxArray.object(at: 0) as! NSNumber
                ageMaxTxt.text = "\(age)"
            }

            
            toolbar.setItems([clearTextButton], animated: false)
            textField.inputAccessoryView = toolbar
            
            
        default : break
            //print("Default")
            
            
        }
        
        return true
    }
    
    func clearTextAction() {
        switch textFieldTag {
        
        case 1 :
            jobTypeTxt.text = ""
            jobID = NSNumber()
            jobTypePickerView.selectRow(0, inComponent: 0, animated: false)
            jobTypeTxt.resignFirstResponder()
        case 2 :
            positionTxt.text = ""
            positionTxt.resignFirstResponder()
        case 3 :
            keyboardWillHide()
            degreeMinTxt.text = ""
            degreeMinId = NSNumber()
            degreeMinPickerView.selectRow(0, inComponent: 0, animated: false)
            degreeMinTxt.resignFirstResponder()
        case 4 :
            keyboardWillHide()
            degreeMaxTxt.text = ""
            degreeMaxId = NSNumber()
            degreeMaxPickerView.selectRow(0, inComponent: 0, animated: false)
            degreeMaxTxt.resignFirstResponder()
        case 5 :
            keyboardWillHide()
            provinceTxt.text = ""
            provinceID = NSNumber()
            provincePickerView.selectRow(0, inComponent: 0, animated: false)
            provinceTxt.resignFirstResponder()
        case 6 :
            keyboardWillHide()
            sexTxt.text = ""
            sexID = ""
            sexPickerView.selectRow(0, inComponent: 0, animated: false)
            sexTxt.resignFirstResponder()
        case 7 :
            keyboardWillHide()
            ageMinTxt.text = ""
            ageMinPickerView.selectRow(0, inComponent: 0, animated: false)
            ageMinTxt.resignFirstResponder()
        case 8 :
            keyboardWillHide()
            ageMaxTxt.text = ""
            ageMaxPickerView.selectRow(0, inComponent: 0, animated: false)
            ageMaxTxt.resignFirstResponder()
        default: break
            
        }
        
    }
    
    @IBAction func endTextField(_ textField : UITextField) {
        
        keyboardWillHide()
        
        let tag = textField.tag
        
        if tag >= 0 && tag < 15 {
            let nextTextField:UITextField = view.viewWithTag(tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endTextField(textField)
        return true
    }
    
    func getSuggestJobPosition(_ keyword : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(AdvanceSearchJobViewController.startIndicator), toTarget: self, with: nil)
        
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
    
    
}
