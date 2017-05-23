//
//  InternationalJobMenuViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 10/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InternationalJobMenuViewController: UIViewController  {
    
    @IBOutlet weak var sideMenuView: UIView!
    
    var sideMenuViewSize = CGSize()
    
    @IBOutlet weak var checkStatusNotLoginView: UIView!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var checkStatusView: UIView!
    @IBOutlet weak var checkStatusNotfound: UIView!
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    var smartjobLogoViewSize = CGSize()
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    var isSideMenuShow = false
    
    @IBOutlet weak var travelStatus: UILabel!
    @IBOutlet weak var memberStatus: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let nationalJobHelper = NationalJobHelper()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    
    // SideMenu outlet
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var smartJobLb: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var employeeProfileBt: UIButton!
    @IBOutlet weak var logoutBt: UIButton!
    @IBOutlet weak var loginBt: UIButton!
    
    let employeeHelper = EmployeeHelper()
    
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
        sideMenu(false)
        hideCheckStatusView()
    }
    
    
    @IBAction func doHideStatusView(_ sender: Any) {
        hideCheckStatusView()
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        
        hideCheckStatusView()
    }
    
    func hideCheckStatusView() {
    
        blackView.isHidden = true
        checkStatusNotLoginView.isHidden = true
        checkStatusView.isHidden = true
        checkStatusNotfound.isHidden = true
    
    }
    
    @IBAction func doCheckStatus(_ sender: Any) {
    
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if hasLogin == true {
            
            let employee = appDelegate.employee
            
            let accountStatusArray = employee.object(forKey: "StatusList") as! NSMutableArray
            
            for object in accountStatusArray {
                
                let accountStatus = object as! NSDictionary
                
                if accountStatus.object(forKey: "FunctionCode") as! String == "03" {
                    
                    let status = accountStatus.object(forKey: "StatusFlag") as! String
                    
                    
                    if status == "03" {
                        
                        blackView.isHidden = false
                        checkStatusNotfound.isHidden = false
                        
                        
                    }else{
                        blackView.isHidden = false
                        doCheckStatus()
                    }
                    
                }
                
            }

            
            
        
        }else {
            blackView.isHidden = false
            checkStatusNotLoginView.isHidden = false
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
            
            let userType = UserDefaults.standard.value(forKey: "userType") as? String
            
            if userType == "Employee" {
        
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
            
            }else{
            
                loginBt.isHidden = false
                logoutBt.isHidden = true
                employeeProfileBt.isHidden = true
                
                smartJobLb.isHidden = false
                employeeNameLb.isHidden = true
                
                logoImage.image = UIImage(named : "logoOnly")

            
            }
        
        }else {
        
            loginBt.isHidden = false
            logoutBt.isHidden = true
            employeeProfileBt.isHidden = true
            
            smartJobLb.isHidden = false
            employeeNameLb.isHidden = true
            
            logoImage.image = UIImage(named : "logoOnly")
        
        }
        
    }
    
    func doLogin(_ userCode : String , withPassword password: String) -> NSDictionary {
        
        var employee = NSDictionary();
        var soapResp = NSDictionary();
        
        do{
            try soapResp = employeeHelper.login(userCode, withPassword: password)
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                if resp["StatusID"] as! NSNumber == 1 {
                    let respBody = soapResp["RespBody"] as! NSMutableArray
                    employee = respBody.object(at: 0) as! NSDictionary
                    
                    appDelegate.employee = employee
                    appDelegate.usercode = userCode
                    
                    UserDefaults.standard.setValue(userCode, forKey: "usercode")
                    UserDefaults.standard.setValue(password, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "hasLogin")
                    UserDefaults.standard.setValue("Employee", forKey: "userType")
                    UserDefaults.standard.synchronize()
                    
                    
                    
                }else{
                    
                    let alertController = UIAlertController(title: "ไม่สามารถเข้าระบบได้", message:
                        "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
            }
        }catch {
            
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            //present(alertController, animated: true, completion: nil)
            
            
            
        }
        
        return employee
        
    }
    
    func doCheckStatus () {
    
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        let employee = appDelegate.employee
        
        let personalID = employee.object(forKey: "PersonalID") as? String
        
        if personalID != nil && personalID != "" {
        
            dispatchQueue.async {
                
                resp = self.getStatusWorkFund(idCard: employee.object(forKey: "PersonalID") as! String)
                
                OperationQueue.main.addOperation() {
                    
                    self.loadingView.isHidden = true
                    
                    if resp["RespBody"] != nil {
                        
                        let status = resp["RespStatus"] as! NSDictionary
                        
                        if status.object(forKey: "StatusID") as! Int == 1 {
                            
                            let respBody = resp["RespBody"] as! NSDictionary
                            
                            var tag = respBody.object(forKey: "TagStatus") as! String
                            let fund = respBody.object(forKey: "FundStatus") as! String
                            
                            let workStatus = self.nationalJobHelper.workStatus
                            let fundStatus = self.nationalJobHelper.fundStatus
                            
                            let tagInt = Int(tag)
                            let fundInt = Int(fund)
                            
                            if tagInt != nil {
                                self.travelStatus.text = workStatus.object(at: Int(tag)!) as? String
                            }else{
                                self.travelStatus.text = tag
                            }
                            
                            if fundInt != nil {
                                self.memberStatus.text = fundStatus.object(at: Int(fund)!) as! String
                            }else{
                                self.memberStatus.text = fund
                            }
                            
                            
                            self.checkStatusView.isHidden = false
                            
                        }else {
                            
                            self.checkStatusNotfound.isHidden = false
                            
                        }
                        
                        
                    }
                }
            }
            
        }else {
        
            self.loadingView.isHidden = true
            self.checkStatusNotfound.isHidden = false
        
        }
    
    }
    
    
    
    
    @IBAction func doLinkToRegisterTOEA(_ sender: Any) {
        
        UIApplication.shared.openURL(URL(string: "http://toea.doe.go.th")!)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        sideMenuAction(false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doCheckLogin()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        sideMenu(false)
        
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(hideCheckStatusView))
        
        //myView.addGestureRecognizer(tap)
        
        checkStatusNotfound.addGestureRecognizer(tap)
        checkStatusView.addGestureRecognizer(tap)
        checkStatusNotLoginView.addGestureRecognizer(tap)
        
        checkStatusNotfound.isUserInteractionEnabled = true
        checkStatusView.isUserInteractionEnabled = true
        checkStatusNotLoginView.isUserInteractionEnabled = true
        
        //sideMenuView.delegate = self
        
//        let viewFromNib: UIView? = Bundle.main.loadNibNamed("SideMenuView", owner: nil,options: nil)?.first as! UIView?
//        
//        sideMenuView.addSubview(viewFromNib!)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sideMenuViewSize = sideMenuView.frame.size
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "nationalJobLoginSegue" {
//        
//        let viewController:InsuredLoginViewController = segue.destination as! InsuredLoginViewController
//        
//        viewController.logingFrom = "NationalJob"
//            
//        }
    }
    
    func getStatusWorkFund(idCard : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalJobHelper.getStatusWorkFund(idCard: idCard)
            
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    
    @IBAction func doLogout(_ sender: Any) {
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
            self.sideMenuDetail(isLogin: false)
            self.sideMenu(false)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    

    

}
