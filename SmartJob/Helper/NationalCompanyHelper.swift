//
//  NationalCompanyHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalCompanyHelper: NSObject {
    
    func getCompanyInfo(name : String , companyName : String , pvId : String , permitCode : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getCompanyInfo_func xmlns='http://tempuri.org/'>" +
            "<name>\(name)</name>" +
            "<companyName>\(companyName)</companyName>" +
            "<pvId>\(pvId)</pvId>" +
            "<permitCode>\(permitCode)</permitCode>" +
        "</getCompanyInfo_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_COMPANY_INFO_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getCompanyDetail(companyId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getCompanyDetail_func xmlns='http://tempuri.org/'><companyId>\(companyId)</companyId></getCompanyDetail_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_COMPANY_DETAIL_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    

}
