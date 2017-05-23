//
//  EmpuiHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 30/3/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EmpuiHelper: NSObject {
    
    func getPresentDate(_ memberId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getPresentDate xmlns='http://tempuri.org/'><memberId>\(memberId)</memberId></getPresentDate>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_GET_PRESENT_DATE)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getProvince() throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getProvince_func xmlns='http://tempuri.org/'>" +
        "</getProvince_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_PROVINCE_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getPresentInsured(memberId : String , personalId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<presentInsured xmlns='http://tempuri.org/'>" +
            "<nationalId>\(personalId)</nationalId>" +
            "<memberId>\(memberId)</memberId>" +
        "</presentInsured>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_PRESENT_INSURED)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getHistoryPresentDate(_ memberId : String , andNationalId nationalId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<historyRegisterd xmlns='http://tempuri.org/'><memberId>\(memberId)</memberId><nationalId>\(nationalId)</nationalId></historyRegisterd>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_HISTORY_REGISTERD)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func updateLaserCode(memberId : String , nationalId : String , laserCode : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<updateLaserCode xmlns='http://tempuri.org/'>" +
            "<memberId>\(memberId)</memberId>" +
            "<nationalId>\(nationalId)</nationalId>" +
            "<laserCode>\(laserCode)</laserCode>" +
        "</updateLaserCode>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.UPDATE_LACER_CODE)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func checkAccount(personalID : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<ws_checkAccount xmlns='http://tempuri.org/'>" +
            "<personalID>\(personalID)</personalID>" +
        "</ws_checkAccount>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.UPDATE_LACER_CODE)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func empuiRegistration(_ employee : NSDictionary) throws -> NSDictionary {
        
        var xmlStr = "<registerEmpuiMember xmlns='http://tempuri.org/'>"
        xmlStr += "<nationalId>" + (employee["nationalId"] as! String) + "</nationalId>"
        xmlStr += "<cvvCode></cvvCode>"
        xmlStr += "<password>"+(employee["password"] as! String)+"</password>"
        xmlStr += "<email>"+(employee["email"] as! String)+"</email>"
        xmlStr += "<title>"+(employee["title"] as! String)+"</title>"
        xmlStr += "<firstName>"+(employee["firstName"] as! String)+"</firstName>"
        xmlStr += "<lastName>"+(employee["lastName"] as! String)+"</lastName>"
        xmlStr += "<mobileNo>"+(employee["mobileNo"] as! String)+"</mobileNo>"
        xmlStr += "<gender>"+(employee["gender"] as! String)+"</gender>"
        xmlStr += "<addrNumber>"+(employee["addrNumber"] as! String)+"</addrNumber>"
        xmlStr += "<addrMoo>"+(employee["addrMoo"] as! String)+"</addrMoo>"
        xmlStr += "<addrSoi>"+(employee["addrSoi"] as! String)+"</addrSoi>"
        xmlStr += "<addrStreet>"+(employee["addrStreet"] as! String)+"</addrStreet>"
        xmlStr += "<addrProvinceId>"+(employee["addrProvinceId"] as! String)+"</addrProvinceId>"
        xmlStr += "<addrDistrictId>"+(employee["addrDistrictId"] as! String)+"</addrDistrictId>"
        xmlStr += "<addrTumbolId>"+(employee["addrTumbolId"] as! String)+"</addrTumbolId>"
        xmlStr += "<zipcode>"+(employee["zipcode"] as! String)+"</zipcode>"
        xmlStr += "<birthday>"+(employee["birthday"] as! String)+"</birthday>"
        xmlStr += "</registerEmpuiMember>"
        
        var resp = NSDictionary()
        do{
            try resp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.EMPUI_REGISTRATION)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func registerInsured(memberId : String , eduLevel : String , reqPositionName : String , reqProvinceId : String , nationalId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<registerInsured xmlns='http://tempuri.org/'>" +
            "<memberId>\(memberId)</memberId>" +
        "<eduLevel>\(eduLevel)</eduLevel>" +
        "<reqPositionName>\(reqPositionName)</reqPositionName>" +
        "<reqProvinceId>\(reqProvinceId)</reqProvinceId>" +
        "<nationalId>\(nationalId)</nationalId>" +
        "</registerInsured>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.REGISTER_INSURED)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func updateInsure(employee : NSDictionary) throws -> NSDictionary {
    
        var resp = NSDictionary()
        
        let xmlStr = "<updateInsured xmlns='http://tempuri.org/'>" +
            "<memberId>\(employee.object(forKey: "memberId") as! String)</memberId>" +
            "<regId>\(employee.object(forKey: "regId") as! String)</regId>" +
            "<results>\(employee.object(forKey: "results") as! String)</results>" +
            "<jobDate>\(employee.object(forKey: "jobDate") as! String)</jobDate>" +
            "<company>\(employee.object(forKey: "") as! String)</company>" +
            "<compAddress>\(employee.object(forKey: "") as! String)</compAddress>" +
            "<compMobileNo>\(employee.object(forKey: "") as! String)</compMobileNo>" +
            "<compContract>\(employee.object(forKey: "") as! String)</compContract>" +
            "<empID>\(employee.object(forKey: "") as! String)</empID>" +
            "<isReport6th>\(employee.object(forKey: "") as! String)</isReport6th>" +
            "</updateInsured>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.REGISTER_INSURED)
            
            return resp
        }catch {
            throw error
        }

    
    
    }
    
    func getInfoTracking(memberId : String , regId : String) throws -> NSDictionary {
    
        var resp = NSDictionary()
        
        let xmlStr = "<getInfoTracking xmlns='http://tempuri.org/'>" +
            "<memberId>\(memberId)</memberId>" +
            "<regId>\(regId)</regId>" +
        "</getInfoTracking>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_INFO_TRACKING)
            
            return resp
        }catch {
            throw error
        }
    
    
    }


}
