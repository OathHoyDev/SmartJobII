//
//  NationalTestPlaceDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 17/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalTestPlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    var item = NSDictionary()
    
    @IBOutlet weak var hpNameBar: UILabel!
    
    
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var branchList: UITextView!
    
    let nationalTestPlaceHelper = NationalTestPlaceHelper()
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTestPlaceDetail()
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    func loadTestPlaceDetail() {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getTestPlace(tpId: self.item.object(forKey: "TpId") as! String)
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                var testPlace = NSDictionary()
                
                if resp["RespBody"] != nil {
                    
                    testPlace = resp["RespBody"] as! NSDictionary
                    
                    self.setTestPlaceDetail(testPlace: testPlace)
                    
                }
                
                
                
                
            }
        }
    }
    
    func setTestPlaceDetail(testPlace : NSDictionary) {
        
        hpNameBar.text = testPlace.object(forKey: "TpName") as! String
        address.text = testPlace.object(forKey: "Address") as! String
        
        if testPlace.object(forKey: "Tel") != nil {
            
            tel.text = testPlace.object(forKey: "Tel") as! String
            
        }
        
        switch testPlace.object(forKey: "TpType") as! String {
        case "1":
            type.text = "รัฐบาล"
        case "2":
            type.text = "เอกชน"
        default:
            break
        }
        
        let countrys = testPlace.object(forKey: "CoutList") as! NSMutableArray
        
        if countrys.count > 0 {
            
            branchList.text = ""
            
            for obj in countrys  {
                let country = obj as! NSDictionary
                branchList.text.append("\(country.object(forKey: "BranchName") as! String)\n")
            }
            
        }
        
        
        
        
        
        
    }
    
    func getTestPlace(tpId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalTestPlaceHelper.getTestPlace(tpId: tpId)
            
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }

}
