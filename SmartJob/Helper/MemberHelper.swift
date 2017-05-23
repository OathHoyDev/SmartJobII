//
//  MemberHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/7/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class MemberHelper: NSObject {
    
    func getMemberDetail(_ userId : String , andUserCode userCode : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_memberDetail xmlns='http://tempuri.org/'><userID>\(userId)</userID><userCode>\(userCode)</userCode></ws_memberDetail>"
        var resp = NSDictionary()
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_DETAIL)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func insertMsg(_ employeeID : String , withJobAnnounceID jobAnnounceID : String , messageBySender flagEmp : String , withMessage message : String) throws -> NSDictionary {
        
        var employeeMessage = ""
        var employerMessage = ""
        
        if flagEmp == "1" {
            employerMessage = message
        }else {
            employeeMessage = message
        }
    
        let xmlStr = "<ws_insertMsg xmlns='http://tempuri.org/'>"
        + "<flagEmp>\(flagEmp)</flagEmp>"
        + "<jobAnnounceID>\(jobAnnounceID)</jobAnnounceID>"
        + "<employeeID>\(employeeID)</employeeID>"
        + "<employerMsgDesc>\(employerMessage)</employerMsgDesc>"
        + "<employeeMsgDesc>\(employeeMessage)</employeeMsgDesc>"
        + "</ws_insertMsg>"
        
        var resp = NSDictionary()
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_INSERT_MSG)
            return resp
        }catch {
            throw error
        }
        
    }
    
    
    func getMsg(_ employeeID : String , withJobAnnounceID jobAnnounceID : String , messageFlagEmp flagEmp : String) throws -> NSDictionary {
        
        // flagEmp = 1 -> Employer
        // flagEmp = 2 -> Employee
        
        let xmlStr = "<ws_getMsg xmlns='http://tempuri.org/'>"
            + "<flagEmp>\(flagEmp)</flagEmp>"
            + "<jobAnnounceID>\(jobAnnounceID)</jobAnnounceID>"
            + "<employeeID>\(employeeID)</employeeID>"
            + "</ws_getMsg>"
        
        var resp = NSDictionary()
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_GET_MSG)
            
            return resp
        }catch {
            throw error
        }
    }


}
