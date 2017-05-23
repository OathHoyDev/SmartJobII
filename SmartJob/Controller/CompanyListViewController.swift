import UIKit


class CompanyListViewController : UIViewController , UITableViewDataSource , UIPickerViewDataSource ,UIPickerViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var notFoundLb: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var searchViewCenterYConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var blackSearchView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    var items = NSMutableArray()
    var selectItem = NSDictionary()
    
    let nationalCompanyHelper = NationalCompanyHelper()
    let nationalJobHelper = NationalJobHelper()
    let empuiHelper = EmpuiHelper()
    
    var selectRow = -1
    
    // Search
    @IBOutlet weak var searchBossName: UITextField!
    @IBOutlet weak var searchCompanyName: UITextField!
    @IBOutlet weak var searchProvince: UITextField!
    @IBOutlet weak var searchPermitId: UITextField!
    
    var provinceId = ""
    
    var provincePickerView = UIPickerView()
    
    var provinceArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    let screenSize = UIScreen.main.bounds
    
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    
    var moveConstraint = CGFloat()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    func preparePickerView() {
        
        provincePickerView.dataSource = self
        provincePickerView.delegate = self
        searchProvince.inputView = provincePickerView
        
        let respProvince = doGetProvince()
        
        if let value = respProvince["RespBody"] as? NSMutableArray {
            provinceArray = value
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapToHideSearchGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapToHideSearch(_:)))
        
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        
        
        blackSearchView.addGestureRecognizer(tapToHideSearchGesture)
        
        searchView.addGestureRecognizer(tapToHideKeyboardGesture)
        
        tableView.reloadData()
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        preparePickerView()
        
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        hideKeyboard()
        
    }
    
    func tapToHideSearch(_ gesture: UITapGestureRecognizer) {
        
        clearSearchField()
        blackSearchView.isHidden = true
        searchView.isHidden = true
        
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
        
        default :
            break
        }
        
        keyboardWillShow(textField: textField)
        return true
    }
    
    func donePicker() {
    
        hideKeyboard()
            
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.searchBossName.resignFirstResponder()
            self.searchCompanyName.resignFirstResponder()
            self.searchProvince.resignFirstResponder()
            self.searchPermitId.resignFirstResponder()
            
            self.searchViewCenterYConstraint.constant = 0
            
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        setNavigationItem()
        
    }
    
    func loadProvinceList() {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.doGetProvince()
            
            OperationQueue.main.addOperation() {
                
                if resp["RespBody"] != nil {
                    
                    self.provinceArray = resp["RespBody"] as! NSMutableArray
                    
                }
                
                self.loadingView.isHidden = true
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    func loadCompanyList() {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getCompanyInfo(name: "", companyName: "", pvId: "", permitCode: "")
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadCompanyList()
        clearSearchField()
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
    
    @IBAction func clearSearch(_ sender: Any) {
        
        clearSearchField()
        
    }
    
    func clearSearchField() {
        searchBossName.text = ""
        searchCompanyName.text = ""
        searchProvince.text = ""
        searchPermitId.text = ""
        provinceId = ""
    }
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationalCompanyCell", for: indexPath) as! NationalCompanyCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        cell.companyName.text = "บริษัท : \(item.object(forKey: "CompanyName") as! String)"
        
        cell.companyAddress.text = "ที่ตั้ง : \(item.object(forKey: "Address") as! String)"
        
        cell.detailButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func doCompanyDetail(_ sender: UIButton) {
        
        selectRow = sender.tag
        
    }
    // API
    
    func getCompanyInfo(name : String , companyName : String , pvId : String , permitCode : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = nationalCompanyHelper.getCompanyInfo(name: name, companyName: companyName, pvId: pvId, permitCode: permitCode)
            
        }catch {
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
        return resp
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        selectItem = items[selectRow] as! NSDictionary
        
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController:CompanyDetailViewController = segue.destination as! CompanyDetailViewController
        
        selectItem = items[selectRow] as! NSDictionary
        
        viewController.companyObject = self.selectItem
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView == provincePickerView {
            return 1
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case provincePickerView :
            return provinceArray.count
        default :
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case provincePickerView :
            let item = provinceArray.object(at: row) as! NSDictionary
            return item.object(forKey: "PvName") as! String
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
            
        default : break
            //            print("")
        }
    }
    
    @IBAction func doSearchCompany(_ sender: Any) {
        
        let resp = getCompanyInfo(name: searchBossName.text!, companyName: searchCompanyName.text!, pvId: provinceId, permitCode: searchPermitId.text!)
        
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
    
    
    
    
}
