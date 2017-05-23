//
//  EmployeeHomeViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/17/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeHomeViewController: UIViewController {
    
    var employee = NSDictionary()

    @IBOutlet weak var employeeNameTx: UILabel!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!

    @IBOutlet weak var loadingView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let keychainWrapper = KeychainWrapper()
    
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
        
        if self.navigationItem.title != nil {
        
            let attributes = [NSParagraphStyleAttributeName : style]
            
            label.attributedText = NSAttributedString(string: self.navigationItem.title! , attributes:attributes)
            
            
            self.navigationItem.titleView = label
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        employee = appDelegate.employee
        
        if let employeeFullName = employee["EmployeeFullName"] as? String {
        
            employeeNameTx.text = "\(employeeFullName)"
            
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        //self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.hidesBackButton = true
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            employeeNameTx?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 30)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 30)
            lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 25)
            
        }else
        {
            employeeNameTx?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 18)
            lb1?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 18)
            lb2?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb3?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            lb4?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToJobDetailView(_ sender: AnyObject) {
        
        backTwo()
        
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
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
