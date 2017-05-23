//
//  SideMenuView.swift
//  SmartJob
//
//  Created by SilVeriSm on 22/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

@objc protocol SideMenuProtocol {
    // protocol definition goes here
    func actionFindJob()
    func actionNationalJob()
    func actionInsuredJob()
    func actionLogin()
    func actionProfile()
    
    
}

class SideMenuView: UIView {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBInspectable var nibName:String?
    
    var delegate : SideMenuProtocol?
    
    let employeeHelper = EmployeeHelper()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var bt_Profile: UIButton!
    
    @IBOutlet var bt_Logout: UIButton!
    
    @IBOutlet var bt_Login: UIButton!
    
    @IBOutlet var image_Employee: UIImageView!
    
    @IBOutlet var image_Logo: UIImageView!
    
    
    @IBOutlet var lb_employeeName: UILabel!
    
    
    @IBOutlet var lb_text1: UILabel!
    
    @IBOutlet var lb_text2: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        checkLogin()
        
    }
    
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SideMenuView", bundle: bundle)
        return (nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView)!
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
        checkLogin()
    }
    
    @IBAction func clickFindJob(_ sender: Any) {
        delegate?.actionFindJob()
    }
    @IBAction func clickNationalJob(_ sender: Any) {
        delegate?.actionNationalJob()
    }
    @IBAction func clickEmptyJob(_ sender: Any) {
        delegate?.actionInsuredJob()
    }
    @IBAction func clickLogin(_ sender: Any) {
        delegate?.actionLogin()
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        
        if hasLogin {
            
            let userType = UserDefaults.standard.value(forKey: "userType") as? String
            
            if userType == "Employee" {
                let usercode = UserDefaults.standard.value(forKey: "usercode") as? String
                let password = UserDefaults.standard.value(forKey: "password") as? String
                
                var soapResp = NSDictionary()
                
                var employee = NSDictionary()
                
                
                do{
                    try soapResp = employeeHelper.login(usercode!, withPassword: password!)
                    
                    if soapResp.count > 0 {
                        
                        let resp = soapResp["RespStatus"] as! NSDictionary
                        
                        if resp["StatusID"] as! NSNumber == 1 {
                            let respBody = soapResp["RespBody"] as! NSMutableArray
                            employee = respBody.object(at: 0) as! NSDictionary
                            
                            appDelegate.employee = employee
                            appDelegate.usercode = usercode!
                            
                            UserDefaults.standard.setValue(usercode, forKey: "usercode")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            UserDefaults.standard.set(true, forKey: "hasLogin")
                            UserDefaults.standard.setValue("Employee", forKey: "userType")
                            UserDefaults.standard.synchronize()
                            
                            setUIVisible(isLogin: true)
                            
                        }
                    }
                }catch {
                    
                    
                    
                    let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                        "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                    
                    //present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                
            }
        }else{
            setUIVisible(isLogin: true)
        }
    }
    
    func setUIVisible(isLogin : Bool){
        if (isLogin) {
        
            bt_Login.isHidden = true
            
            bt_Profile.isHidden = false
            bt_Logout.isHidden = false
            
            lb_employeeName.isHidden = false
            image_Employee.isHidden = false
            
            lb_text1.isHidden = true
            lb_text2.isHidden = true
        
        }else{
        
            self.bt_Login.isHidden = false
            self.bt_Profile.isHidden = true
            self.bt_Logout.isHidden = true
            
            lb_employeeName.isHidden = true
            image_Employee.isHidden = true
            
            lb_text1.isHidden = false
            lb_text2.isHidden = false
        
        }
    }
}
