//
//  EmployerHomeViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/9/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployerHomeViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var employerBranchNameLb: UILabel!
    @IBOutlet weak var employerNameLb: UILabel!
    
    var employer = NSDictionary()
    var branch = NSDictionary()
    var justLogin = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let keychainWrapper = KeychainWrapper()
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        //self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.hidesBackButton = true
        
        checkLogin()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            employerBranchNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            employerNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 30)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 33)
            lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb5?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            
        }else
        {
            employerBranchNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 13)
            employerNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 17)
            lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 13)
            lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 13)
            lb5?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 13)
            
        }
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        let userType = UserDefaults.standard.string(forKey: "userType")
        
        if hasLogin && userType == "Employee" && (justLogin == false) {
            UIView.setAnimationsEnabled(false)
            performSegue(withIdentifier: "employeeApplySegue", sender: self)
        }else {
            UIView.setAnimationsEnabled(true)
            setEmployerDetail()
        }
        
    }
    
    func startIndicator() {
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
        
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        //setNavigationItem()
        
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
        
        Thread.detachNewThreadSelector(#selector(EmployerHomeViewController.startIndicator), toTarget: self, with: nil)
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if userType == "Employer" && appDelegate.haveNotiFromBackground {
            
            if appDelegate.employerIDForNoti == appDelegate.employer["EmployerID"] as! String {
                
                performSegue(withIdentifier: "employeeApplySegue", sender: self)
                
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
    
        appDelegate.employer = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        UserDefaults.standard.setValue(nil, forKey: "branchID")
        UserDefaults.standard.synchronize()
        
//        if keychainWrapper.myObjectForKey(kSecValueData) != nil {
//            
//            keychainWrapper.mySetObject(nil, forKey:kSecValueData)
//            keychainWrapper.writeToKeychain()
//            
//        }
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: EmployerLoginViewController.self) {
                self.navigationController!.popToViewController(controller as UIViewController, animated: true)
                break
            }
        }
    
    }
    
    
    
    func setEmployerDetail() {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 15
        style.alignment = NSTextAlignment.center
        let attributes = [NSParagraphStyleAttributeName : style]
        
        employer = appDelegate.employer
        branch = appDelegate.branch
        
        employerNameLb.text = employer["EmployerFullName"] as! String
        employerNameLb.attributedText = NSAttributedString(string: employerNameLb.text! , attributes:attributes)
        
        var branchName = ""
        if branch.count > 0{
            branchName = branch["BranchName"] as! String
            employerBranchNameLb.text = "สาขา \(branchName)"
        }else{
            employerBranchNameLb.text = ""
        }
        
        employerBranchNameLb.attributedText = NSAttributedString(string: employerBranchNameLb.text! , attributes:attributes)
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        Thread.detachNewThreadSelector(#selector(EmployerHomeViewController.startIndicator), toTarget: self, with: nil)
        
        if segue.identifier == "employeeApplySegue" {
            let viewController:EmployeeGroupListViewController = segue.destination as! EmployeeGroupListViewController
            viewController.employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_APPLY
            
        }else if segue.identifier == "employeeMatchingSegue" {
            let viewController:EmployeeGroupListViewController = segue.destination as! EmployeeGroupListViewController
            viewController.employeeGroupType = ServiceConstant.EMPLOYEE_GROUP_TYPE_MATCHING
            
        }
    }
    

}
