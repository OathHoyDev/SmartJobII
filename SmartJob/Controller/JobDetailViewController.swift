//
//  JobDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/16/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var alreadyApplyJobLabel: UILabel!
    @IBOutlet weak var headerDis: NSLayoutConstraint!
    @IBOutlet weak var headerFrontConst: NSLayoutConstraint!
    @IBOutlet weak var endHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var employerNameHeightConst: NSLayoutConstraint!
    @IBOutlet weak var endScrollViewConst: NSLayoutConstraint!
    @IBOutlet weak var labelWidthConst: NSLayoutConstraint!
    @IBOutlet weak var labelHeightConst: NSLayoutConstraint!
    var jobItem = NSDictionary()
    var jobDetail = NSDictionary()
    //var isJobFromApply = false
    
    @IBOutlet weak var jobProfileView: UIView!
    @IBOutlet weak var jobdetailView: UIView!
    @IBOutlet weak var jobdetailScrollView: UIScrollView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var benefitOtherLB: UILabel!
    @IBOutlet weak var workProvinceLB: UILabel!
    @IBOutlet weak var degreeLB: UILabel!
    @IBOutlet weak var salaryLB: UILabel!
    @IBOutlet weak var sexLB: UILabel!
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var workingDayDescriptionLB: UILabel!
    @IBOutlet weak var jobFieldNameLB: UILabel!
    @IBOutlet weak var jobPositionLB: UILabel!
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var jobDescriptionLB: UITextView!
    @IBOutlet weak var personAllLB: UILabel!
    @IBOutlet weak var welfareLB: UITextView!
    @IBOutlet weak var jobCapLB: UILabel!
    
    @IBOutlet weak var jobCap: UILabel!
    @IBOutlet weak var benefitOther: UILabel!
    @IBOutlet weak var workProvince: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var workingDayDescription: UILabel!
    @IBOutlet weak var jobFieldName: UILabel!
    @IBOutlet weak var jobPosition: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var personAll: UILabel!
    @IBOutlet weak var welfare: UILabel!
    
    let employeeHelper = EmployeeHelper()
    let masterDataHelper = MasterDataHelper()
    
    @IBOutlet weak var endOfProfileView: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let keychainWrapper = KeychainWrapper()
    
    var textfieldArray = NSMutableArray()
    
    @IBOutlet weak var alreadyApplyJob: UILabel!
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            headerDis.constant = 50
            headerFrontConst.constant = 50
            employerNameHeightConst.constant = 65
            endHeightConst.constant = 50
            
            labelHeightConst.constant = 40
            labelWidthConst.constant = 140
            
            benefitOtherLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workProvinceLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degreeLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            salaryLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sexLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workingDayDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobFieldNameLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobPositionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            employerNameLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 27)
            jobDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            personAllLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            welfareLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobCapLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            benefitOther?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            degree?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            salary?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            sex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            age?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            workingDayDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobFieldName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            personAll?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            welfare?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            jobCap?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            alreadyApplyJobLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        }
        else
        {
            endHeightConst.constant = 20
            
//            if UIScreen.mainScreen().bounds.size.width == 568.0 {
//                headerDis.constant = 40
//                headerFrontConst.constant = 30
//            }else{
//                headerDis.constant = 20
//                headerFrontConst.constant = 20
//            }
            headerDis.constant = 30
            headerFrontConst.constant = 30
            employerNameHeightConst.constant = 60
            
            labelHeightConst.constant = 18
            labelWidthConst.constant = 80
            
            benefitOtherLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workProvinceLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degreeLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            salaryLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sexLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            ageLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workingDayDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobFieldNameLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobPositionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            employerNameLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 20)
            jobDescriptionLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            personAllLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            welfareLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobCapLB?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            benefitOther?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            degree?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            salary?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            sex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            age?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            workingDayDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobFieldName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobDescription?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            personAll?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            personAll.adjustsFontSizeToFitWidth = true
            welfare?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            jobCap?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 12)
            
            alreadyApplyJobLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 17)
            
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
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //Print frame here
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        var result = false
        
        if hasLogin && userType == "Employee" {
            let employee = appDelegate.employee
            
            let jobAnnounceID = (jobDetail["JobAnnounceID"]) as! NSNumber
            
            result = employeeHelper.hasApplyThisJob(employee , withJob: "\(jobAnnounceID)")
            
            if result {
                
                applyButton.isHidden = true
                shareButton.isHidden = true
                alreadyApplyJobLabel.isHidden = false
            
                endScrollViewConst.constant = -applyButton.frame.size.height
            
            }
            
        }
        
        setViewHeight(result)
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
    
    
    
    func setViewHeight(_ isApply : Bool) {
        
        if isApply{
            jobdetailScrollView.contentSize.height = jobdetailView.frame.height + alreadyApplyJobLabel.frame.height
        }else{
            jobdetailScrollView.contentSize.height = jobdetailView.frame.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.jobAnnounceIDForNoti = ""
        appDelegate.employeeIDForNoti = ""
        appDelegate.employerIDForNoti = ""
        appDelegate.haveNotiFromBackground = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        loadingView.isHidden = true
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        setJobDetail()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        
        jobdetailScrollView.contentSize.height = jobdetailView.intrinsicContentSize.height
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    func applicationDidBecomeActive( _ application: UIApplication) {
        checkNoti()
    }
    
    func checkNoti() {
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if appDelegate.haveNotiFromBackground && userType == "Employee" {
            
            if appDelegate.employeeIDForNoti == appDelegate.employee["EmployeeID"] as! String {
                
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false);
                
            }else{
                
                appDelegate.jobAnnounceIDForNoti = ""
                appDelegate.employeeIDForNoti = ""
                appDelegate.employerIDForNoti = ""
                appDelegate.haveNotiFromBackground = false
                logout()
                
            }
            
        }
    }
    
    func logout() {
        
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        UserDefaults.standard.synchronize()
        
//        if keychainWrapper.myObjectForKey(kSecValueData) != nil {
//        
//            keychainWrapper.mySetObject(nil, forKey:kSecValueData)
//            keychainWrapper.writeToKeychain()
//            
//        }
        
        //        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        //        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKindOfClass(EmployeeLoginViewController) {
//                self.navigationController!.popToViewController(controller as UIViewController, animated: true)
//                break
//            }
//        }

        self.performSegue(withIdentifier: "ApplyJobSegue", sender: self)
        
    }

    
    @IBAction func applyJobAction(_ sender: AnyObject) {
        
        let employee = appDelegate.employee
        
        if employee.count > 0 {
            let alertController = UIAlertController(title: "สมัครงาน", message:
                "ยืนยันการสมัครงาน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                self.applyJob()
            }))
            alertController.addAction(UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.cancel,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            
            

        }else {
            
            let alertController = UIAlertController(title: "สมัครงาน", message:
                "กรุณาทำการ Login หรือลงทะเบียนก่อนทำการสมัครงาน", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                self.performSegue(withIdentifier: "ApplyJobSegue", sender: self)
            }))
            alertController.addAction(UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.cancel,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
    func applyJob(){
        
        let employee = appDelegate.employee
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(self.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employeeHelper.applyJob(jobDetail, withEmployee: employee)
            
            loadingView.isHidden = true
            
            let respStatus = resp["RespStatus"] as! NSDictionary
            let respMessage = respStatus["StatusMsg"] as! String
            if respStatus["StatusID"] as! NSNumber == 1 {
                
                loadingView.isHidden = true
                
                let alertController = UIAlertController(title: "สมัครงานเรียบร้อย", message:
                    "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                    self.viewWillAppear(true)
                }))
                
                present(alertController, animated: true, completion: nil)
                
            }else {
                
                loadingView.isHidden = true
            
                let alertController = UIAlertController(title: "สมัครงานผิดพลาด", message:
                    "\(respMessage)", preferredStyle: UIAlertControllerStyle.alert)
                
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
    
    func setJobDetail() {
        
        let style = NSMutableParagraphStyle()
        let headerstyle = NSMutableParagraphStyle()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            style.lineSpacing = 5
            style.minimumLineHeight = 25
            
            headerstyle.lineSpacing = 8
            headerstyle.minimumLineHeight = 30
        }else{
            style.lineSpacing = 5
            style.minimumLineHeight = 20
            
            headerstyle.lineSpacing = 8
            headerstyle.minimumLineHeight = 25
        }
        
        
        let attributes = [NSParagraphStyleAttributeName : style]
        let attributesheader = [NSParagraphStyleAttributeName : headerstyle]

        
        employerNameLabel.text = jobDetail["EmployerName"] as! String
        employerNameLabel.attributedText = NSAttributedString(string: employerNameLabel.text!, attributes:attributesheader)

        
        jobPositionLB.text = jobDetail["JobPosition"] as? String
        jobPositionLB.attributedText = NSAttributedString(string: jobPositionLB.text!, attributes:attributes)
        
        var announceUpdate = jobDetail["AnnounceUpdate"] as! String
        if announceUpdate != "" {
            announceUpdate = announceUpdate.substring(to: announceUpdate.range(of: " ")!.lowerBound)
       
            let announceUpdateArray = announceUpdate.components(separatedBy: "/")
            
            workingDayDescriptionLB.text = "\(Int(announceUpdateArray[0])!) \(masterDataHelper.getMonthNameFromInt(Int(announceUpdateArray[1])!)) \(Int(announceUpdateArray[2])!)"
        }else{
            workingDayDescriptionLB.text = "-"
        }
        
        
        
        
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
        
        degreeLB.text = degreeText
        degreeLB.attributedText = NSAttributedString(string: degreeLB.text!, attributes:attributes)
        
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
        
        let employee = appDelegate.employee
        
        if employee.count > 0 {
        
            let jobAnnounceID = (jobDetail["JobAnnounceID"]) as! NSNumber
            
            let isJobFromApply = employeeHelper.hasApplyThisJob(employee, withJob: "\(jobAnnounceID)")
            
            if isJobFromApply {
                shareButton.isHidden = true
                applyButton.isHidden = true
                alreadyApplyJobLabel.isHidden = false
            }else{
                shareButton.isHidden = false
                applyButton.isHidden = false
                alreadyApplyJobLabel.isHidden = true
            }
            
        }else{
            shareButton.isHidden = false
            applyButton.isHidden = false
            alreadyApplyJobLabel.isHidden = true
        }
        
        setFontSize()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ApplyJobSegue" {
            let view = segue.destination as! EmployeeLoginViewController
            view.jobDetail = jobDetail
        }
    }
    
    @IBAction func shareAction(_ sender: AnyObject) {
        
        let jobAnnounceID = jobDetail["JobAnnounceID"] as! NSNumber
        
        //let message = "\(jobDetail["JobPosition"] as! String) , \(jobDetail["EmployerName"] as! String) \nรายละเอียด : "
        //let img: UIImage = (UIImage(named: "share_icon") as UIImage?)!
        
        
        // for smartjob
        let myWebsite = URL(string:"\(ServiceConstant.SHARE_URL)/\(jobAnnounceID)")
        
        
        guard let url = myWebsite else {
//            print("nothing found")
            return
        }
        
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes =
            [UIActivityType.postToWeibo,
                UIActivityType.assignToContact,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.airDrop]
        

        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            if let pop = activityViewController.popoverPresentationController {
                let v = sender as! UIView // sender would be the button view tapped, but could be any view
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
            
        }
        
            
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
        activityViewController.completionHandler = {(activityType, completed:Bool) in
            if completed {
                let alertController = UIAlertController(title: "", message:
                    "แบ่งปันงานสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)

                return
            }
        }
            
        
        
    }
    
}
