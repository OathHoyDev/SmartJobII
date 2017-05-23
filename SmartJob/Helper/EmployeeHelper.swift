//
//  EmployeeHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/5/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmployeeHelper: NSObject {
    
    func getNewJobList() throws -> NSDictionary {
    
        let xmlStr = "<ws_jobList xmlns='http://tempuri.org/' />"
        
        var resp = NSDictionary()
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_LIST)
        }catch {
            throw error
        }
        
        return resp
    
    }
    
    func getJobDetail(_ jobItem : NSDictionary) throws -> NSDictionary {
        
        let jobAnnounceID = (jobItem["JobAnnounceID"]) as! NSNumber
        
        let xmlStr = "<ws_jobDetail xmlns='http://tempuri.org/'><jobAnnounceID>\(jobAnnounceID)</jobAnnounceID></ws_jobDetail>"
        
        var resp = NSDictionary()
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_DETAIL)
            
            return resp
        }catch {
            
            throw error
            
        }
        
        
    }
    
    func getJobDetail(_ jobAnnounceID : String , AndEmployeeID employeeID : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_jobDetail xmlns='http://tempuri.org/'><jobAnnounceID>\(jobAnnounceID)</jobAnnounceID><employeeID>\(employeeID)</employeeID></ws_jobDetail>"
        
        var resp = NSDictionary()
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_DETAIL)
            
            return resp
        }catch {
            
            throw error
            
        }
        
        
    }
    
    func applyJob(_ jobDetail : NSDictionary , withEmployee employee : NSDictionary) throws -> NSDictionary{
        
        let jobAnnounceID = (jobDetail["JobAnnounceID"]) as! NSNumber
        let employeeID = (employee["EmployeeID"]) as! NSString
        
        let xmlStr = "<ws_apply xmlns='http://tempuri.org/'><jobAnnounceID>\(jobAnnounceID)</jobAnnounceID><employeeid>\(employeeID)</employeeid></ws_apply>"
        
        var resp = NSDictionary()
        
        do {
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_APPLY)
            
            return resp
        }catch {
            
            throw error            
        }
    }
    
    func getEmployeeDetail(_ employee : NSDictionary) throws -> NSDictionary {
        
        let employeeID = employee.object(forKey: "EmployeeID") as! String
        
        let xmlStr = "<ws_employeeDetail xmlns='http://tempuri.org/'><employeeID>\(employeeID)</employeeID></ws_employeeDetail>"
        var resp = NSDictionary()
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_DETAIL)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func getEmployeeDetail(withEmployeeID employeeID : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_employeeDetail xmlns='http://tempuri.org/'><employeeID>\(employeeID)</employeeID></ws_employeeDetail>"
        var resp = NSDictionary()
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_DETAIL)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func login(_ userCode : String , withPassword password: String) throws -> NSDictionary {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        /*
        var uuid = appDelegate.token
        
        if uuid != "" {
        
            let uuidSubString = uuid.replacingCharacters(in: uuid.startIndex..<uuid.characters.index(after: uuid.startIndex), with: "")
            
            uuid = uuidSubString
            
            uuid.remove(at: uuid.characters.index(before: uuid.endIndex))
            
        }
 */
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        let notiKey = appDelegate.notiKey
        
        let xmlStr = "<ws_employeeLogin xmlns='http://tempuri.org/'><userCode>\(userCode)</userCode><password>\(password)</password><deviceImei>\(uuid)</deviceImei><notificationToken>\(notiKey)</notificationToken></ws_employeeLogin>"
        
        var soapResp = NSDictionary()
        
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_LOGIN)
            
            return soapResp
            
            
        }catch {
            throw error
            
        }
    }
    
    
    func jobListSearch(_ jobSearchDetail : NSDictionary) throws -> NSDictionary {
        
        let jobPosition = jobSearchDetail["JobPosition"] != nil ? jobSearchDetail["JobPosition"] as! String : ""
        let provinceID = jobSearchDetail["ProvinceID"] != nil ? (jobSearchDetail["ProvinceID"] as! NSNumber).stringValue : ""
        let jobFiledID = jobSearchDetail["DepartmentId"] != nil ? (jobSearchDetail["DepartmentId"] as! NSNumber).stringValue : ""
        let degreeMinId = jobSearchDetail["DegreeMinId"] != nil ? (jobSearchDetail["DegreeMinId"] as! NSNumber).stringValue : ""
        let degreeMaxId = jobSearchDetail["DegreeMaxId"] != nil ? (jobSearchDetail["DegreeMaxId"] as! NSNumber).stringValue : ""
        
        let sexID = jobSearchDetail["SexID"] != nil  ? jobSearchDetail["SexID"] as! String : ""
        let ageMin = jobSearchDetail["AgeMin"] != nil  ? jobSearchDetail["AgeMin"] as! String : ""
        let ageMax = jobSearchDetail["AgeMax"] != nil  ? jobSearchDetail["AgeMax"] as! String : ""
        let disability = jobSearchDetail["Disability"] != nil  ? jobSearchDetail["Disability"] as! String : ""
        
        var xmlStr = "<ws_jobSearch xmlns='http://tempuri.org/'>"
        xmlStr += "<jobPosition>\(jobPosition)</jobPosition>"
        xmlStr += "<provinceID>\(provinceID)</provinceID>"
        xmlStr += "<jobFiledID>\(jobFiledID)</jobFiledID>"
        xmlStr += "<degreeID_min>\(degreeMinId)</degreeID_min>"
        xmlStr += "<degreeID_max>\(degreeMaxId)</degreeID_max>"
        xmlStr += "<sex>\(sexID)</sex>"
        xmlStr += "<age_min>\(ageMin)</age_min>"
        xmlStr += "<age_max>\(ageMax)</age_max>"
        xmlStr += "<disability>\(disability)</disability>"
        xmlStr += "</ws_jobSearch>"
        
        var resp = NSDictionary()
        
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_SEARCH)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getJobMatchingList(_ employee : NSDictionary) throws -> NSDictionary {
        
        let employeeID = employee["EmployeeID"] as! String
        
        var xmlStr = "<ws_jobMatching xmlns='http://tempuri.org/'>"
        xmlStr += "<employeeID>\(employeeID)</employeeID>"
        xmlStr += "</ws_jobMatching>"
        
        var resp = NSDictionary()
        do{
            
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_JOB_MATCHING)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getYourJobList(_ employee : NSDictionary) throws -> NSDictionary {
        
        let employeeID = employee["EmployeeID"] as! String
        
        var xmlStr = "<ws_employeeApply xmlns='http://tempuri.org/'>"
        xmlStr += "<employeeID>\(employeeID)</employeeID>"
        xmlStr += "</ws_employeeApply>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_APPLY)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getEmployerInterestedJobList(_ employee : NSDictionary) throws -> NSDictionary {
        
        let employeeID = employee["EmployeeID"] as! String
        
        var xmlStr = "<ws_employeeInterested xmlns='http://tempuri.org/'>"
        xmlStr += "<employeeID>\(employeeID)</employeeID>"
        xmlStr += "</ws_employeeInterested>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_EMPLOYEE_INTERESTED)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func employeeRegistration(_ employee : NSDictionary) throws -> NSDictionary {
        
        var xmlStr = "<ws_insertEmployeeRegister xmlns='http://tempuri.org/'>"
        xmlStr += "<personalID>" + (employee["PersonalID"] as! String) + "</personalID>"
        xmlStr += "<password>"+(employee["Password"] as! String)+"</password>"
        xmlStr += "<firstName>"+(employee["FirstName"] as! String)+"</firstName>"
        xmlStr += "<lastName>"+(employee["LastName"] as! String)+"</lastName>"
        xmlStr += "<telephone>"+(employee["Telephone"] as! String)+"</telephone>"
        xmlStr += "<sex>"+(employee["Sex"] as! String)+"</sex>"
        xmlStr += "<prefixID>"+(employee["PrefixID"] as! String)+"</prefixID>"
        xmlStr += "<birthDate>"+(employee["BirthDay"] as! String)+"</birthDate>"
        xmlStr += "<provinceid>"+(employee["ProvinceID"] as! String)+"</provinceid>"
        xmlStr += "<amphoeid>"+(employee["AmphoeID"] as! String)+"</amphoeid>"
        xmlStr += "<tambonid>"+(employee["TambonID"] as! String)+"</tambonid>"
        xmlStr += "<requestPosition>"+(employee["RequestPosition"] as! String)+"</requestPosition>"
        xmlStr += "<jobPositionID>"+(employee["JobPositionID"] as! String)+"</jobPositionID>"
        xmlStr += "<jobPosition>"+(employee["JobPosition"] as! String)+"</jobPosition>"
        xmlStr += "<degreeID>"+(employee["DegreeID"] as! String)+"</degreeID>"
        xmlStr += "<departmentID>"+(employee["DepartmentID"] as! String)+"</departmentID>"
        
        xmlStr += "<addrNumber>"+(employee["addrNumber"] as! String)+"</addrNumber>"
        xmlStr += "<zipCode>"+(employee["zipCode"] as! String)+"</zipCode>"
        xmlStr += "<workProvinceID>"+(employee["workProvinceID"] as! String)+"</workProvinceID>"
        
        xmlStr += "</ws_insertEmployeeRegister>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_INSERT_EMPLOYEE_REGISTER)
            
            return resp
        }catch {
            throw error
        }
    
    }
    
    func updateMemberDetail(_ employee : NSDictionary) throws -> NSDictionary {
        
        var xmlStr = "<ws_updateMemberDetail xmlns='http://tempuri.org/'>"
        xmlStr += "<userID>" + (employee["UserID"] as! String) + "</userID>"
        xmlStr += "<personalID>" + (employee["PersonalID"] as! String) + "</personalID>"
        
        if employee["Password"] != nil {
            xmlStr += "<password>"+(employee["Password"] as! String)+"</password>"
        }else{
            xmlStr += "<password></password>"
        }
        
        xmlStr += "<firstName>"+(employee["FirstName"] as! String)+"</firstName>"
        xmlStr += "<lastName>"+(employee["LastName"] as! String)+"</lastName>"
        xmlStr += "<telephone>"+(employee["Telephone"] as! String)+"</telephone>"
        xmlStr += "<sex>"+(employee["Sex"] as! String)+"</sex>"
        xmlStr += "<prefixID>"+(employee["PrefixID"] as! String)+"</prefixID>"
        xmlStr += "<birthDate>"+(employee["BirthDay"] as! String)+"</birthDate>"
        xmlStr += "<provinceid>"+(employee["ProvinceID"] as! String)+"</provinceid>"
        xmlStr += "<amphoeid>"+(employee["AmphoeID"] as! String)+"</amphoeid>"
        xmlStr += "<tambonid>"+(employee["TambonID"] as! String)+"</tambonid>"
        xmlStr += "<requestPosition>"+(employee["RequestPosition"] as! String)+"</requestPosition>"
        xmlStr += "<jobPositionID>"+(employee["JobPositionID"] as! String)+"</jobPositionID>"
        xmlStr += "<jobPosition>"+(employee["JobPosition"] as! String)+"</jobPosition>"
        xmlStr += "<degreeID>"+(employee["DegreeID"] as! String)+"</degreeID>"
        xmlStr += "<departmentID>"+(employee["DepartmentID"] as! String)+"</departmentID>"
        xmlStr += "<addrNumber>"+(employee["addrNumber"] as! String)+"</addrNumber>"
        xmlStr += "<zipCode>"+(employee["zipCode"] as! String)+"</zipCode>"
        xmlStr += "<workProvinceID>"+(employee["workProvinceID"] as! String)+"</workProvinceID>"
        xmlStr += "<createFunctionFlag>\(employee["createFunctionFlag"] as! String)</createFunctionFlag>"
        xmlStr += "</ws_updateMemberDetail>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_UPDATE_MEMBER_DETAIL)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func hasApplyThisJob(_ employee : NSDictionary , withJob jobAnnounceID : String) -> Bool {
        
        var result = false
        
        var jobListResult = NSDictionary()
        
        do{
        
            try jobListResult = self.getYourJobList(employee)
            
            let jobItems = jobListResult["RespBody"] as! [[String:Any]]
            
            if jobItems.count > 0 {
                for job in jobItems {
                    
                    let jobAnounceIdInList = job["JobAnnounceID"] as! NSNumber
                    
                    if "\(jobAnounceIdInList)" == jobAnnounceID {
                        result = true
                        break;
                    }
                }
            }else{
                result = false
            }
            
        }catch {
            result = false
        }
        
        
        return result
        
    }
    
    func changePassword(usercode : String , password : String , birthDate : String) throws -> NSDictionary {
        
        var xmlStr = "<ws_changePassword xmlns='http://tempuri.org/'>"
        xmlStr += "<userCode>\(usercode)</userCode>"
        xmlStr += "<password>\(password)</password>"
        xmlStr += "<birthDate>\(birthDate)</birthDate>"
        xmlStr += "</ws_changePassword>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.WS_CHANGE_PASSWORD)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func checkChangePassword(usercode : String , birthDate : String) throws -> NSDictionary {
        
        var xmlStr = "<ws_checkChangePwd xmlns='http://tempuri.org/'>"
        xmlStr += "<userCode>\(usercode)</userCode>"
        xmlStr += "<birthDate>\(birthDate)</birthDate>"
        xmlStr += "</ws_checkChangePwd>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.WS_CHECK_CHANGE_PASSWORD)
            
            return resp
        }catch {
            throw error
        }
    }
    
    func updateInsured(memberId : String , regId : String , results : String , regDate : String , jobDate : String , company : String , compAddress : String , compMobileNo : String , compContract : String , empID : String , isReport6th : String) throws -> NSDictionary {
        
        let xmlStr = "<updateInsured xmlns='http://tempuri.org/'>" +
        "<memberId>\(memberId)</memberId>" +
        "<regId>\(regId)</regId>" +
        "<results>\(results)</results>" +
        "<regDate>\(regDate)</regDate>" +
        "<jobDate>\(jobDate)</jobDate>" +
        "<company>\(company)</company>" +
        "<compAddress>\(compAddress)</compAddress>" +
        "<compMobileNo>\(compMobileNo)</compMobileNo>" +
        "<compContract>\(compContract)</compContract>" +
        "<empID>\(empID)</empID>" +
        "<isReport6th>\(isReport6th)</isReport6th>" +
        "</updateInsured>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.UPDATE_INSURED)
            
            return resp
        }catch {
            throw error
        }
    }
    


    
    


}
