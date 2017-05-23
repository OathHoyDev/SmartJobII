//
//  EmployerHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/5/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployerHelper: NSObject {
    
    func getEmployeeApplyGroup(_ employer : NSDictionary) throws -> NSDictionary {
        
        let employerID = employer["EmployerID"] as! String
        
        var xmlStr = "<ws_jobApplyGroup xmlns='http://tempuri.org/'>"
        xmlStr += "<employerID>\(employerID)</employerID>"
        xmlStr += "</ws_jobApplyGroup>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_APPLY_GROUP)
            
            return resp
        }catch {
            
            throw error
        }
        
        
    }
    
    func getEmployeeMatchingGroup(_ employer : NSDictionary) throws -> NSDictionary {
        
        let employerID = employer["EmployerID"] as! String
        
        var xmlStr = "<ws_employeeMatchingGroup xmlns='http://tempuri.org/'>"
        xmlStr += "<employerID>\(employerID)</employerID>"
        xmlStr += "</ws_employeeMatchingGroup>"
        
        var resp = NSDictionary()
        do {
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_MATCHING_GROUP)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getEmployeeApplyList(_ jobAnnounce : NSDictionary) throws -> NSDictionary {
        
        let jobAnnounceID = String(describing: jobAnnounce["JobAnnounceID"] as! NSNumber)
        
        var xmlStr = "<ws_jobApply xmlns='http://tempuri.org/'>"
        xmlStr += "<jobAnnounceID>\(jobAnnounceID)</jobAnnounceID>"
        xmlStr += "</ws_jobApply>"
        
        var resp = NSDictionary()
        do {
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_APPLY_GROUP)
            
            return resp
            
        }catch {
            throw error
        }
        
        
    }
    
    func getEmployeeMatchingList(_ jobAnnounce : NSDictionary) throws -> NSDictionary {
        
        let jobAnnounceID = jobAnnounce["JobAnnounceID"] as! NSNumber
        
        var xmlStr = "<ws_employeeMatching xmlns='http://tempuri.org/'>"
        xmlStr += "<jobAnnounceID>\(jobAnnounceID)</jobAnnounceID>"
        xmlStr += "</ws_employeeMatching>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_MATCHING)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func login(_ userCode : String , withPassword password: String , withBranch branchID : String) throws -> NSDictionary {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var uuid = appDelegate.token
        
        if uuid != "" {
            
            let uuidSubString = uuid.replacingCharacters(in: uuid.startIndex..<uuid.characters.index(after: uuid.startIndex), with: "")
            
            uuid = uuidSubString
            
            uuid.remove(at: uuid.characters.index(before: uuid.endIndex))
            
        }

        let notiKey = appDelegate.notiKey
        
        print("notiKey : \(notiKey)")
        
        let xmlStr = "<ws_employerLogin xmlns='http://tempuri.org/'><userCode>\(userCode)</userCode><branchID>\(branchID)</branchID><password>\(password)</password><deviceImei>\(uuid)</deviceImei><notificationToken>\(notiKey)</notificationToken></ws_employerLogin>"
        
        var soapResp = NSDictionary()
        
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYER_LOGIN)
            
            return soapResp
            
        }catch {
            throw error
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
