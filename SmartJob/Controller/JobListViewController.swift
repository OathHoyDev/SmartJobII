//
//  JobListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/8/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JobListViewController: UIViewController , UITableViewDataSource , URLSessionDelegate , SideMenuProtocol{
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet weak var notfoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var jobPositionLabel: UILabel!
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var announceUpdateLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    var isSideMenuShow = false
    
    var sideMenuViewSize = CGSize()
    
    
    let employeeHelper = EmployeeHelper()
    let masterDataHelper = MasterDataHelper()
    
    var jobListData = NSDictionary()
    
    var items = NSMutableArray()
    
    var jobListType = ""
    
    var jobSearchObject = JobSearchObj()
    //var employerID = ""
    var employeeID = ""
    var titleView = ""
    
    var jobDetail = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectRow = -1
    
    // SideMenu outlet
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var smartJobLb: UILabel!
    @IBOutlet weak var employeeNameLb: UILabel!
    @IBOutlet weak var employeeProfileBt: UIButton!
    @IBOutlet weak var logoutBt: UIButton!
    @IBOutlet weak var loginBt: UIButton!
    
    //let xmlStr = "<ws_jobDetail xmlns='http://tempuri.org/'><jobAnnounceID>aaa</jobAnnounceID></ws_jobDetail>"
    
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
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.reloadData()
        
        
        
        //setNavigationItem()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sideMenu(false)
        //checkLogin()
        
        sideMenuDetail(isLogin: false)
        
        UIView.setAnimationsEnabled(true)
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        
        if jobListType == ServiceConstant.JOB_LIST_TYPE_SEARCH {
            self.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
            loadingView.isHidden = true
        }else{
            jobListData = getJobList()
            self.title = ServiceConstant.TITLE_JOB_NEW
        }
        
        if jobListData["RespBody"] != nil {
            items = jobListData["RespBody"] as! NSMutableArray
        }
        
        if items.count == 0 {
            jobListTableView.isHidden = true
            notfoundLabel.isHidden = false
        }else{
            jobListTableView.isHidden = false
            notfoundLabel.isHidden = true
        }
        
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        disableNavigationItem()
        
        loadingView.isHidden = false
        
        sideMenu(false)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
        }else{
            notfoundLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        }
        
        
        

    }
    
    func disableNavigationItem(){
        //self.navigationController!.setNavigationBarHidden(true, animated: true)
        //employeeProfileButton.hidde = false
        //searchButton.enabled = false
        
    }
    
    func enableNavigationItem(){
        //self.navigationController!.setNavigationBarHidden(false, animated: true)
        //employeeProfileButton.enabled = true
        //searchButton.enabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.title = ""
    }
    
    func startIndicator() {
        loadingView.isHidden = false
    }
    
    func checkNationalAccountStatus(resp : NSDictionary) {
        
        let statusList = resp.object(forKey: "StatusList") as! NSMutableArray
        let accountStatus = statusList.object(at: 0) as! NSDictionary
        let status = accountStatus.object(forKey: "StatusFlag") as! String
        
        switch status {
        case "01" :
            
            performSegue(withIdentifier: "employeeLogin2Segue", sender: self)
            
            

        default :
            break
        }
        
        
    }
    
    func sideMenuDetail(isLogin : Bool){
        
        
        
        if (isLogin) {
            
            let employee = appDelegate.employee
            
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
        
        if hasLogin {
            self.navigationItem.title = ""
            self.navigationItem.hidesBackButton = true
            UIView.setAnimationsEnabled(false)
            
            checkNationalAccountStatus(resp: appDelegate.employee)
            
            
            sideMenuDetail(isLogin: true)
            
        }else{
            
            sideMenuDetail(isLogin: false)
            
            UIView.setAnimationsEnabled(true)
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            if jobListType == ServiceConstant.JOB_LIST_TYPE_SEARCH {
                self.title = ServiceConstant.TITLE_JOB_SEARCH_RESULT
                loadingView.isHidden = true
            }else{
                jobListData = getJobList()
                self.title = ServiceConstant.TITLE_JOB_NEW
            }
            
            if jobListData["RespBody"] != nil {
                items = jobListData["RespBody"] as! NSMutableArray
            }
            
            if items.count == 0 {
                jobListTableView.isHidden = true
                notfoundLabel.isHidden = false
            }else{
                jobListTableView.isHidden = false
                notfoundLabel.isHidden = true
            }
            
            self.tableView.reloadData()
        }
    
    }
    
    func getJobList() -> NSDictionary {
        
        let xmlStr = "<ws_jobList xmlns='http://tempuri.org/' />"
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_LIST)
            
            loadingView.isHidden = true
            
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
        //
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobListCell
        
        cell.backgroundColor = UIColor.clear
        
        let item = items.object(at: indexPath.row) as! NSDictionary
        
        let jobPosition = item["JobPosition"] as! String
        cell.jobPositionLabel.attributedText = NSAttributedString(string: "\(jobPosition)", attributes:attributes)
        
        let employerName = item["EmployerName"] as! String
        cell.employerNameLabel.attributedText = NSAttributedString(string: "\(employerName)", attributes:attributes)
        
        var announceUpdate = item["AnnounceUpdate"] as! String
        announceUpdate = announceUpdate.substring(to: announceUpdate.range(of: " ")!.lowerBound)
        cell.announceUpdateLabel.text = "\(announceUpdate)"
        cell.detailButton.tag = indexPath.row
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.frontLabelCont.constant = 30
        }else{
            cell.frontLabelCont.constant = 15
        }
        
        cell.employerNameLabel.adjustsFontSizeToFitWidth = true
        cell.jobPositionLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    @IBAction func detailAction(_ sender: UIButton) {
        
        selectRow = sender.tag
        
        Thread.detachNewThreadSelector(#selector(JobListViewController.startIndicator), toTarget: self, with: nil)
        
        self.shouldPerformSegue(withIdentifier: "jobDetailSegue", sender: self)
        
    }
    
    func getJobDetail(_ jobItem : NSDictionary) -> NSDictionary {
        
        var resp = NSDictionary()
        
        Thread.detachNewThreadSelector(#selector(JobListViewController.startIndicator), toTarget: self, with: nil)
        
        do {
            
            try resp = employeeHelper.getJobDetail(jobItem)
            
            loadingView.isHidden = true
            
            return resp
        }catch {
            
            loadingView.isHidden = true
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            if(tableView.indexPathForSelectedRow != nil){
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }
            
            return NSDictionary()
        }
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        Thread.detachNewThreadSelector(#selector(JobListViewController.startIndicator), toTarget: self, with: nil)
        
        if (identifier == "jobDetailSegue"){
            
            let jobItem = items[selectRow] as! NSDictionary
            let resp = getJobDetail(jobItem)
            
            if resp["RespBody"] != nil {
                
                let respArray = resp["RespBody"] as! NSMutableArray
                jobDetail = respArray.object(at: 0) as! NSDictionary
                
            }

            
            if (jobDetail.count > 0){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "jobDetailSegue" {
            let viewController:JobDetailViewController = segue.destination as! JobDetailViewController
            //let indexPath = self.tableView.indexPathForSelectedRow!
            //viewController.jobItem = items[indexPath.row] as! NSDictionary
            viewController.jobDetail = jobDetail
        }else if segue.identifier == "jobSearchSegue" {
            
        }
        
    }
    
    // Method from Protocal
    func actionLogin() {
        print("actionLogin")
        performSegue(withIdentifier: "emptyJobLoginViewSegue", sender: self)
    }
    
    func actionFindJob() {
        
    }
    
    func actionNationalJob(){
        performSegue(withIdentifier: "NationalSegue", sender: self)
    }
    func actionInsuredJob() {
        performSegue(withIdentifier: "InsuredSegue", sender: self)
    }
    func actionProfile() {}

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
            sideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            isSideMenuShow = true
        }else{
            sideMenuConstraint.constant = -sideMenuView.frame.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.sideMenuView.isHidden = true
            })
            
            isSideMenuShow = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        sideMenuViewSize = sideMenuView.frame.size
        
    }
    
    @IBAction func doLogout(_ sender: Any) {
        appDelegate.employee = NSDictionary()
        appDelegate.usercode = ""
        
        UserDefaults.standard.setValue(nil, forKey: "usercode")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.set(false, forKey: "hasLogin")
        UserDefaults.standard.setValue(nil, forKey: "userType")
        
        UserDefaults.standard.synchronize()
        
        let alertController = UIAlertController(title: "ออกจากระบบสำเร็จ", message:
            "ออกจากระบบสำเร็จ", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: {(action) -> Void in
            self.sideMenuDetail(isLogin: false)
            self.sideMenu(false)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    
}
