//
//  OnePasswordViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 22/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class OnePasswordForRegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var btCancel: UIButton!
    
    @IBOutlet weak var btCurrentPassword: UIButton!
    
    
    @IBOutlet weak var btNewPassword: UIButton!
    @IBOutlet weak var txConfirmNewPassword: UITextField!
    @IBOutlet weak var txNewPassword: UITextField!
    
    var employeeProfile = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let empuiHelper = EmpuiHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txConfirmNewPassword.setLeftPaddingPoints(10)
        txNewPassword.setLeftPaddingPoints(10)
        
        txConfirmNewPassword.setRightPaddingPoints(10)
        txNewPassword.setRightPaddingPoints(10)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func useCurrentPasswordAction(_ sender: Any) {
        txNewPassword.text = employeeProfile["Password"] as! String
        
        txConfirmNewPassword.text = employeeProfile["Password"] as! String
        
        btCurrentPassword.isHidden = true
        btCancel.isHidden = false
    }

    @IBAction func insertEmployeeRegisterAction(_ sender: Any) {
        performSegue(withIdentifier: "ConfirmRegistrationSegue", sender: self)
        //empuiRegistration()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController:ConfirmEmpuiRegistrationViewController = segue.destination as! ConfirmEmpuiRegistrationViewController
        
        viewController.employee = employeeProfile
    }
    
    func empuiRegistration(){
        var soapResp = NSDictionary()
        
        do{
            
            try soapResp = self.empuiHelper.empuiRegistration(employeeProfile)
            
            //loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
                //                print("Register Resp : \(resp)")
                
                if resp["StatusID"] as! NSNumber == 1 {
                    //let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    let alertController = UIAlertController(title: "ลงทะเบียนเรียบร้อยแล้ว", message:
                        "ลงทะเบียนเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                }else {
                    let errorMsg = resp["StatusMsg"] as! String
                    
                    let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                        "\(errorMsg)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
                    }))
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
                
            }else{
                
                let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                    "ลงทะเบียนผิดพลาด", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
                }))
                
                present(alertController, animated: true, completion: nil)
                
            }
            
        }catch {
            
            //loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                "\(error)", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func doCancel(_ sender: Any) {
        performSegue(withIdentifier: "MainMenuSegue", sender: self)
    }

}
