//
//  JSONHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/16/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class JSONHelper: NSObject {
    
    func convertToJSON(_ responseData : String) -> NSDictionary {
        
        let data = responseData.data(using: String.Encoding.utf8)
        var json = NSDictionary()
        
        // convert NSData to 'AnyObject'
        do {
        
            json =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
        }catch{
//                print("Error JSON : \(error)")
        }
        
        return json
    }

}
