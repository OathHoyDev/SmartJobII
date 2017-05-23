//
//  EmployeeDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/18/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var degreeHeightConst: NSLayoutConstraint!
    @IBOutlet weak var positionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var addressHeightConst: NSLayoutConstraint!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var textfieldHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textfieldWidthConst: NSLayoutConstraint!
    @IBOutlet weak var frontDetailConst: NSLayoutConstraint!
    @IBOutlet weak var topDetailConst: NSLayoutConstraint!
    @IBOutlet weak var frontTxSendMessage: NSLayoutConstraint!
    
    @IBOutlet weak var employerSendMessageLb: UITextField!
    @IBOutlet weak var employeeMessageLb: UITextView!
    @IBOutlet weak var employerMessageLb: UITextView!
    
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var departmentLb: UILabel!
    @IBOutlet weak var departmentCol: UILabel!
    @IBOutlet weak var degreeLb: UILabel!
    @IBOutlet weak var deegreeCol: UILabel!
    @IBOutlet weak var positionLb: UILabel!
    @IBOutlet weak var positionCol: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var addressCol: UILabel!
    @IBOutlet weak var sexLb: UILabel!
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var birthdateLb: UILabel!
    
    @IBOutlet weak var lb_departmentLb: UILabel!
    @IBOutlet weak var lb_degreeLb: UILabel!
    @IBOutlet weak var lb_positionLb: UILabel!
    @IBOutlet weak var lb_addressLb: UILabel!
    @IBOutlet weak var lb_sexLb: UILabel!
    @IBOutlet weak var lb_ageLb: UILabel!
    @IBOutlet weak var lb_nameLb: UILabel!
    @IBOutlet weak var lb_birthdateLb: UILabel!
    @IBOutlet weak var lb_phoneLb: UILabel!
    
    @IBOutlet weak var detailForSendMessageLabel: UILabel!
    
    var employee = NSDictionary()
    var jobAnnounceID = ""
    var haveMessage = false
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var receiveMessageView: UIView!
    @IBOutlet weak var employeeDetailView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var receiveMessageViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var messageLabelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var centerReceiveMessageConst: NSLayoutConstraint!
    @IBOutlet weak var employeeMessageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var employerMessageHeightConst: NSLayoutConstraint!
    var moveView = CGFloat()
    var isMove = false
    
    var activeTextField = UITextField()
    
    let memberHelper = MemberHelper()
    let masterDataHelper = MasterDataHelper()
    
    var messageFromEmployee = ""
    var messageFromEmployer = ""
    
    let monthArray = NSMutableArray()
    
    @IBOutlet weak var messageLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        
        
        //Print frame here
        setScrollViewHeight()
    }
    
    func getLabelHeight(_ lbLabel : UILabel) -> CGFloat{
    
        let contentSize = lbLabel.sizeThatFits(lbLabel.bounds.size)
        
        var height : CGFloat = 0
        
        if textfieldHeightConst.constant < contentSize.height {
            height = contentSize.height
        }else{
            height = textfieldHeightConst.constant
        }
        
        return height
    
    }
    
    func setScrollViewHeight(){
        
        
        
        degreeHeightConst.constant = getLabelHeight(lb_degreeLb)
        positionHeightConst.constant = getLabelHeight(lb_positionLb)
        addressHeightConst.constant = getLabelHeight(lb_addressLb)

        
        employeeDetailView.frame.size.height = detailView.frame.size.height + 50
        
//        print("detailView Height : \(detailView.frame.size.height)")
        
//        print("employeeDeatilView Height : \(employeeDetailView.frame.size.height)")
        
        
        var height : CGFloat = 0
        
        if haveMessage {
            
            height = receiveMessageView.frame.origin.y + receiveMessageView.frame.height + 50

            
            sendMessageView.isHidden = true
            
        }else {
            
            height = sendMessageView.frame.origin.y + sendMessageView.frame.height + 100
            
            sendMessageView.isHidden = false
            
        }
        
        scrollView.contentSize.height = height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.jobAnnounceIDForNoti = ""
        appDelegate.employeeIDForNoti = ""
        appDelegate.employerIDForNoti = ""
        appDelegate.haveNotiFromBackground = false
        
        loadingView.isHidden = true
        
        checkMessage()
        
        setEmployeeDetailToLabel(employee)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmployeeDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func creatMonthArray() {
    
        monthArray.insert("มกราคม", at: 0)
        monthArray.insert("กุมภาพันธ์", at: 1)
        monthArray.insert("มีนาคม", at: 2)
        monthArray.insert("เมษายน", at: 3)
        monthArray.insert("พฤษภาคม", at: 4)
        monthArray.insert("มิถุนายน", at: 5)
        monthArray.insert("กรกฎาคม", at: 6)
        monthArray.insert("สิงหาคม", at: 7)
        monthArray.insert("กันยายน", at: 8)
        monthArray.insert("ตุลาคม", at: 9)
        monthArray.insert("พฤศจิกายน", at: 10)
        monthArray.insert("ธันวาคม", at: 11)
    
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        creatMonthArray()
        
        
        
        employerSendMessageLb.layer.borderWidth = 1
        employerSendMessageLb.layer.borderColor = ServiceConstant.BAR_COLOR.cgColor
        
        employeeMessageLb.layer.borderWidth = 1
        employeeMessageLb.layer.borderColor = ServiceConstant.BAR_COLOR.cgColor
        
        employerMessageLb.layer.borderWidth = 1
        employerMessageLb.layer.borderColor = ServiceConstant.BAR_COLOR.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmployeeDetailViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    func checkMessage() {
        
        var resp = NSDictionary()
        
        do {
            
            resp = try memberHelper.getMsg(String(describing: employee["EmployeeID"] as! NSNumber), withJobAnnounceID: jobAnnounceID, messageFlagEmp: "1")
            
            loadingView.isHidden = true
            
            let respArray = resp["RespBody"] as! NSMutableArray
            
            
            if respArray.count > 0 {
                let msgDict = respArray.object(at: 0) as! NSDictionary
                
                if msgDict["EmployerMsgDesc"] as! String != "" {
                    messageFromEmployer = msgDict["EmployerMsgDesc"] as! String
                }
                
                if msgDict["EmployeeMsgDesc"] as! String != "" {
                    employeeMessageLb.isHidden = false
                    messageFromEmployee = msgDict["EmployeeMsgDesc"] as! String
                    if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                    {
                        receiveMessageViewHeightConst.constant = 250
                    }else{
                        receiveMessageViewHeightConst.constant = 175
                    }
                }else{
                    receiveMessageViewHeightConst.constant = 100
                    centerReceiveMessageConst.constant = receiveMessageViewHeightConst.constant / 6
                    employeeMessageHeightConst.constant = 0.1
                    employerMessageHeightConst.constant = 0.8
                    employeeMessageLb.isHidden = true
                    
                }
                
            }
            
            if messageFromEmployer != "" || messageFromEmployee != "" {
                haveMessage = true
            }else{
                haveMessage = false
            }
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        if haveMessage {
            sendMessageView.isHidden = true
            detailForSendMessageLabel.isHidden = true
            receiveMessageView.isHidden = false
        }else{
            sendMessageView.isHidden = false
            detailForSendMessageLabel.isHidden = false
            receiveMessageView.isHidden = true
        }
    
    }
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            textfieldHeightConst.constant = 40
            textfieldWidthConst.constant = 160
            frontDetailConst.constant = 40
            topDetailConst.constant = 40
            
            frontTxSendMessage.constant = 50
            
            //receiveMessageViewHeightConst.constant = 250
            
            phoneLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            departmentLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degreeLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            positionLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            addressLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sexLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            nameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            birthdateLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            lb_departmentLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_degreeLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_positionLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_addressLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_sexLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_ageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_nameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_birthdateLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            lb_phoneLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            sendMessageButton?.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            employeeMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            employerMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            employerSendMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            detailForSendMessageLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            
            messageLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 23)
            messageLabelHeightConst.constant = 35
            
        }else{
            
            //textfieldHeightConst.constant = 25
            //textfieldWidthConst.constant = 80
            frontDetailConst.constant = 25
            topDetailConst.constant = 25
            
            //receiveMessageViewHeightConst.constant = 175
            
            phoneLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            departmentLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degreeLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            positionLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            addressLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sexLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            nameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            birthdateLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            lb_departmentLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_degreeLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_positionLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_addressLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_sexLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_ageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_nameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_birthdateLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            lb_phoneLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            sendMessageButton?.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            employeeMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            employerMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            employerSendMessageLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            detailForSendMessageLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 17)
            
            messageLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 13)
            messageLabelHeightConst.constant = 25
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heightForView(_ text:String , with targetLabel : UILabel) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: targetLabel.frame.width , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = targetLabel.font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func setEmployeeDetailToLabel(_ employee : NSDictionary) {
        
        let style = NSMutableParagraphStyle()
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            //style.lineSpacing = 5
            style.minimumLineHeight = 25
        }else{
            //style.lineSpacing = 5
            style.minimumLineHeight = 17
        }
        let attributes = [NSParagraphStyleAttributeName : style]
        
        positionLb.attributedText = NSAttributedString(string: positionLb.text! , attributes:attributes)
        
        lb_departmentLb.text = employee["DepartmentName"] as! String
        
        lb_degreeLb.text = employee["DegreeName"] as! String
        lb_degreeLb.attributedText = NSAttributedString(string: lb_degreeLb.text!, attributes:attributes)
        //lb_degreeLb.sizeToFit()
        
        lb_positionLb.text = employee["JobPosition"] as! String
        lb_positionLb.attributedText = NSAttributedString(string: lb_positionLb.text!, attributes:attributes)
        //lb_positionLb.sizeToFit()
        
        lb_addressLb.text = employee["Address"] as! String
        lb_addressLb.attributedText = NSAttributedString(string: lb_addressLb.text!, attributes:attributes)
        //lb_addressLb.sizeToFit()
        
        lb_sexLb.text = employee["Sex"] as! String
        lb_ageLb.text = "\(employee["Age"] as! String) ปี"
        lb_nameLb.text = employee["EmployeeFullName"] as! String
        
        let birthDate = employee["BirthDate"] as! String
        let birthDay =  birthDate.substring(to: birthDate.range(of: " ")!.lowerBound)
        
        let birthDateArray = birthDay.components(separatedBy: "-")
        
        lb_birthdateLb.text = "\(Int(birthDateArray[2])!) \(masterDataHelper.getMonthNameFromInt(Int(birthDateArray[1])!)) \(Int(birthDateArray[0])! + 543)"
        lb_phoneLb.text = employee["Telephone"] as! String
        
        if haveMessage {
            receiveMessageView.isHidden = false
            employeeMessageLb.text = messageFromEmployee
            employeeMessageLb.textAlignment = NSTextAlignment.left
//            employeeMessageLb.userInteractionEnabled = false
            
            employerMessageLb.text = messageFromEmployer
            employerMessageLb.textAlignment = NSTextAlignment.left
//            employerMessageLb.userInteractionEnabled = false
            
            employeeMessageLb.isEditable = false
            employerMessageLb.isEditable = false
        }
        
        setFontSize()
    }
    
    @IBAction func touchToTextview(_ sender: UITextField) {
        
        self.self.activeTextField = sender
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            let originTextFieldY = self.activeTextField.frame.origin.y + (self.activeTextField.superview!.frame.origin.y) + (self.activeTextField.superview!.superview!.frame.origin.y)
//            print(originTextFieldY)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        hideKeyboard()
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        
        hideKeyboard()
    }
    
    func hideKeyboard() {
    
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.employerSendMessageLb.resignFirstResponder()
            
            self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
        })
        moveView = 0;
        isMove = false
    
    }
    
    @IBAction func sendMsgAction(_ sender: AnyObject) {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(EmployeeDetailViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = memberHelper.insertMsg(String(describing: employee["EmployeeID"] as! NSNumber), withJobAnnounceID: jobAnnounceID, messageBySender: "1", withMessage: employerSendMessageLb.text!)
            
            loadingView.isHidden = true
            
            let respStatus = resp["RespStatus"] as! NSDictionary
            let statusMsg = respStatus["StatusMsg"] as! String
            
            if respStatus["StatusID"] as! NSNumber == 1 {
            
                let alertController = UIAlertController(title: "ส่งข้อความเสร็จสิ้น", message:
                    "\(statusMsg)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                    self.sendMessageView.isHidden = true
                    self.detailForSendMessageLabel.isHidden = true
                    self.receiveMessageView.isHidden = false
                    self.employerMessageLb.text = self.employerSendMessageLb.text
                    self.employerMessageLb.isEditable = false
                }))
                
                self.hideKeyboard()
                
                present(alertController, animated: true, completion: nil)
                
            }else{
            
                let alertController = UIAlertController(title: "การส่งข้อความผิดพลาด", message:
                    "\(statusMsg)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                present(alertController, animated: true, completion: nil)
            
            }
            
            
        
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            

        
        }
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
