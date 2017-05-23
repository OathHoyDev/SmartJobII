//
//  NationalHospitalHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalHospitalHelper: NSObject {
    
    func getHospitalList(hpName : String , pvId : String , hpType : String , ctId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getHospitalInfo_func xmlns='http://tempuri.org/'>" +
            "<hpName>\(hpName)</hpName>" +
            "<pvId>\(pvId)</pvId>" +
            "<hpType>\(hpType)</hpType>" +
            "<ctId>\(ctId)</ctId>" +
            "</getHospitalInfo_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_HOSPITAL_INFO_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getHospital(hpId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getHospitalDetail_func xmlns='http://tempuri.org/'>" +
            "<hpId>\(hpId)</hpId>" +
            "</getHospitalDetail_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_HOSPITAL_DETAIL_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }

}
