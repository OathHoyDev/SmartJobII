//
//  NationalHospitalDetailViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalHospitalDetailViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    var item = NSDictionary()

    @IBOutlet weak var hpNameBar: UILabel!
    @IBOutlet weak var hospitalDetailView: UIView!
    
    var hospitalDetailFrameSize = CGSize()
    
    let nationalHospitalHelper = NationalHospitalHelper()
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var countryList: UITextView!
    
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hospitalDetailView.addDashedBorder(size: hospitalDetailFrameSize , color : ServiceConstant.ENABLE_LABEL_COLOR)

    }
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        hospitalDetailFrameSize = hospitalDetailView.frame.size
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadHospitalDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationItem()
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
    
    func loadHospitalDetail() {
        
        var resp = NSDictionary()
        
        loadingView.isHidden = false
        
        dispatchQueue.async {
            
            resp = self.getHospital(hpId: self.item.object(forKey: "HpId") as! String)
            
            OperationQueue.main.addOperation() {
                
                self.loadingView.isHidden = true
                
                var hospital = NSDictionary()
                
                if resp["RespBody"] != nil {
                    
                    hospital = resp["RespBody"] as! NSDictionary
                    
                    
                    
                    self.setHospitalDetail(hospital: hospital)
                    
                }
                
                
            }
        }
    }
    
    func setHospitalDetail(hospital : NSDictionary) {
    
        hpNameBar.text = hospital.object(forKey: "HpName") as! String
        address.text = hospital.object(forKey: "Address") as! String
        
        tel.text = hospital.object(forKey: "Tel") as! String
        
        switch hospital.object(forKey: "HpType") as! String {
        case "1":
            type.text = "รัฐบาล"
        case "2":
            type.text = "เอกชน"
        default:
            break
        }
        
        let countrys = hospital.object(forKey: "CountryList") as! NSMutableArray
        
        if countrys.count > 0 {
            
            countryList.text = ""
        
            for obj in countrys  {
                let country = obj as! NSDictionary
                countryList.text.append("\(country.object(forKey: "CtName") as! String)\n")
            }
        
        }
        
    
    }
    
    func getHospital(hpId : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        do{
            
            try resp = self.nationalHospitalHelper.getHospital(hpId: hpId)
            
            
            
        }catch {
            
            
            let alertController = UIAlertController(title: "การเชื่อมต่ออินเตอร์เน็ตขัดข้อง", message:
                "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return resp
        
    }
    

}
