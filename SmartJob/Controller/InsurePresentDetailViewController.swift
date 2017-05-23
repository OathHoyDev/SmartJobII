//
//  InsurePresentDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 7/5/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class InsurePresentDetailViewController: UIViewController {
    
    var presentInsure = NSDictionary()
    
    var sequence = ""

    @IBOutlet weak var presentId: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var presentNo: UILabel!
    @IBOutlet weak var trackingAddress: UILabel!
    @IBOutlet weak var planPresentDate: UILabel!
    @IBOutlet weak var presentDate: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var compName: UILabel!
    @IBOutlet weak var compAddress: UILabel!
    @IBOutlet weak var compMobileNo: UILabel!
    @IBOutlet weak var compContact: UILabel!
    @IBOutlet weak var jobDate: UILabel!
    
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var compNameLb: UILabel!
    @IBOutlet weak var compAddressLb: UILabel!
    @IBOutlet weak var compMobileNoLb: UILabel!
    @IBOutlet weak var compContactLb: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    let empuiHelper = EmpuiHelper()
    
    var employee = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        employee = appDelegate.employee
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInfoTracking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getInfoTracking () {
        
        var soapResp = NSDictionary()
        
        var trackInfoResp = NSDictionary()
    
        dispatchQueue.async {
            
            do{
                
                self.loadingView.isHidden = false
                
                let employee = self.appDelegate.employee
                var memberId = ""
                var regId = ""
                
                if let value = employee.object(forKey: "EmpuiMemberID") as? String{
                    memberId = value
                }
                
                if let value = self.presentInsure.object(forKey: "id") as? String{
                    regId = value
                }
                
                try soapResp = self.empuiHelper.getInfoTracking(memberId: memberId, regId: regId)
                
                
            }catch {
                
                let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                    "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                self.loadingView.isHidden = true
                
            }
            
            
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                if soapResp.count > 0 {
                    
                    let resp = soapResp["RespStatus"] as! NSDictionary
                    
                    if let respStatus = resp.object(forKey: "StatusID") as? NSNumber {
                    
                        if respStatus == 1 {
                            let trackArrayResp = soapResp.object(forKey: "RespBody") as! NSMutableArray
                            
                            for object in trackArrayResp {
                                let track = object as! NSDictionary
                                
                                let trackSequence = track.object(forKey: "sequence") as! String
                                
                                if trackSequence == self.sequence {
                                    
                                    self.setDetailTracking(infoTracking: track)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    
    }
    
    func setDetailTracking(infoTracking : NSDictionary) {
    
        presentId.text = presentInsure.object(forKey: "register_no") as! String
        registerDate.text = presentInsure.object(forKey: "create_date") as! String
        
        if let value = employee.object(forKey: "EmployeeFullName") as? String {
            name.text = "\(value)"
        }
        
        var sequence = ""
        
        if let value = infoTracking.object(forKey: "sequence") as? String{
            sequence = value
        }
        
        presentNo.text = "\(sequence)"
        trackingAddress.text = presentInsure.object(forKey: "branch_name") as! String
        
        if let value = presentInsure.object(forKey: "d_ap_\(sequence)") as? String{
        
            planPresentDate.text = value
            
        }
        
        if let fullPresentDate = (infoTracking.object(forKey: "create_date") as? String)?.components(separatedBy: " "){
            presentDate.text = fullPresentDate[0]
        }
        
        var resultText = ""
        if infoTracking.object(forKey: "results") as! String == "1" {
            resultText = "ได้งาน"
            
            compName.isHidden = false
            compAddress.isHidden = false
            compMobileNo.isHidden = false
            compContact.isHidden = false
            compNameLb.isHidden = false
            compAddressLb.isHidden = false
            compMobileNoLb.isHidden = false
            compContactLb.isHidden = false
            
            compName.text = infoTracking.object(forKey: "company") as! String
            compAddress.text = infoTracking.object(forKey: "comp_address") as! String
            compMobileNo.text = infoTracking.object(forKey: "comp_mobile_no") as! String
            compContact.text = infoTracking.object(forKey: "comp_contract") as! String
        }else{
            resultText = "ยังไม่ได้งาน"
            compName.isHidden = true
            compAddress.isHidden = true
            compMobileNo.isHidden = true
            compContact.isHidden = true
            compNameLb.isHidden = true
            compAddressLb.isHidden = true
            compMobileNoLb.isHidden = true
            compContactLb.isHidden = true
            
        }
        
        result.text = resultText
        
        //jobDate.text = infoTracking.object(forKey: "tracking_location") as! String
    
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
