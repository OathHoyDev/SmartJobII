//
//  EmptyJobRegistrationViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 21/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsuredRegistrationViewController: UIViewController,UITextFieldDelegate, UIPickerViewDataSource ,UIPickerViewDelegate {
    
    @IBOutlet weak var loadingView: UIView!

    @IBOutlet weak var txNumber: UITextField!
    @IBOutlet weak var txId: UITextField!
    @IBOutlet weak var txJobProvince: UITextField!
    @IBOutlet weak var txJobPosition: UITextField!
    @IBOutlet weak var txEducation: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activeTextField : UITextField!
    
    let masterDataHelper = MasterDataHelper()
    let employeeHelper = EmployeeHelper()
    let empuiHelper = EmpuiHelper()
    
    
    var provinceArray = NSMutableArray()
    var provinceObj = NSDictionary()
    
    var educationArray = NSMutableArray()
    var educationObj = NSDictionary()
    
    var suggestJobArray = NSMutableArray()
    var suggestJobObject = NSDictionary()
    
    var suggestJobPickerView = UIPickerView()
    var provincePickerView = UIPickerView()
    var educationPickerView = UIPickerView()
    
    var suggestJobID = ""
    var provinceID = ""
    var educationID = ""
    
    var isMove = false
    var moveView = CGFloat()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    var employee = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txId.delegate = self
        
        
        //txNumber.delegate = self
        //txJobProvince.delegate = self
        txJobPosition.delegate = self
        //txEducation.delegate = self
        
        provincePickerView.delegate = self
        provincePickerView.dataSource = self
        
        educationPickerView.delegate = self
        educationPickerView.dataSource = self
        
        suggestJobPickerView.delegate = self
        suggestJobPickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        txJobProvince.inputView = provincePickerView
        txEducation.inputView = educationPickerView
        //txJobPosition.inputView = suggestJobPickerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        employee = appDelegate.employee
        
        prepareTextField()
        
        txId.text = employee.object(forKey: "PersonalID") as! String
        
        provinceArray.removeAllObjects()
        if let value = getProvince() as? NSMutableArray {
            provinceArray = value
        }
        
        educationArray.removeAllObjects()
        if let value = getEducation() as? NSMutableArray {
            educationArray = value
        }
        
        suggestJobArray.removeAllObjects()
        if let value = getSuggestJobPosition("") as? NSMutableArray {
            suggestJobArray = value
        }
        
        //getEmployeeDetail(employeeId: employee.object(forKey: "EmployeeID") as! String)
        
        
    }
    
    func prepareTextField(){
        
        txId.setFontSize()
        //txNumber.setFontSize()
        txJobProvince.setFontSize()
        txJobPosition.setFontSize()
        txEducation.setFontSize()
    
        txId.setLeftPaddingPoints(10)
        //txNumber.setLeftPaddingPoints(10)
        txJobProvince.setLeftPaddingPoints(10)
        txJobPosition.setLeftPaddingPoints(10)
        txEducation.setLeftPaddingPoints(10)
        
        txId.setRightPaddingPoints(10)
        //txNumber.setRightPaddingPoints(10)
        txJobProvince.setRightPaddingPoints(10)
        txJobPosition.setRightPaddingPoints(10)
        txEducation.setRightPaddingPoints(10)
        
    
    }
    @IBAction func saveRegisterAction(_ sender: Any) {
        
        let oneAccountFlag = true
        
        if (oneAccountFlag){
            performSegue(withIdentifier: "segueOnePassword", sender: sender)
        }else{
            performSegue(withIdentifier: "segueConfirmRegistration", sender: sender)
        }
        
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
        
        let nextButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let clearTextButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.clearTextField))
        clearTextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        toolbar.isUserInteractionEnabled = true
        
        toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
        
        if textField == txJobPosition && textField.inputView == suggestJobPickerView {
            let job = suggestJobArray.object(at: 0) as! NSDictionary
            suggestJobID =  "\(job.object(forKey: "JobPositionID") as! NSNumber)"
            txJobPosition.text = "\(job.object(forKey: "JobPositionName") as! String)"
        }
        
        textField.inputAccessoryView = toolbar
        
        self.activeTextField = textField
        
        return true
        
    }
    
    func clearTextField() {
        
        if activeTextField == txEducation {
        
            txEducation.resignFirstResponder()
            txEducation.becomeFirstResponder()
            txEducation.text = ""
            educationID = ""
        
        }else if activeTextField == txJobPosition {
            
            txJobPosition.resignFirstResponder()
            txJobPosition.inputView = nil
            txJobPosition.becomeFirstResponder()
            txJobPosition.text = ""
            suggestJobID = ""
            
        }else if activeTextField == txJobProvince {
            txJobProvince.resignFirstResponder()
            txJobProvince.becomeFirstResponder()
            txJobProvince.text = ""
            provinceID = ""
        }
        
        
        
        
    }
    
    
    
    func donePicker(){
        
        textFieldShouldReturn(self.activeTextField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txJobPosition && textField.inputView != suggestJobPickerView {
            
            
            suggestJobArray = ws_suggestJobPosition(keyword: txJobPosition.text!)
            
            if suggestJobArray.count > 0 {
                textField.resignFirstResponder()
                textField.inputView = suggestJobPickerView
                textField.becomeFirstResponder()
            }else{
                textField.inputView = nil
                let alertController = UIAlertController(title: "", message:
                    "ไม่พบตำแหน่งงานที่ค้นหา", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                keyboardWillHide()
                
                present(alertController, animated: true, completion: nil)
                
                
            }
            
        }else{
            textField.resignFirstResponder()
        }
        
        
        
        return true
    }
    @IBAction func doRegisterInsure(_ sender: Any) {
        
        registerInsured()
    }
    
    func checkInputParameter() -> Bool {
    
        if educationID == "" || suggestJobID == "" || provinceID == "" || employee.object(forKey: "PersonalID") as! String == "" {
        
            return false
        
        }else{
        
            return true
        }
    
    }
    
    func registerInsured() {
        
        var respBody = NSMutableArray()
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        if checkInputParameter() {
            
            dispatchQueue.async {
                
                do {
                    
                    resp = try self.empuiHelper.registerInsured(memberId: self.employee.object(forKey: "EmpuiMemberID") as! String , eduLevel: self.educationID, reqPositionName: self.suggestJobID , reqProvinceId: self.provinceID, nationalId: self.employee.object(forKey: "PersonalID") as! String)
                    
                }catch{
                    
                }
                
                OperationQueue.main.addOperation() {
                    
                    self.loadingView.isHidden = true
                    
                    let respStatus = resp["RespStatus"] as! NSDictionary
                    
                    if respStatus.object(forKey: "StatusID") as! Int == 1 {
                        
                        self.performSegue(withIdentifier: "insuredRegistrationCompleteSegue", sender: self)
                    
                    }else {
                    
                        let alertController = UIAlertController(title: "", message:
                            "\(respStatus.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)

                    
                    }
                    
                }
                
            }
            
        }else{
            
            self.loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "", message:
                "กรุณากรอกข้อมูลให้ครบถ้วน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        switch pickerView {
        case provincePickerView:
            return provinceArray.count
        case educationPickerView:
            return educationArray.count
        case suggestJobPickerView :
            return suggestJobArray.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case provincePickerView:
            let provice = provinceArray.object(at: row) as! NSDictionary
            return provice["PvName"] as? String
        case educationPickerView :
            let education = educationArray.object(at: row) as! NSDictionary
            return education["DegreeName"] as? String
        case suggestJobPickerView :
            let job = suggestJobArray.object(at: row) as! NSDictionary
            return job.object(forKey: "JobPositionName") as! String
        default:
            return ""
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case provincePickerView:
            let provice = provinceArray.object(at: row) as! NSDictionary
            txJobProvince.text = provice["PvName"] as? String
            provinceObj = provice
            
            provinceID = "\(provinceObj["PvId"] as! NSString)"
            
        case educationPickerView :
            let degree = educationArray.object(at: row) as! NSDictionary
            
            educationID = "\(degree["DegreeId"] as! NSNumber)"
            txEducation.text = degree["DegreeName"] as? String
            
        case suggestJobPickerView :
            let job = suggestJobArray.object(at: row) as! NSDictionary
            suggestJobID =  "\(job.object(forKey: "JobPositionID") as! NSNumber)"
            txJobPosition.text = "\(job.object(forKey: "JobPositionName") as! String)"
            
        default:
            break
        }

    }
    
    func getProvince () -> NSMutableArray {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = empuiHelper.getProvince()
            
            //loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            //loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
    }
    
    func ws_suggestJobPosition (keyword : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = masterDataHelper.getSuggestJobPosition(keyword)
            
            //loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            //loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
    }
    
    func getEducation () -> NSMutableArray {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = masterDataHelper.getEducation()
            
            //loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            //loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
    }
    
    func getSuggestJobPosition(_ keyword : String) -> NSMutableArray {
        
        var resp = NSDictionary()
        
        
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
    
    func getEmployeeDetail(employeeId : String) {
        
        var respBody = NSMutableArray()
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            do {
            
            resp = try self.employeeHelper.getEmployeeDetail(self.employee)
                
            }catch{
                
            }
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                respBody = resp["RespBody"] as! NSMutableArray
                
                self.setEmployeeDetail(employeeDetail: respBody.object(at: 0) as! NSDictionary)
                
            }
            
        }
        
        
        
    }
    
    func setEmployeeDetail(employeeDetail : NSDictionary) {
    
        txJobPosition.text = employeeDetail.object(forKey: "JobPosition") as! String
        txEducation.text = employeeDetail.object(forKey: "DegreeName") as! String
        
        if txEducation.text != "" {
            educationID = masterDataHelper.getKeyInArray(educationArray, withType: "NSNumber", byKeyName: "DegreeId", andValue: txEducation.text!, forDataName: "DegreeName")
            
        }
        
        if employeeDetail.object(forKey: "WorkProvinceID") != nil {
            
            let provinceId = employeeDetail.object(forKey: "WorkProvinceID") as! NSString
            
            txJobProvince.text = masterDataHelper.getValueInArray(provinceArray, withType: "NSTaggedPointerString", byKeyName: "PvId", andKeyValue: "\(provinceId)" , forDataName: "ProvinceName")
            
            
            provinceID = "\(provinceId)"
            
        }
    
    }
    
    func keyboardWillHide() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.txEducation.resignFirstResponder()
            self.txJobPosition.resignFirstResponder()
            self.txJobProvince.resignFirstResponder()
            
            self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
        })
        moveView = 0;
        isMove = false
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        keyboardWillHide()
        
    }


}
