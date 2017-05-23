//
//  JobOfEmployeeListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/21/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JobOfEmployeeListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var sideMenuView: UIView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var notfoundLabel: UILabel!
    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet weak var bottomListConst: NSLayoutConstraint!
    var employee = NSDictionary()
    var jobListType = ""
    
    var jobListData = NSDictionary()
    var items = NSMutableArray()
    
    var jobDetail = NSDictionary()
    
    var selectRow = -1;
    
    @IBOutlet weak var employerInterestedButt: UIButton!
    @IBOutlet weak var matchingJobButt: UIButton!
    @IBOutlet weak var yourJobButt: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var employeeProfileButton: UIBarButtonItem!
    let employeeHelper = EmployeeHelper()
    let memberHelper = MemberHelper()
    
    var haveMessage = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isSideMenuShow = false
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    
    //let keychainWrapper = KeychainWrapper()
    
    // SideMenu outlet
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var smartJobLb: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var employeeProfileBt: UIButton!
    @IBOutlet weak var logoutBt: UIButton!
    @IBOutlet weak var loginBt: UIButton!

    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func setNavigationItem(_ title : String) {
        
        self.navigationItem.title = title
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.alignment = NSTextAlignment.center
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: navHeight!))
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
        
        self.navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.barTintColor = ServiceConstant.BAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        

        tableView.dataSource = self
        tableView.delegate = self
        
       
        self.tableView.reloadData()

        
    }
    
    
    func applicationDidBecomeActive( _ application: UIApplication) {
        checkNoti()
    }
    
    
    func sideMenuDetail(isLogin : Bool){
        
        
        
        if (isLogin) {
            
            employee = appDelegate.employee
            
            loginBt.isHidden = true
            logoutBt.isHidden = false
            employeeProfileBt.isHidden = false
            
            smartJobLb.isHidden = true
            employeeNameLb.isHidden = false
            
            if let value = employee.object(forKey: "EmployeeFullName") as? String {
                employeeNameLb.text = value
            }else{
                employeeNameLb.text = ""
            }
            
            logoImage.image = UIImage(named : "Image_Cartoon_Employee")
            
            
            
        }else {
            
            loginBt.isHidden = false
            logoutBt.isHidden = true
            employeeProfileBt.isHidden = true
            
            smartJobLb.isHidden = false
            employeeNameLb.isHidden = true
            
            logoImage.image = UIImage(named : "logoOnly")
            
        }
        
    }
    
    func checkLogin() {
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLogin")
        
        
        sideMenuDetail(isLogin: true)
            
        if jobListType == ServiceConstant.JOB_LIST_TYPE_SEARCH {
            
            //self.navigationItem.hidesBackButton = false
            
            matchingJobButt.isHidden = true
            yourJobButt.isHidden = true
            employerInterestedButt.isHidden = true
            
        }else{
        
            matchingJobButt.isHidden = false
            yourJobButt.isHidden = false
            employerInterestedButt.isHidden = false

        
        }
            
    
        
        
    }
    
        
    func startLoadContent() {
        
        if jobListType == "" {
            jobListType = ServiceConstant.JOB_LIST_TYPE_MATCHING
        }
        
        switch jobListType {
            
        case ServiceConstant.JOB_LIST_TYPE_MATCHING :
            
            setNavigationItem(ServiceConstant.TITLE_JOB_MATCHING)
            
            items.removeAllObjects()
            tableView.dataSource = self
            tableView.reloadData()
            
//            jobListTableView.dataSource = self
//            jobListTableView.reloadData()
            
            jobListData = getJobMatchingList()
            
            //self.title = ServiceConstant.TITLE_JOB_MATCHING
            let imageMatching = UIImage(named: "Button_Employee_Footer_Job_Matching_Dis") as UIImage?
            matchingJobButt.setBackgroundImage(imageMatching, for: UIControlState())
            matchingJobButt.isUserInteractionEnabled = false
            
            let imageYourJob = UIImage(named: "Button_Employee_Footer_Apply") as UIImage?
            yourJobButt.setBackgroundImage(imageYourJob, for: UIControlState())
            yourJobButt.isUserInteractionEnabled = true
            
            let imageInterest = UIImage(named: "Button_Employee_Footer_YourJob") as UIImage?
            employerInterestedButt.setBackgroundImage(imageInterest, for: UIControlState())
            employerInterestedButt.isUserInteractionEnabled = true
            
            
            
        case ServiceConstant.JOB_LIST_TYPE_YOUR_JOB :
            
            setNavigationItem(ServiceConstant.TITLE_YOUR_JOB)
            
            items.removeAllObjects()
            tableView.dataSource = self
            tableView.reloadData()
            
//            jobListTableView.dataSource = self
//            jobListTableView.reloadData()
            
            jobListData = getYourJobList()
            
            let imageMatching = UIImage(named: "Button_Employee_Footer_Job_Matching") as UIImage?
            matchingJobButt.setBackgroundImage(imageMatching, for: UIControlState())
            matchingJobButt.isUserInteractionEnabled = true
            
            let imageYourJob = UIImage(named: "Button_Employee_Footer_Apply_Dis") as UIImage?
            yourJobButt.setBackgroundImage(imageYourJob, for: UIControlState())
            yourJobButt.isUserInteractionEnabled = false
            
            let imageInterest = UIImage(named: "Button_Employee_Footer_YourJob") as UIImage?
            employerInterestedButt.setBackgroundImage(imageInterest, for: UIControlState())
            employerInterestedButt.isUserInteractionEnabled = true
            
            //self.title = ServiceConstant.TITLE_YOUR_JOB
            
            
            
        case ServiceConstant.JOB_LIST_TYPE_EMPLOYER_INTERESTED :
            
            setNavigationItem(ServiceConstant.TITLE_EMPLOYER_INTERESTED)
            
            items.removeAllObjects()
            tableView.dataSource = self
            tableView.reloadData()
            
//            jobListTableView.dataSource = self
//            jobListTableView.reloadData()
            
            jobListData = getEmployerInterestedJobList()
            
            let imageMatching = UIImage(named: "Button_Employee_Footer_Job_Matching") as UIImage?
            matchingJobButt.setBackgroundImage(imageMatching, for: UIControlState())
            matchingJobButt.isUserInteractionEnabled = true
            
            let imageYourJob = UIImage(named: "Button_Employee_Footer_Apply") as UIImage?
            yourJobButt.setBackgroundImage(imageYourJob, for: UIControlState())
            yourJobButt.isUserInteractionEnabled = true
            
            let imageInterest = UIImage(named: "Button_Employee_Footer_YourJob_Dis") as UIImage?
            employerInterestedButt.setBackgroundImage(imageInterest, for: UIControlState())
            employerInterestedButt.isUserInteractionEnabled = false
            
            //self.title = ServiceConstant.TITLE_EMPLOYER_INTERESTED
            
            
        case ServiceConstant.JOB_LIST_TYPE_SEARCH :
            
            setNavigationItem(ServiceConstant.TITLE_JOB_SEARCH_RESULT)
            
            matchingJobButt.isHidden = true
            yourJobButt.isHidden = true
            employerInterestedButt.isHidden = true
            
            //self.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
           
            
            
            
        default : break
            //print("No Type")
            
        }
        
        items = jobListData["RespBody"] as! NSMutableArray
        
        if items.count == 0 {
            jobListTableView.isHidden = true
            notfoundLabel.isHidden = false
        }else{
            jobListTableView.isHidden = false
            notfoundLabel.isHidden = true
        }
        
        
        tableView.reloadData()
        
//        jobListTableView.reloadData()
        
        
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if jobListType == ServiceConstant.JOB_LIST_TYPE_SEARCH {
            bottomListConst.constant = -yourJobButt.frame.size.height
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
//        items.removeAllObjects()
//        tableView.dataSource = self
//        tableView.reloadData()
        
        //self.navigationItem.title = ""
        
        //loadingView.hidden = true
        
        //self.navigationItem.backBarButtonItem?.title = "Back"
        
        checkLogin()
        
        
        if(jobListTableView.indexPathForSelectedRow != nil){
            jobListTableView.deselectRow(at: jobListTableView.indexPathForSelectedRow!, animated: false)
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
        }else{
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        }
        
        UIView.setAnimationsEnabled(true)
        
        
        
        
    }
    
    func logout() {
    
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        UserDefaults.standard.synchronize()
        
     
        let dashboardVC = navigationController!.viewControllers.filter { $0 is EmployeeLoginViewController_2 }.first!
        navigationController!.popToViewController(dashboardVC, animated: true)
        
    
    }
    
    func checkNoti() {
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        if appDelegate.haveNotiFromBackground && userType == "Employee" {
            
            if appDelegate.employeeIDForNoti == appDelegate.employee["EmployeeID"] as! String {
        
                let resp = getJobDetail(appDelegate.jobAnnounceIDForNoti, AndEmployeeID: appDelegate.employeeIDForNoti)
                
                if resp["RespBody"] != nil {
                    
                    let respArray = resp["RespBody"] as! NSMutableArray
                    jobDetail = respArray.object(at: 0) as! NSDictionary
                    
                }
                
                haveMessage = true
                
                appDelegate.jobAnnounceIDForNoti = ""
                appDelegate.employeeIDForNoti = ""
                appDelegate.employerIDForNoti = ""
                appDelegate.haveNotiFromBackground = false
                
                performSegue(withIdentifier: "JobDetailForApplySegue", sender: self)
                
            }else{
                
                logout()
                
            }
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkNoti()
        startLoadContent()
        loadingView.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
    }
    
    func getJobMatchingList() -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employeeHelper.getJobMatchingList(employee)
            
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
    
    func getYourJobList() -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employeeHelper.getYourJobList(employee)
            
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
    
    func getEmployerInterestedJobList() -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do{
            
            try resp = employeeHelper.getEmployerInterestedJobList(employee)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell for the given indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobListCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        let jobPosition = item["JobPosition"] as! String
        let employerName = item["EmployerName"] as! String
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 12
        let attributes = [NSParagraphStyleAttributeName : style]
        
        cell.employerNameLabel.attributedText = NSAttributedString(string: "\(employerName)", attributes:attributes)
        
        cell.jobPositionLabel.attributedText = NSAttributedString(string: "\(jobPosition)", attributes:attributes)
        
        if item["MsgFlag"] as! String != "0" {
            
            cell.mailNotiIcon.isHidden = false
            
            var imageMail = UIImage()
            
            if item["MsgFlag"] as! String == "1" {
                imageMail = UIImage(named: "Mail_Icon")! as UIImage
            }else if item["MsgFlag"] as! String == "2"{
                imageMail = UIImage(named: "Mail_Read_Icon")! as UIImage
            }
            
            cell.mailNotiIcon.image = imageMail
            
        }else{
            cell.mailNotiIcon.isHidden = true
            
        }
        
        if item["AnnounceUpdate"] != nil && item["AnnounceUpdate"] as! String != "" {
            var announceUpdate = item["AnnounceUpdate"] as! String
            announceUpdate = announceUpdate.substring(to: announceUpdate.range(of: " ")!.lowerBound)
            cell.announceUpdateLabel.text = "\(announceUpdate)"
        }else if item["ApplyDate"] != nil {
            var announceUpdate = item["ApplyDate"] as! String
            announceUpdate = announceUpdate.substring(to: announceUpdate.range(of: " ")!.lowerBound)
            cell.announceUpdateLabel.text = "\(announceUpdate)"
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.frontLabelCont.constant = 30
            
        }else{
            cell.frontLabelCont.constant = 15
        }
        
        cell.detailButton.tag = indexPath.row
        
        
        
        
        // set the cell's text with the new string formatting
        //cell.textLabel.text = "\(items[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func checkMessage(_ jobAnnounceID : String) -> Bool{
        
        var resp = NSDictionary()
        
        var result = false
        
        do {
            
            try resp = memberHelper.getMsg("\(appDelegate.employee["EmployeeID"] as! String)", withJobAnnounceID: jobAnnounceID, messageFlagEmp: "2")
        
            let respArray = resp["RespBody"] as! NSMutableArray
            
            
            if respArray.count > 0 {
                let msgDict = respArray.object(at: 0) as! NSDictionary
                
                if msgDict["EmployerMsgDesc"] as! String != "" || msgDict["EmployeeMsgDesc"] as! String != ""{
                    result = true
                    
                }else{
                    result = false
                }
            }
                
        }catch{
            result = false
        }
        
        return result
    }
    
    @IBAction func detailAction(_ sender: UIButton) {
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        selectRow = sender.tag
        
        let jobItem = items[selectRow] as! NSDictionary
        
        haveMessage = checkMessage("\(jobItem["JobAnnounceID"] as! NSNumber)")
        
        let resp = getJobDetail(jobItem)
        
        if resp["RespBody"] != nil {
            
            let respArray = resp["RespBody"] as! NSMutableArray
            jobDetail = respArray.object(at: 0) as! NSDictionary
            
        }
        
        if jobListType == ServiceConstant.JOB_LIST_TYPE_YOUR_JOB
//            ||
//            jobListType == ServiceConstant.JOB_LIST_TYPE_MATCHING ||
//            jobListType == ServiceConstant.JOB_LIST_TYPE_EMPLOYER_INTERESTED 
        {
            performSegue(withIdentifier: "JobDetailForApplySegue", sender: self)
        }else{
            if haveMessage {
                performSegue(withIdentifier: "JobDetailForApplySegue", sender: self)
            }else{
                performSegue(withIdentifier: "jobDetailSegue", sender: self)
            }
        }
        
        
        
        //self.shouldPerformSegueWithIdentifier("jobDetailSegue", sender: self)
        
    }
    
    func checkJobHasApply(_ tempJob : NSDictionary , withJobList jobList : NSMutableArray) -> Bool {
        
        var result = false
    
        for inJob in jobList {
            let temp = inJob as! NSDictionary
            let inJobID = temp["JobAnnounceID"] as! NSNumber
            if inJobID == tempJob["JobAnnounceID"] as! NSNumber {
                result = true
                break
            }
        }
        
        return result
    }
    
    @IBAction func matchingAction(_ sender: AnyObject) {
        jobListType = ServiceConstant.JOB_LIST_TYPE_MATCHING
        startLoadContent()
    }
    
    @IBAction func yourJobAction(_ sender: AnyObject) {
        jobListType = ServiceConstant.JOB_LIST_TYPE_YOUR_JOB
        startLoadContent()
    }
    
    @IBAction func employerInterestedAction(_ sender: AnyObject) {
        jobListType = ServiceConstant.JOB_LIST_TYPE_EMPLOYER_INTERESTED
        startLoadContent()
    }
    
    func getJobDetail(_ jobAnnounceID : String , AndEmployeeID employeeID : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employeeHelper.getJobDetail(jobAnnounceID, AndEmployeeID: employeeID)
            
            loadingView.isHidden = true
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            
//            jobListTableView.deselectRow(at: jobListTableView.indexPathForSelectedRow!, animated: false)

        }
        
        return resp
        
    }
    
    func getJobDetail(_ jobItem : NSDictionary) -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employeeHelper.getJobDetail(jobItem)
            
            loadingView.isHidden = true
            
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            
//            jobListTableView.deselectRow(at: jobListTableView.indexPathForSelectedRow!, animated: false)
        }
        
        return resp
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Thread.detachNewThreadSelector(#selector(JobOfEmployeeListViewController.startIndicator), toTarget: self, with: nil)

        
        if segue.identifier == "EditProfileSegue" {
            let viewController:EmployeeProfileOrRegisterViewController = segue.destination as! EmployeeProfileOrRegisterViewController
            viewController.pageType = ServiceConstant.EMPLOYEE_PROFILE_PAGE_TYPE_EDIT_PROFILE
        }else if segue.identifier == "jobDetailSegue" {
        
            let viewController:JobDetailViewController = segue.destination as! JobDetailViewController
            viewController.jobDetail = jobDetail
        
        }else if segue.identifier == "JobDetailForApplySegue" {
            
            let viewController:JobDetailForApplyViewController = segue.destination as! JobDetailForApplyViewController
            viewController.jobDetail = jobDetail
            viewController.haveMessage = haveMessage
            
            
        }
        
    }
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if (!isSideMenuShow){
            sideMenu(true)
        }else{
            sideMenu(false)
        }
        
    }
    
    func sideMenu(_ action : Bool){
    
        if (action){
            sideMenuView.isHidden = false
            sideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            isSideMenuShow = true
        }else{
            sideMenuLeadingConstraint.constant = -sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            sideMenuView.isHidden = true
            isSideMenuShow = false
        }
    
    }
    
    @IBAction func doLogout(_ sender: Any) {
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        sideMenuDetail(isLogin: false)
        sideMenu(false)
        performSegue(withIdentifier: "SmartJobLogout", sender: self)
        
    }
    
    @IBAction func doViewProfile(_ sender: Any) {
        performSegue(withIdentifier: "EditProfileSegue", sender: self)
    }
    
    
}
