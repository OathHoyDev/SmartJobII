//
//  EGAErrorMessage.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/14/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EGAErrorMessage: NSObject {
    
    let errorMessage = ["90005":"ปิดบริการหรืออยู่นอกช่วงเวลาทำการ"]
    
    func getErrorDictinary() -> NSDictionary {
        return errorMessage as NSDictionary
    }
}
