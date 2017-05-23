//
//  EmptyJobRegistrationViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 21/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmptyJobRegistrationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txSubscriberId: UITextField!
    @IBOutlet weak var txTitle: UITextField!
    @IBOutlet weak var txName: UITextField!
    @IBOutlet weak var txSurname: UITextField!
    @IBOutlet weak var txBirthday: UITextField!
    @IBOutlet weak var txSex: UITextField!
    @IBOutlet weak var txAddressNo: UITextField!
    @IBOutlet weak var txProvince: UITextField!
    @IBOutlet weak var txAmphor: UITextField!
    @IBOutlet weak var txTumbon: UITextField!
    @IBOutlet weak var txPostNo: UITextField!
    @IBOutlet weak var txPhone: UITextField!
    @IBOutlet weak var txId: UITextField!
    @IBOutlet weak var txPassword: UITextField!
    @IBOutlet weak var txJobProvince: UITextField!
    @IBOutlet weak var txJobPosition: UITextField!
    @IBOutlet weak var txJobStandardPosition: UITextField!
    @IBOutlet weak var txEducation: UITextField!
    @IBOutlet weak var txEducationField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txSubscriberId.delegate = self
        txTitle.delegate = self
        txName.delegate = self
        txSurname.delegate = self
        txBirthday.delegate = self
        txSex.delegate = self
        txAddressNo.delegate = self
        txProvince.delegate = self
        txAmphor.delegate = self
        txTumbon.delegate = self
        txPostNo.delegate = self
        txPhone.delegate = self
        txId.delegate = self
        txPassword.delegate = self
        txJobProvince.delegate = self
        txJobPosition.delegate = self
        txJobStandardPosition.delegate = self
        txEducation.delegate = self
        txEducationField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareTextField()
        setFontSize()
    }
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            txSubscriberId?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txTitle?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txSurname?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txBirthday?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txSex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txAddressNo?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txAmphor?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txTumbon?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txPostNo?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txPhone?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txId?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txPassword?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txJobProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txJobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txJobStandardPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txEducation?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            txEducationField?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 22)
            
            
        }else{
            
            txSubscriberId?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txTitle?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txName?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txSurname?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txBirthday?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txSex?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txAddressNo?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txAmphor?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txTumbon?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txPostNo?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txPhone?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txId?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txPassword?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txJobProvince?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txJobPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txJobStandardPosition?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txEducation?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
            txEducationField?.font = UIFont(name: ServiceConstant.FONT_NAME, size: 15)
        
        }
    }


    func prepareTextField(){
    
        txSubscriberId.setLeftPaddingPoints(10)
        txTitle.setLeftPaddingPoints(10)
        txName.setLeftPaddingPoints(10)
        txSurname.setLeftPaddingPoints(10)
        txBirthday.setLeftPaddingPoints(10)
        txSex.setLeftPaddingPoints(10)
        txAddressNo.setLeftPaddingPoints(10)
        txProvince.setLeftPaddingPoints(10)
        txAmphor.setLeftPaddingPoints(10)
        txTumbon.setLeftPaddingPoints(10)
        txPostNo.setLeftPaddingPoints(10)
        txPhone.setLeftPaddingPoints(10)
        txId.setLeftPaddingPoints(10)
        txPassword.setLeftPaddingPoints(10)
        txJobProvince.setLeftPaddingPoints(10)
        txJobPosition.setLeftPaddingPoints(10)
        txJobStandardPosition.setLeftPaddingPoints(10)
        txEducation.setLeftPaddingPoints(10)
        txEducationField.setLeftPaddingPoints(10)
        
        txSubscriberId.setRightPaddingPoints(10)
        txTitle.setRightPaddingPoints(10)
        txName.setRightPaddingPoints(10)
        txSurname.setRightPaddingPoints(10)
        txBirthday.setRightPaddingPoints(10)
        txSex.setRightPaddingPoints(10)
        txAddressNo.setRightPaddingPoints(10)
        txProvince.setRightPaddingPoints(10)
        txAmphor.setRightPaddingPoints(10)
        txTumbon.setRightPaddingPoints(10)
        txPostNo.setRightPaddingPoints(10)
        txPhone.setRightPaddingPoints(10)
        txId.setRightPaddingPoints(10)
        txPassword.setRightPaddingPoints(10)
        txJobProvince.setRightPaddingPoints(10)
        txJobPosition.setRightPaddingPoints(10)
        txJobStandardPosition.setRightPaddingPoints(10)
        txEducation.setRightPaddingPoints(10)
        txEducationField.setRightPaddingPoints(10)
    
    }
    @IBAction func saveRegisterAction(_ sender: Any) {
        
        let oneAccountFlag = callWs_insertEmployeeRegister()
        
        if (oneAccountFlag){
            performSegue(withIdentifier: "segueOnePassword", sender: sender)
        }else{
            performSegue(withIdentifier: "segueConfirmRegistration", sender: sender)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        textField.resignFirstResponder()
        return true
    }
    
    func callWs_insertEmployeeRegister() -> Bool {
        return true
    }
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
