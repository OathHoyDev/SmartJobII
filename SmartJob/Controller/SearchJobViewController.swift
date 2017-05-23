//
//  SearchJobViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/16/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class SearchJobViewController: UIViewController , UIPickerViewDataSource ,UIPickerViewDelegate {
    
    @IBOutlet weak var jobProvinceTx: UITextField!
    @IBOutlet weak var jobPositionTx: UITextField!
    @IBOutlet weak var searchUIView: UIView!
    
    @IBOutlet weak var loadingView: UIView!
    var provinceArray = NSMutableArray()
    var provinceObj = NSDictionary()
    
    var pickerView = UIPickerView()
    
    var provinceID = NSNumber()
    
    var jobList = NSDictionary()
    
    let masterDataHelper = MasterDataHelper()
    let employeeHelper = EmployeeHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var textFieldTag:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingView.isHidden = true
        
        provinceArray.removeAllObjects()
        provinceArray = getProvince()
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        self.title = ServiceConstant.TITLE_JOB_SEARCH
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
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavigationItem()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        jobProvinceTx.inputView = pickerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SearchJobViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        searchUIView.layer.cornerRadius = 10
        searchUIView.layer.masksToBounds = true
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        jobProvinceTx.resignFirstResponder()
        jobPositionTx.resignFirstResponder()
        
        if provinceObj.count > 0 {
            provinceID = (provinceObj["ProvinceID"]) as! NSNumber
        }
    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }

    
    func getProvince() -> NSMutableArray {
        
        Thread.detachNewThreadSelector(#selector(SearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        var resp = NSDictionary()
        
        do{
            
            try resp = masterDataHelper.getProvince()
            
            loadingView.isHidden = true
            
            return resp["RespBody"] as! NSMutableArray
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return NSMutableArray()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provinceArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let provice = provinceArray.object(at: row) as! NSDictionary
        return provice["ProvinceName"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let provice = provinceArray.object(at: row) as! NSDictionary
        jobProvinceTx.text = provice["ProvinceName"] as? String
        provinceObj = provice
        
        provinceID = (provinceObj["ProvinceID"]) as! NSNumber
    }
    
    @IBAction func searchAction(_ sender: AnyObject) {
        
        if jobPositionTx.text == "" {
            
            let alertController = UIAlertController(title: "การค้นหาผิดพลาด", message:
                "กรุณาระบุตำแหน่งงานที่ต้องการค้นหา", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }else{
            
            if jobProvinceTx.text == "" {
                
                provinceID = 0
                
            }
        
            jobList = jobListSearch()
            
            let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
            
            let smartJobId = appDelegate.employee.object(forKey: "EmployeeID") as! String
            
            if hasLogin && smartJobId != "" {
                
                performSegue(withIdentifier: "JobSearchResultWithLoginSegue", sender: self)
                
            }else {
                
                performSegue(withIdentifier: "JobSearchResultSegue", sender: self)
                
            }
        }
    }
    
    func jobListSearch() -> NSDictionary {
        
        Thread.detachNewThreadSelector(#selector(SearchJobViewController.startIndicator), toTarget: self, with: nil)
        
        var resp = NSDictionary()
        let jobPosition = "\(jobPositionTx.text!)"
        
        var jobSearchDetail = NSMutableDictionary()
        
        jobSearchDetail.setValue(jobPosition, forKey: "JobPosition")
        
        if jobProvinceTx.text != "" {
            
            jobSearchDetail.setValue(provinceID, forKey: "ProvinceID")
            
        }
        
        
        
        do{
            
            try resp = employeeHelper.jobListSearch(jobSearchDetail)
            
            loadingView.isHidden = true
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
        return resp
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "JobSearchResultSegue" {
            let viewController:JobListViewController = segue.destination as! JobListViewController
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_SEARCH
            
            viewController.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
            viewController.jobListData = jobList
        }else if segue.identifier == "JobSearchResultWithLoginSegue" {
            let viewController:JobOfEmployeeListViewController = segue.destination as! JobOfEmployeeListViewController
            
            viewController.jobListType = ServiceConstant.JOB_LIST_TYPE_SEARCH
            
            viewController.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
            viewController.jobListData = jobList
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField.tag {
            
        case 1 :
            jobProvinceTx.becomeFirstResponder()
            
        default :
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func pickerDone(){
        jobProvinceTx.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldTag = textField.tag
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 20
        
        if textField.tag == 2 {
            
            let toolbar = UIToolbar()
            toolbar.barStyle = UIBarStyle.default
            toolbar.sizeToFit()
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            let nextButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchJobViewController.pickerDone))
            nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
            
            let clearTextButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchJobViewController.clearTextAction))
            clearTextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())

            
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            
            textField.inputAccessoryView = toolbar
            
            let province = provinceArray.object(at: 0) as! NSDictionary
            jobProvinceTx.text = province["ProvinceName"] as? String
            
            self.provinceID = (province["ProvinceID"]) as! NSNumber
            
            toolbar.setNeedsLayout()
            
        }
        else{
            let toolbar = UIToolbar()
            toolbar.barStyle = UIBarStyle.default
            toolbar.sizeToFit()
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let nextButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchJobViewController.pickerDone))
            nextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
            let clearTextButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchJobViewController.clearTextAction))
            clearTextButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
            
            toolbar.setItems([clearTextButton , spaceButton , nextButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            
            //textField.inputAccessoryView = toolbar

        }
    }
    
    func clearTextAction() {
        switch textFieldTag {
        case 1 :
            jobPositionTx.text = ""
            jobPositionTx.resignFirstResponder()
        case 2 :
            jobProvinceTx.text = ""
            jobProvinceTx.resignFirstResponder()
        default: break
            
        }
        
    }

    
    
}
