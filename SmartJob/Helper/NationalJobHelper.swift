//
//  NationalJobHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 17/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalJobHelper: NSObject {
    
    let workStatus : NSMutableArray = [
        "ยกเลิก" ,
        "ว่างงาน" ,
        "ว่างงาน (จต.2)" ,
        "ว่างงาน (ระบบบริษัท)" ,
        "อยู่ระหว่างการคัดเลือก" ,
        "ผ่านการคัดเลือก" ,
        "ผ่านการอนุญาต" ,
        "รอเดินทาง" ,
        "ทํางาน" ,
        "พักทํางาน" ,
        "ครบสัญญา"
    ]
    
    let fundStatus : NSMutableArray = [
        "เป็น" ,
        "ไม่เป็น"
    ]
    
    func getStatusWorkFund(idCard : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getStatusTravelFund_func xmlns='http://tempuri.org/'>" +
            "<idCard>\(idCard)</idCard>" +
        "</getStatusTravelFund_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_STATUS_TRAVEL_FUND_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    
    
    func getCountryTravel() throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getCountryTravel_func xmlns='http://tempuri.org/'>" +
        "</getCountryTravel_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_COUNTRY_TRAVEL_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }
    
    func getBranchTestPlace() throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getBranchTestPlace_func xmlns='http://tempuri.org/'>" +
        "</getBranchTestPlace_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_BRANCH_TEST_PLACE_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }


}
