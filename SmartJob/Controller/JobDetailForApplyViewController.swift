//
//  JobDetailForApplyViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/10/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JobDetailForApplyViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var employeeMessageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var alreadyApplyJobConst: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var alreadyApplyJobLabel: UILabel!
    @IBOutlet weak var labelWidthConst: NSLayoutConstraint!
    @IBOutlet weak var labelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var headerDis: NSLayoutConstraint!
    
    @IBOutlet weak var labelForProfileNameHeightConst: NSLayoutConstraint!
    @IBOutlet weak var labelForProfileNameConst: NSLayoutConstraint!
    @IBOutlet weak var headerFrontConst: NSLayoutConstraint!
    @IBOutlet weak var jobDetailView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var sendMessageInfoLabel: UILabel!
    @IBOutlet weak var employerNameHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var sendMessageLabel: UIButton!
    var jobItem = NSDictionary()
    var jobDetail = NSDictionary()
    //var isJobFromApply = false
    
    var employeeID = ""
    var jobAnnounceID = ""
    var moveView = CGFloat()
    var isMove = false
    
    var activeTextField = UITextField()
    
    @IBOutlet weak var workProvinceLB: UILabel!
    @IBOutlet weak var degreeLB: UILabel!
    @IBOutlet weak var salaryLB: UILabel!
    @IBOutlet weak var sexLB: UILabel!
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var workingDayDescriptionLB: UILabel!
    @IBOutlet weak var jobFieldNameLB: UILabel!
    @IBOutlet weak var jobPositionLB: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var welfareLB: UITextView!
    @IBOutlet weak var personAllLB: UILabel!
    @IBOutlet weak var jobDescriptionLB: UITextView!
    @IBOutlet weak var jobCapLB: UILabel!
    
    @IBOutlet weak var workProvince: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var workingDayDescription: UILabel!
    @IBOutlet weak var jobFieldName: UILabel!
    @IBOutlet weak var jobPosition: UILabel!
    @IBOutlet weak var personAll: UILabel!
    @IBOutlet weak var welfare: UILabel!
    @IBOutlet weak var jobCap: UILabel!
    
    @IBOutlet weak var messageFromEmployerLb: UITextView!
    @IBOutlet weak var messageFromEmployeeTx: UITextField!
    
    let employeeHelper = EmployeeHelper()
    let masterDataHelper = MasterDataHelper()
    let memberHelper = MemberHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var haveMessage = false
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //Print frame here
        setViewHeight()
    }
    
    func setViewHeight() {
        
        var height : CGFloat = 0
        
        if haveMessage {
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                height = jobDetailView.frame.size.height + messageView.frame.size.height + 190
            }else{
                height = jobDetailView.frame.size.height + messageView.frame.size.height + 150
            }
        
            messageView.isHidden = false
            if messageFromEmployeeTx.text != "" {
                sendMessageInfoLabel.isHidden = true
                alreadyApplyJobConst.constant = -60
            }else{
                sendMessageInfoLabel.isHidden = false
            }
            
            alreadyApplyJobLabel.isHidden = false
            
        }else{
            
            let employee = appDelegate.employee
            
            let isApplyJob = employeeHelper.hasApplyThisJob(employee , withJob: "\(jobAnnounceID)")
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                height = jobDetailView.frame.size.height + 150
            }else{
                height = jobDetailView.frame.size.height + 100
            }
            
            if isApplyJob {
                
                alreadyApplyJobLabel.isHidden = false
                
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                {
                    alreadyApplyJobConst.constant = -300
                }else{
                    alreadyApplyJobConst.constant = -220
                }
                
                
                
            }else{
                alreadyApplyJobLabel.isHidden = true
            }
            
            messageView.isHidden = true
            sendMessageInfoLabel.isHidden = true
            
            
        
        }
        
        scrollView.contentSize.height = height
    
    }
    
    func getYourJobList(_ employee : NSDictionary) -> NSDictionary {
        
        var resp = NSDictionary()
        do{
            
            try resp = employeeHelper.getYourJobList(employee)
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
        return resp
        
    }


    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            headerDis.constant = 80
            headerFrontConst.constant = 50
            
//            labelWidthConst.constant = 200
//            labelHeightConst.constant = 40
            
            labelForProfileNameConst.constant = 140
            labelForProfileNameHeightConst.constant = 40
            
            employerNameHeightConst.constant = 65
            
            workProvinceLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degreeLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            salaryLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sexLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workingDayDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobFieldNameLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobPositionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            employerNameLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 27)
            welfareLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobCapLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            workProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degree?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            salary?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            age?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workingDayDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobFieldName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            personAll?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            personAllLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            welfare?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobCap?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            sendMessageInfoLabel.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            sendMessageLabel.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            messageFromEmployerLb.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            messageFromEmployeeTx.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)

            alreadyApplyJobLabel.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        }
        else
        {
            labelForProfileNameConst.constant = 80
            labelForProfileNameHeightConst.constant = 18
            
            headerDis.constant = 40
            headerFrontConst.constant = 30
            
            employerNameHeightConst.constant = 60
            
            workProvinceLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degreeLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            salaryLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sexLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workingDayDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobFieldNameLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobPositionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            employerNameLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 20)
            welfareLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobCapLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            workProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degree?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            salary?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            age?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workingDayDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobFieldName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            personAll?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            personAllLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            welfare?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobCap?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            sendMessageInfoLabel.font = UIFont(name: ServiceConstant.FONT_NAME, size: 17)
            sendMessageLabel.titleLabel!.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            messageFromEmployerLb.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            messageFromEmployeeTx.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            alreadyApplyJobLabel.font = UIFont(name: ServiceConstant.FONT_NAME, size: 17)
        }
    }
    
    func addCommaInSalary(_ salary : String) -> String {
        
        var largeNumber : NSNumber = 0
        
        if let number = Int(salary) {
            largeNumber = NSNumber(value: number as Int)
//            print(largeNumber)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        return numberFormatter.string(from: largeNumber)!
        
    }
    
    func setJobDetail() {
        
        let style = NSMutableParagraphStyle()
        let headerstyle = NSMutableParagraphStyle()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            style.lineSpacing = 5
            style.minimumLineHeight = 25
            
            headerstyle.lineSpacing = 5
            headerstyle.minimumLineHeight = 30
        }else{
            style.lineSpacing = 3
            style.minimumLineHeight = 15
            
            headerstyle.lineSpacing = 5
            headerstyle.minimumLineHeight = 25
        }
        
        
        let attributes = [NSParagraphStyleAttributeName : style]
        let attributesheader = [NSParagraphStyleAttributeName : headerstyle]
        
        employerNameLabel.text = jobDetail["EmployerName"] as? String
        employerNameLabel.attributedText = NSAttributedString(string: employerNameLabel.text!, attributes:attributesheader)
        
        jobPositionLB.text = jobDetail["JobPosition"] as? String
        jobPositionLB.attributedText = NSAttributedString(string: jobPositionLB.text!, attributes:attributes)

        var announceUpdate = jobDetail["AnnounceUpdate"] as! String
        announceUpdate = announceUpdate.substring(to: announceUpdate.range(of: " ")!.lowerBound)
        
        let announceUpdateArray = announceUpdate.components(separatedBy: "/")
        
        workingDayDescriptionLB.text = "\(Int(announceUpdateArray[0])!) \(masterDataHelper.getMonthNameFromInt(Int(announceUpdateArray[1])!)) \(Int(announceUpdateArray[2])!)"
        
        jobFieldNameLB.text = jobDetail["JobFieldName"] as? String
        jobCapLB.text = "\(jobDetail["PersonAll"] as! String) อัตรา"
        
        let ageMin = jobDetail["Age_Min"] as! String
        let ageMax = jobDetail["Age_Max"] as! String
        
        if ageMin == "" && ageMax == "" {
            ageLB.text = "-"
        }else if ageMin == "" {
            ageLB.text = "\(ageMax) ปี"
        }else if ageMax == "" {
            ageLB.text = "\(ageMin) ปี"
        }else {
            ageLB.text = "\(ageMin) - \(ageMax) ปี"
        }
        
        sexLB.text = jobDetail["Sex"] as? String
        
        let salaryMin = jobDetail["Wage_Min"] as! String
        let salaryMax = jobDetail["Wage_Max"] as! String
        
        if salaryMin == "" && salaryMax == "" {
            salaryLB.text = "-"
        }else if salaryMax == "" {
            salaryLB.text = "\(addCommaInSalary(salaryMin)) บาท"
        }else if salaryMin == "" {
            salaryLB.text = "\(addCommaInSalary(salaryMax)) บาท"
        }else {
            salaryLB.text = "\(addCommaInSalary(salaryMin)) - \(addCommaInSalary(salaryMax)) บาท"
        }
        
        let degreeMin = jobDetail["DegreeName_Min"] as! String
        let degreeMax = jobDetail["DegreeName_Max"] as! String
        
        var degreeText = ""
        
        if degreeMin == "" && degreeMax == "" {
            degreeText = "-"
        }else if degreeMax == "" {
            degreeText = "เริ่มต้น \(degreeMin)"
        }else if degreeMin == "" {
            degreeText = "สูงสุด \(degreeMax)"
        }else {
            degreeText = "\(degreeMin) - \(degreeMax)"
        }
        
        degreeLB.attributedText = NSAttributedString(string: degreeText, attributes:attributes)
        
        workProvinceLB.text = jobDetail["WorkProvinceName"] as? String
        
        let personAll = jobDetail["WorkExperience"] as! String
        personAllLB.text = "\(personAll) ปี"
        
        var welfare = ""
        
        if (jobDetail["Accommodate"] != nil && jobDetail["Accommodate"] as! String == "True"){
            welfare += "- ที่พัก \n"
        }
        
        if (jobDetail["SalaryIncrease"] != nil && jobDetail["SalaryIncrease"] as! String == "True"){
            welfare += "- ขึ้นเงินเดือน \n"
        }
        
        if (jobDetail["Bonus"] != nil && jobDetail["Bonus"] as! String == "True"){
            welfare += "- โบนัส \n"
        }
        
        if (jobDetail["SocialSecurity"] != nil && jobDetail["SocialSecurity"] as! String == "True"){
            welfare += "- ประกันสังคม \n"
        }
        
        if (jobDetail["BenefitOther"] as! String != ""){
            let benefitOther = jobDetail["BenefitOther"]!
            welfare += "- สวัสดิการอื่นๆ\n\(benefitOther)"
        }
        
        if welfare != "" {
            
            welfareLB.contentMode = UIViewContentMode.top
            welfareLB.attributedText = NSAttributedString(string: "\(welfare)", attributes:attributes)
            welfareLB.textColor = ServiceConstant.BAR_COLOR

            
        }else{
            welfareLB.text = "-"
        }
        
        jobDescriptionLB.text = jobDetail["JobDescription"] as! String
        
        jobDescriptionLB.attributedText = NSAttributedString(string: jobDescriptionLB.text!, attributes:attributes)
        jobDescriptionLB.textColor = ServiceConstant.BAR_COLOR
        
        setMessageFromEmployer(jobDetail)
        
        setFontSize()
        
    }
    
    func setMessageFromEmployer(_ jobDetail : NSDictionary) {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobDetailForApplyViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = memberHelper.getMsg(employeeID, withJobAnnounceID: jobAnnounceID, messageFlagEmp: "2")
            
            loadingView.isHidden = true
            
            let respArray = resp["RespBody"] as! NSMutableArray
            
            
            if respArray.count > 0 {
                let msgDict = respArray.object(at: 0) as! NSDictionary
                
                if msgDict["EmployerMsgDesc"] as! String != "" {
                    self.messageFromEmployerLb.text = msgDict["EmployerMsgDesc"] as! String
                    
                }
                
                if msgDict["EmployeeMsgDesc"] as! String != "" {
                    messageFromEmployeeTx.text = msgDict["EmployeeMsgDesc"] as! String
                    messageFromEmployeeTx.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
                    messageFromEmployeeTx.isUserInteractionEnabled = false
                    sendMessageLabel.isHidden = true
                    sendMessageInfoLabel.isHidden = true
                    employeeMessageWidthConst.constant = 0
                }
                
            }
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.jobAnnounceIDForNoti = ""
        appDelegate.employeeIDForNoti = ""
        appDelegate.employerIDForNoti = ""
        appDelegate.haveNotiFromBackground = false
        
        loadingView.isHidden = true
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        setJobDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(JobDetailForApplyViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        loadingView.isHidden = false
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loadingView.isHidden = false
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
        
        messageFromEmployerLb.layer.borderWidth = 1
        messageFromEmployerLb.layer.borderColor = ServiceConstant.BAR_COLOR.cgColor
        
        messageFromEmployeeTx.layer.borderWidth = 1
        messageFromEmployeeTx.layer.borderColor = ServiceConstant.BAR_COLOR.cgColor
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JobDetailForApplyViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let employee = appDelegate.employee
        
        employeeID = employee["EmployeeID"] as! String
        jobAnnounceID = String(describing: jobDetail["JobAnnounceID"] as! NSNumber)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMsgAction(_ sender: AnyObject) {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobDetailForApplyViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = memberHelper.insertMsg(employeeID, withJobAnnounceID: jobAnnounceID, messageBySender: "2", withMessage: messageFromEmployeeTx.text!)
            
            loadingView.isHidden = true
            
            let respStatus = resp["RespStatus"] as! NSDictionary
            let statusMsg = respStatus["StatusMsg"] as! String
            
            if respStatus["StatusID"] as! NSNumber == 1 {
                
                let alertController = UIAlertController(title: "ส่งข้อความเสร็จสิ้น", message:
                    "\(statusMsg)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                    self.messageFromEmployeeTx.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
                    self.messageFromEmployeeTx.isUserInteractionEnabled = false
                    self.sendMessageLabel.isHidden = true
                    self.sendMessageInfoLabel.isHidden = true
                    self.employeeMessageWidthConst.constant = 0
                    
                }))
                
                hideKeyboard()
                
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
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        
        hideKeyboard()
    }
    
    func hideKeyboard() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.messageFromEmployeeTx.resignFirstResponder()
            
            self.view.frame.origin.y = self.view.frame.origin.y + self.moveView
        })
        moveView = 0;
        isMove = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideKeyboard()
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(_ sender: Notification) {

        
        if let userInfo = sender.userInfo {
            
            if !isMove {
                moveView =  UIScreen.main.bounds.height/2 - (UIScreen.main.bounds.height * 0.2)
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.frame.origin.y = (self.view.frame.origin.y - self.moveView)
                })
                isMove = true
            }
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
