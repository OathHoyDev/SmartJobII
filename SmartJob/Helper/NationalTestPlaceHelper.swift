//
//  NationalTestPlaceHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 17/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalTestPlaceHelper: NSObject {
    
    func getTestPlaceList(tpName : String , pvId : String , tpType : String , branchId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getTestPlaceInfo_func xmlns='http://tempuri.org/'>" +
            "<tpName>\(tpName)</tpName>" +
            "<pvId>\(pvId)</pvId>" +
            "<tpType>\(tpType)</tpType>" +
            "<coutId>\(branchId)</coutId>" +
            "</getTestPlaceInfo_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_TEST_PLACE_INFO_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getTestPlace(tpId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getTestPlaceDetail_func xmlns='http://tempuri.org/'>" +
            "<tpId>\(tpId)</tpId>" +
        "</getTestPlaceDetail_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_TEST_PLACE_DETAIL_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }


}
