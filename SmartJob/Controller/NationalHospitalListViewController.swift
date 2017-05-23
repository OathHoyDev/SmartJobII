//
//  NationalHospitalListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalHospitalListViewController: UIViewController ,UITableViewDataSource , UIPickerViewDataSource ,UIPickerViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var hospitalListView: UIView!
    @IBOutlet weak var blackSearchView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var notFoundLb: UILabel!
    
    // Search
    @IBOutlet weak var searchViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchHospitalName: UITextField!
    @IBOutlet weak var searchProvince: UITextField!
    @IBOutlet weak var searchHospitalType: UITextField!
    @IBOutlet weak var searchCountry: UITextField!
    
    var provinceId = ""
    var hospitalType = ""
    var countryId = ""
    
    var provincePickerView = UIPickerView()
    var provinceArray = NSMutableArray()
    
    var hospitalTypePickerView = UIPickerView()
    var hospitalTypeArray = NSMutableArray()
    
    var countryPickerView = UIPickerView()
    var countryArray = NSMutableArray()
    
    
    
    let nationalHospitalHelper = NationalHospitalHelper()
    let nationalJobHelper = NationalJobHelper()
    let empuiHelper = EmpuiHelper()
    
    var selectRow = -1
    
    var items = NSMutableArray()
    
    var selectItem = NSDictionary()
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToHideSearchGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapToHideSearch(_:)))
        
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        
        
        blackSearchView.addGestureRecognizer(tapToHideSearchGesture)
        
        searchView.addGestureRecognizer(tapToHideKeyboardGesture)
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        preparePickerView()

    }
    
    func tapToHideSearch(_ gesture: UITapGestureRecognizer) {
        
        clearSearchField()
        blackSearchView.isHidden = true
        searchView.isHidden = true
        
        hideKeyboard()
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadHospitalList(hpName: "", pvId: "", hpType: "", ctId: "")
        clearSearchField()
        hideKeyboard()
    }
    
    func preparePickerView() {
        
        provincePickerView.dataSource = self
        provincePickerView.delegate = self
        
        hospitalTypePickerView.dataSource = self
        hospitalTypePickerView.delegate = self
        
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        searchProvince.inputView = provincePickerView
        searchHospitalType.inputView = hospitalTypePickerView
        searchCountry.inputView = countryPickerView
        
        let respProvince = doGetProvince()
        if let value = respProvince["RespBody"] as? NSMutableArray {
            provinceArray = value
        }
        
        hospitalTypeArray.insert("รัฐบาล", at: 0)
        hospitalTypeArray.insert("เอกชน", at: 1)
        
        let respCountry = doGetCountry()
        if let value = respCountry["RespBody"] as? NSMutableArray {
            countryArray = value
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
        
        

        switch textField {
            
        case searchProvince :
            textField.inputAccessoryView = toolbar
            let item = provinceArray.object(at: 0) as! NSDictionary
            provinceId = item.object(forKey: "PvId") as! String
            searchProvince.text = item.object(forKey: "PvName") as! String
            
        case searchHospitalType :
            textField.inputAccessoryView = toolbar
            hospitalType = "\(1)"
            searchHospitalType.text = hospitalTypeArray.object(at: 0) as! String
            
        case searchCountry :
            textField.inputAccessoryView = toolbar
            let item = countryArray.object(at: 0) as! NSDictionary
            countryId = item["CtId"] as! String
            searchCountry.text = item["CtName"] as! String
            
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
            
            self.searchHospitalName.resignFirstResponder()
            self.searchProvince.resignFirstResponder()
            self.searchHospitalType.resignFirstResponder()
            self.searchCountry.resignFirstResponder()
            
            self.searchViewCenterYConstraint.constant = 0
            
        })

    }
    
    @IBAction func clearSearch(_ sender: Any) {
        
        clearSearchField()
        
    }
    
    func clearSearchField() {
        searchHospitalName.text = ""
        searchProvince.text = ""
        searchHospitalType.text = ""
        searchCountry.text = ""
        
        provinceId = ""
        hospitalType = ""
        countryId = ""
        
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
    
    func loadHospitalList(hpName : String , pvId : String , hpType : String , ctId : String) {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getHospitalList(hpName: hpName, pvId: pvId, hpType: hpType, ctId: ctId)
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationalHospitalCell", for: indexPath) as! NationalHospitalCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.hospitalName.text = "\(item.object(forKey: "HpName") as! String)"
        
        cell.address.text = "\(item.object(forKey: "Address") as! String)"
        
        cell.detailButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func doHospitalDetail(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        
    }
    
    @IBAction func openSearchViewAction(_ sender: Any) {
        if (searchView.isHidden){
            searchView.isHidden = false
            blackSearchView.isHidden = false
        }else{
            searchView.isHidden = true
            blackSearchView.isHidden = true
        }
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case provincePickerView :
            return provinceArray.count
            
        case hospitalTypePickerView :
            return 2
            
        case countryPickerView :
            return countryArray.count
            
            
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case provincePickerView :
            
            let item = provinceArray.object(at: row) as! NSDictionary
            
            return item.object(forKey: "PvName") as! String
            
        case hospitalTypePickerView :
            
            return hospitalTypeArray.object(at: row) as! String
            
        case countryPickerView :
            let item = countryArray.object(at: row) as! NSDictionary
            return item["CtName"] as? String
            
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
            
        case hospitalTypePickerView :
            
            hospitalType = "\(row + 1)"
            
            searchHospitalType.text = hospitalTypeArray.object(at: row) as! String
            
        case countryPickerView :
            let item = countryArray.object(at: row) as! NSDictionary
            countryId = item["CtId"] as! String
            searchCountry.text = item["CtName"] as! String
            
        default : break
            
        }
    }
    
    @IBAction func doSearchHospital(_ sender: Any) {
        
        let resp = getHospitalList(hpName: searchHospitalName.text!, pvId: provinceId, hpType: hospitalType, ctId: countryId)
        
        if resp["RespBody"] != nil {
            
            items = resp["RespBody"] as! NSMutableArray
            
        }
        
        self.tableView.reloadData()
        
        if items.count == 0 {
            notFoundLb.isHidden = false
        }else{
            notFoundLb.isHidden = true
        }
        
        clearSearchField()
        blackSearchView.isHidden = true
        searchView.isHidden = true
        
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
    
    func doGetCountry() -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalJobHelper.getCountryTravel()
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }

    
    func getHospitalList(hpName : String , pvId : String , hpType : String , ctId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalHospitalHelper.getHospitalList(hpName: hpName, pvId: pvId, hpType: hpType, ctId: ctId)
            
            
            
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
        
        let viewController:NationalHospitalDetailViewController = segue.destination as! NationalHospitalDetailViewController
        
        viewController.item = selectItem
        
    }
    
}
