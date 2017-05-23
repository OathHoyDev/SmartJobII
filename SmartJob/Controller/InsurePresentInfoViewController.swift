//
//  InsurePresentInfoViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 29/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsurePresentInfoViewController: UIViewController , UITextFieldDelegate  {

    @IBOutlet weak var loadingView: UIView!
    
    var item = NSDictionary()
    var sequence = ""
    
    @IBOutlet weak var presentId: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var presentNo: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var presentDate: UILabel!
    @IBOutlet weak var actualPresentDate: UILabel!
    
    @IBOutlet weak var noJobBt: UIButton!
    @IBOutlet weak var haveJobBt: UIButton!
    
    @IBOutlet weak var jobPlaceName: UITextField!
    @IBOutlet weak var jobAddress: UITextField!
    @IBOutlet weak var jobPhone: UITextField!
    @IBOutlet weak var jobContact: UITextField!
    @IBOutlet weak var jobStartDate: UITextField!
    
    @IBOutlet weak var presentBt: UIButton!
    
    var actualDatePicker = UIPickerView()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var isKeyboardShow = false
    var moveView = CGFloat()
    var activeTextField : UITextField!
    
    let employeeHelper = EmployeeHelper()
    
    let datePickerView = UIPickerView()
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()
    
    var isHaveJob = ""

    
    override func viewWillDisappear(_ animated: Bool) {
        
        hideKeyboard()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBackPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    func prepareData(){
    
        presentId.text = item["register_no"] as? String
        registerDate.text = item["create_date"] as? String
        
        name.text = item["first_name"] as? String
        name.text?.append(" ")
        name.text?.append((item["last_name"] as? String)!)
        
        presentNo.text = item["tacking_next_sequence"] as? String
        address.text = item["branch_group_name"] as? String
        
        if let fullPresentDate = (item["tacking_date"] as? String)?.components(separatedBy: " "){
            presentDate.text = fullPresentDate[0]
        }
        
    
    }

    @IBAction func doHaveJob(_ sender: Any) {
        jobPlaceName.isHidden = false
        jobAddress.isHidden = false
        jobPhone.isHidden = false
        jobContact.isHidden = false
        jobStartDate.isHidden = false
        
        haveJobBt.setBackgroundImage(UIImage(named: "radio_check"), for: .normal)
        
        noJobBt.setBackgroundImage(UIImage(named: "radio_uncheck"), for: .normal)
        
        isHaveJob = "1"
    }
    @IBAction func doNoJob(_ sender: Any) {
        jobPlaceName.isHidden = true
        jobAddress.isHidden = true
        jobPhone.isHidden = true
        jobContact.isHidden = true
        jobStartDate.isHidden = true
        
        self.jobPlaceName.text = ""
        self.jobAddress.text = ""
        self.jobPhone.text = ""
        self.jobContact.text = ""
        self.jobStartDate.text = ""

        
        haveJobBt.setBackgroundImage(UIImage(named: "radio_uncheck"), for: .normal)
        
        noJobBt.setBackgroundImage(UIImage(named: "radio_check"), for: .normal)
        
        isHaveJob = "0"
    }
    @IBAction func changeActualDate(_ sender: UITextField) {
        
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        jobStartDate.text = dateFormatter.string(from: sender.date)
        
        if !isKeyboardShow {
            keyboardWillShow(jobStartDate)
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
        
        let nextButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.hideKeyboard))
        nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        toolbar.isUserInteractionEnabled = true
        toolbar.setItems([spaceButton , nextButton], animated: false)
        
        
        if textField == jobStartDate {
            textField.inputAccessoryView = toolbar
        }
        
        self.activeTextField = textField

        keyboardWillShow(textField)
        
        return true
    }
    
    
    
    func keyboardWillShow(_ textField: UITextField) {
        
        self.view.frame.origin.y = 0
        
        let textfieldFrampoint = textField.superview?.convert(textField.frame.origin, to: nil)
        
        let centerY = screenHeight*0.5
        
        
        if (textfieldFrampoint?.y)! > centerY {
            moveConstraint = (textfieldFrampoint?.y)! - centerY
            
        }else {
            moveConstraint = 0
            
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.frame.origin.y = 0 - CGFloat(self.moveConstraint)
            self.isKeyboardShow = true
            
        })
    }
    
    
    
    func hideKeyboard(){
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.jobPlaceName.resignFirstResponder()
            self.jobAddress.resignFirstResponder()
            self.jobPhone.resignFirstResponder()
            self.jobContact.resignFirstResponder()
            self.jobStartDate.resignFirstResponder()
            
            
            self.view.frame.origin.y = 0
            self.isKeyboardShow = false
        })
        
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        self.activeTextField = sender
    }
    
    @IBAction func doUpdateInsured(_ sender: Any) {
        
        if let jobDate = jobStartDate.text as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let trackingDate = dateFormatter.date(from: item["tacking_date"] as! String)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var isReportSix = "false"
            
            if sequence == "6" {
                isReportSix = "true"
            }
            
            wsUpdateInsured(memberId: item.object(forKey: "member_id") as! String,
                            regId: item.object(forKey: "id") as! String,
                            results: isHaveJob,
                            regDate: dateFormatter.string(from: trackingDate!) ,
                            jobDate: jobDate,
                            company: jobPlaceName.text!,
                            compAddress: jobAddress.text!,
                            compMobileNo: jobPhone.text!,
                            compContract: jobContact.text!,
                            empID: item.object(forKey: "member_id") as! String ,
                            isReport6th: isReportSix)
            
        } else {
        
            let alertController = UIAlertController(title: "ไม่สามารถบันทึกข้อมูลได้", message:
                "ระบุข้อมูลไม่ครบถ้วน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)

        
        }
    }
    
    func wsUpdateInsured (memberId : String , regId : String , results : String , regDate : String , jobDate : String , company : String , compAddress : String , compMobileNo : String , compContract : String , empID : String , isReport6th : String) -> NSDictionary {
    
    
        var resp = NSDictionary()
        
        do{
            
            try resp = self.employeeHelper.updateInsured(memberId: memberId, regId: regId, results: results, regDate: regDate, jobDate: jobDate, company: company, compAddress: compAddress, compMobileNo: compMobileNo, compContract: compContract, empID: empID, isReport6th: isReport6th)
            
            let respStatus = resp.object(forKey: "RespStatus") as! NSDictionary
            
            if respStatus.object(forKey: "StatusID") as! NSNumber == 1 {
            
                let alertController = UIAlertController(title: "บันทึกข้อมูลเสร็จสิ้น", message:
                    "บันทึกข้อมูลเสร็จสิ้น", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {
                
                    (action:UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                
                }))
                
                self.present(alertController, animated: true, completion: nil)

            
            }else {
            
                let alertController = UIAlertController(title: "ไม่สามารถบันทึกข้อมูลได้", message:
                    "\(respStatus.object(forKey: "StatusMsg") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            
            }
            
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp

    
    }
    
    

}
