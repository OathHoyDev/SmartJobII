//
//  InsuredCompleteLoginViewController.swift
//
//
//  Created by SilVeriSm on 23/4/2560 .
//
//

import UIKit

class InsuredCompleteLoginViewController: UIViewController {
    
    @IBOutlet weak var employeeName: UILabel!
    var employee = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let employee = appDelegate.employee
        
        var fullName = ""
        
        
        if let name = employee.object(forKey: "EmpuiFirstname") as? String {
            fullName = "\(name)"
        }
        if let lastName = employee.object(forKey: "EmpuiLastname") as? String {
            fullName += " \(lastName)"
        }
        
        employeeName.text = "\(fullName)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doCompleteLogin(_ sender: Any) {
        

    }
    
}
