//
//  WorkAbroadInfoHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 16/4/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class WorkAbroadInfoHelper: NSObject {
    
    func getAllWorkAbroadInfo() throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        let xmlStr = "<workAbroadInfo xmlns='http://tempuri.org/'></workAbroadInfo>"
        
        do {
            try resp =  SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.WORK_ABROAD_INFO)
            
            return resp
        }catch {
            throw error
        }
        
    }

}
