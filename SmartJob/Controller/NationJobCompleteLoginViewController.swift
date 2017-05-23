//
//  NationJobCompleteLoginViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 23/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationJobCompleteLoginViewController: UIViewController {

    @IBOutlet weak var employeeName: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        let employee = appDelegate.employee
        
        if let value = employee.object(forKey: "EmployeeFullName") as? String{
            employeeName.text = value
        }
        
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
