//
//  ConfirmEmployeeRegisterViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/17/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class ConfirmEmployeeRegisterViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    var employeeProfile = NSDictionary()
    
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    let employeeHelper = EmployeeHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        self.navigationItem.backBarButtonItem?.title = "Back"
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
        
        //label.attributedText = NSAttributedString(string: self.navigationItem.title! , attributes:attributes)
        
        
        self.navigationItem.titleView = label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        setLayout()
        
    }
    
    func setLayout() {
    
        let style = NSMutableParagraphStyle()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            style.lineSpacing = 5
            style.minimumLineHeight = 25
            
            headerHeightConst.constant = 80
            
        }else{
            style.lineSpacing = 5
            style.minimumLineHeight = 20
            
            headerHeightConst.constant = 80
        }
        
        
        let attributesheader = [NSParagraphStyleAttributeName : style]
        
        detailView.attributedText = NSAttributedString(string: detailView.text!, attributes:attributesheader)
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        var soapResp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(ConfirmEmployeeRegisterViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try soapResp = employeeHelper.employeeRegistration(employeeProfile)
            
            loadingView.isHidden = true
            
            if soapResp.count > 0 {
                
                let resp = soapResp["RespStatus"] as! NSDictionary
                
//                print("Register Resp : \(resp)")
                
                if resp["StatusID"] as! NSNumber == 1 {
                    //let respBody = soapResp["RespBody"] as! NSMutableArray
                    
                    let alertController = UIAlertController(title: "ลงทะเบียนเรียบร้อยแล้ว", message:
                        "ลงทะเบียนเรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
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
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "ลงทะเบียนผิดพลาด", message:
                "\(error)", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func backToEmployeeLogin(_ sender: AnyObject) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    @IBAction func backToMainMenu(_ sender: AnyObject) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true);
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
