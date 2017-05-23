//
//  NationalTestPlaceListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 17/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalTestPlaceListViewController: UIViewController , UITableViewDataSource , UIPickerViewDataSource ,UIPickerViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var notFoundLb: UILabel!
    @IBOutlet weak var blackSearchPage: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchViewCenterYConstraint: NSLayoutConstraint!
    var selectRow = -1
    
    var items = NSMutableArray()
    
    var selectItem = NSDictionary()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    let nationalTestPlaceHelper = NationalTestPlaceHelper()
    let nationalJobHelper = NationalJobHelper()
    let empuiHelper = EmpuiHelper()
    
    
    // Search
    @IBOutlet weak var searchTestPlaceName: UITextField!
    @IBOutlet weak var searchProvince: UITextField!
    @IBOutlet weak var searchTestPlaceType: UITextField!
    @IBOutlet weak var searchBranch: UITextField!
    
    var provinceId = ""
    var testPlaceType = ""
    var branchId = ""
    
    var provincePickerView = UIPickerView()
    var provinceArray = NSMutableArray()
    
    var testPlaceTypePickerView = UIPickerView()
    var testPlaceTypeArray = NSMutableArray()
    
    var branchPickerView = UIPickerView()
    var branchArray = NSMutableArray()

    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToHideSearchGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapToHideSearch(_:)))
        
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        
        
        blackSearchPage.addGestureRecognizer(tapToHideSearchGesture)
        
        searchView.addGestureRecognizer(tapToHideKeyboardGesture)

        
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        preparePickerView()
    }
    
    func tapToHideSearch(_ gesture: UITapGestureRecognizer) {
        
        clearSearchField()
        blackSearchPage.isHidden = true
        searchView.isHidden = true
        
        hideKeyboard()
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTestPlaceList(tpName: "", pvId: "", tpType: "", branchId: "")
        clearSearchField()
        hideKeyboard()
    }
    
    func preparePickerView() {
        
        provincePickerView.dataSource = self
        provincePickerView.delegate = self
        
        testPlaceTypePickerView.dataSource = self
        testPlaceTypePickerView.delegate = self
        
        branchPickerView.dataSource = self
        branchPickerView.delegate = self
        
        searchProvince.inputView = provincePickerView
        searchTestPlaceType.inputView = testPlaceTypePickerView
        searchBranch.inputView = branchPickerView
        
        let respProvince = doGetProvince()
        if let value = respProvince["RespBody"] as? NSMutableArray {
            provinceArray = value
        }
        
        testPlaceTypeArray.insert("รัฐบาล", at: 0)
        testPlaceTypeArray.insert("เอกชน", at: 1)
        
        let respBranch = doGetBranchTestPlace()
        if let value = respBranch["RespBody"] as? NSMutableArray {
            branchArray = value
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 20
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        spaceButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        doneButton.setTitleTextAttributes([NSParagraphStyleAttributeName : style], for: UIControlState())
        
        toolbar.isUserInteractionEnabled = true
        
        toolbar.setItems([spaceButton , doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        
        switch textField {
            
        case searchProvince :
            let item = provinceArray.object(at: 0) as! NSDictionary
            provinceId = item.object(forKey: "PvId") as! String
            searchProvince.text = item.object(forKey: "PvName") as! String
            
        case searchTestPlaceType :
            testPlaceType = "\(1)"
            searchTestPlaceType.text = testPlaceTypeArray.object(at: 0) as! String
            
        case searchBranch :
            let item = branchArray.object(at: 0) as! NSDictionary
            branchId = item.object(forKey: "CoutId") as! String
            searchBranch.text = item.object(forKey: "BranchName") as! String
            
        default :
            break
        }

        
        keyboardWillShow(textField: textField)
        return true
    }
    
    func donePicker() {
        hideKeyboard()
    }
    
    func keyboardWillShow(textField : UITextField) {
        
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        
        let searchViewPoint = searchView.frame
        
        let centerY = screenHeight*0.5
        
        
        if (globalPoint?.y)! > centerY {
            moveConstraint = (globalPoint?.y)! - centerY
            
        }else {
            moveConstraint = 0
            
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.searchViewCenterYConstraint.constant = 0 - CGFloat(self.moveConstraint)
            
        })
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.searchTestPlaceName.resignFirstResponder()
            self.searchProvince.resignFirstResponder()
            self.searchTestPlaceType.resignFirstResponder()
            self.searchBranch.resignFirstResponder()
            
            self.searchViewCenterYConstraint.constant = 0
            
        })
        
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        
        clearSearchField()
        
    }
    
    func clearSearchField() {
        searchTestPlaceName.text = ""
        searchProvince.text = ""
        searchTestPlaceType.text = ""
        searchBranch.text = ""
        
        provinceId = ""
        testPlaceType = ""
        branchId = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func loadTestPlaceList(tpName : String , pvId : String , tpType : String , branchId : String) {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getTestPlaceList(tpName: tpName, pvId: pvId, tpType: tpType, branchId: branchId)
            
            OperationQueue.main.addOperation() {
                
                if resp["RespBody"] != nil {
                    
                    self.items = resp["RespBody"] as! NSMutableArray
                    
                }
                
                self.loadingView.isHidden = true
                
                self.tableView.reloadData()
                
                if self.items.count == 0 {
                    self.notFoundLb.isHidden = false
                }else{
                    self.notFoundLb.isHidden = true
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        //self.performSegueWithIdentifier("showView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.minimumLineHeight = 15
        let attributes = [NSParagraphStyleAttributeName : style]
        
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationalTestPlaceCell", for: indexPath) as! NationalHospitalCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.hospitalName.text = "\(item.object(forKey: "TpName") as! String)"
        
        cell.address.text = "\(item.object(forKey: "TpAddress") as! String)"
        
        cell.detailButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func openSearchViewAction(_ sender: Any) {
        if (searchView.isHidden){
            searchView.isHidden = false
            blackSearchPage.isHidden = false
        }else{
            searchView.isHidden = true
            blackSearchPage.isHidden = true
        }
    }
    
    @IBAction func doSearchTestPlace(_ sender: Any) {
        
        let resp = getTestPlaceList(tpName: searchTestPlaceName.text!, pvId: provinceId, tpType: testPlaceType , branchId : branchId)
        
        if resp["RespBody"] != nil {
            
            items = resp["RespBody"] as! NSMutableArray
            
        }
        
        if items.count == 0 {
            notFoundLb.isHidden = false
        }else{
            notFoundLb.isHidden = true
        }
        
        self.tableView.reloadData()
        
        clearSearchField()
        blackSearchPage.isHidden = true
        searchView.isHidden = true
        
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doTestPlaceDetail(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        
    }
    
    func getTestPlaceList(tpName : String , pvId : String , tpType : String , branchId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalTestPlaceHelper.getTestPlaceList(tpName: tpName, pvId: pvId, tpType: tpType , branchId : branchId)
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.selectItem = items[selectRow] as! NSDictionary
        
        let viewController:NationalTestPlaceDetailViewController = segue.destination as! NationalTestPlaceDetailViewController
        
        viewController.item = selectItem
        
    }
    
    func doGetProvince() -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.empuiHelper.getProvince()
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    
    func doGetBranchTestPlace() -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalJobHelper.getBranchTestPlace()
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case provincePickerView :
            return provinceArray.count
            
        case testPlaceTypePickerView :
            return 2
            
        case branchPickerView :
            return branchArray.count
            
            
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case provincePickerView :
            
            let item = provinceArray.object(at: row) as! NSDictionary
            
            return item.object(forKey: "PvName") as! String

            
        case testPlaceTypePickerView :
            
            return testPlaceTypeArray.object(at: row) as! String
            
            
        case branchPickerView :
            let item = branchArray.object(at: row) as! NSDictionary
            return item.object(forKey: "BranchName") as! String
            
        default :
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case provincePickerView :
            let item = provinceArray.object(at: row) as! NSDictionary
            provinceId = item.object(forKey: "PvId") as! String
            
            searchProvince.text = item.object(forKey: "PvName") as! String
            
        case testPlaceTypePickerView :
            
            testPlaceType = "\(row + 1)"
            
            searchTestPlaceType.text = testPlaceTypeArray.object(at: row) as! String
            
        case branchPickerView :
            
            let item = branchArray.object(at: row) as! NSDictionary
            branchId = item.object(forKey: "CoutId") as! String
            
            searchBranch.text = item.object(forKey: "BranchName") as! String
            
            
        default : break
            
        }
    }

}
