//
//  NationalPostionHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class NationalPostionHelper: NSObject {
    
    func getNationalPostion(poId : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<getPositionInfo_func xmlns='http://tempuri.org/'>" +
            "<poId>\(poId)</poId>" +
        "</getPositionInfo_func>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.GET_COMPANY_INFO_FUNC)
            
            return resp
        }catch {
            throw error
        }
        
    }

}
