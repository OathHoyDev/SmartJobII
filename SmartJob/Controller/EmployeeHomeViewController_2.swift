//
//  EmployeeHomeViewController_2.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/17/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeHomeViewController_2: UIViewController , UIApplicationDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    var employee = NSDictionary()
    var justLogin = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let keychainWrapper = KeychainWrapper()
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func checkLogin() {
        
        var employeeID = ""
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        if let value = appDelegate.employee.object(forKey: "EmployeeID") as? String {
            employeeID = value
        }
        
        if hasLogin && employeeID != "" && (justLogin == false){
            
            UIView.setAnimationsEnabled(false)
            performSegue(withIdentifier: "YourJobSegue", sender: self)
            //UIView.setAnimationsEnabled(true)
        }else{
            self.navigationItem.hidesBackButton = true
            UIView.setAnimationsEnabled(true)
            justLogin = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        //self.navigationItem.backBarButtonItem?.title = "Back"
        
        checkLogin()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
        employeeNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 30)
        lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 30)
        lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
        lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            
        }else
        {
            employeeNameLb?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 18)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 18)
            lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            
        }
    }
    
    func setNavigationItem() {
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.alignment = NSTextAlignment.center
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: (self.navigationController?.navigationBar.frame.height)! ))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: ServiceConstant.FONT_NAME, size: 20)!
        
        let attributes = [NSParagraphStyleAttributeName : style]
        
        //label.attributedText = NSAttributedString(string: self.navigationItem.title! , attributes:attributes)
        
        
        self.navigationItem.titleView = label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        employee = appDelegate.employee
        
        if let value = employee["EmployeeFullName"] as? String {
        
            employeeNameLb.text = "\(value)"
            
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidBecomeActive( _ application: UIApplication) {
        checkNoti()
    }
    
    func checkNoti() {
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if appDelegate.haveNotiFromBackground && userType == "Employee" {
            
            if appDelegate.employeeIDForNoti == appDelegate.employee["EmployeeID"] as! String {
                
                performSegue(withIdentifier: "JobMatchingSegue", sender: self)
                
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
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: EmployeeLoginViewController_2.self) {
                self.navigationController!.popToViewController(controller as UIViewController, animated: true)
                break
            }
        }
        
    }
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        Thread.detachNewThreadSelector(#selector(EmployeeHomeViewController_2.startIndicator), toTarget: self, with: nil)
        
        if segue.identifier == "JobMatchingSegue" {
            let viewController:JobOfEmployeeListViewController = segue.destination as! JobOfEmployeeListViewController
            viewController.employee = employee
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_MATCHING
            
            viewController.title = ServiceConstant.TITLE_JOB_MATCHING
        }else if segue.identifier == "YourJobSegue" {
            let viewController:JobOfEmployeeListViewController = segue.destination as! JobOfEmployeeListViewController
            viewController.employee = employee
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_YOUR_JOB
            viewController.title = ServiceConstant.TITLE_YOUR_JOB
        }
    }
    
    
}
