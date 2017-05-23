//
//  MasterDataHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/5/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class MasterDataHelper: NSObject {
    
    func getValueInArray(_ array : NSMutableArray , withType arrayType : String , byKeyName keyName : String , andKeyValue  keyValue : String , forDataName dataName : String) -> String {
        
        var result = ""
        
        
        for dict in array {
            var objString = ""
            if arrayType == "NSNumber" {
                let temp = (dict as AnyObject).value(forKey: keyName) as! NSNumber
                objString = "\(temp)"
            }else if arrayType == "NSTaggedPointerString" {
                let temp = (dict as AnyObject).value(forKey: keyName) as! NSString
                objString = "\(temp)"
            }else{
                objString = (dict as AnyObject).value(forKey: keyName) as! String
            }
            
            if objString == keyValue {
                result = (dict as AnyObject).value(forKey: dataName) as! String
                break
            }
            
        }
        
        return result as String
        
    }
    
    func getKeyInArray(_ array : NSMutableArray , withType arrayType : String , byKeyName keyName : String , andValue  value : String , forDataName dataName : String) -> String {
        
        var result = ""
        
        
        for dict in array {
            let temp = dict as! NSDictionary
            let name = temp.object(forKey: dataName) as! String
            
            if name == value{
                result = String(describing: temp.object(forKey: keyName) as! NSNumber)
                break
            }
        }
        
        return result as String
        
    }
    
    func getKeyWithConcatInArray(_ array : NSMutableArray , withType arrayType : String , byKeyName keyName : String , andConcatWord concatWord : String , andValue  value : String , forDataName dataName : String) -> String {
        
        var result = ""
        
        
        for dict in array {
            let temp = dict as! NSDictionary
            var name = temp.object(forKey: dataName) as! String
            name = name + concatWord
            if name == value{
                result = String(describing: temp.object(forKey: keyName) as! NSNumber)
                break
            }
        }
        
        return result as String
        
    }
    
    func getProvince() throws -> NSDictionary {
        
        let xmlStr = "<ws_masterProvince xmlns='http://tempuri.org/' />"
        
        var soapResp = NSDictionary()
        
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_PROVINCE)
            
            return soapResp
        }catch {
            throw error
        }
    }
    
    func getAmphoe(_ provinceID : String) throws -> NSDictionary {
    
        let xmlStr = "<ws_masterAmphoe xmlns='http://tempuri.org/'><provinceID>\(provinceID)</provinceID></ws_masterAmphoe>"
        
        var soapResp = NSDictionary()
        
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_AMPHOE)
            
            return soapResp
        }catch {
            throw error
        }
    
    }
    
    func getTambon(_ amphoeID : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_masterTambon xmlns='http://tempuri.org/'><amphoeID>\(amphoeID)</amphoeID></ws_masterTambon>"
        
        var soapResp = NSDictionary()
        
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_TAMBON)
            
            return soapResp
        }catch {
            throw error
        }
        
    }
    
    func getSexList() -> NSMutableArray {
        let male = ["SexID" : "1" , "SexName" : "ชาย"]
        let femail = ["SexID" : "2" , "SexName" : "หญิง"]
        let sexArray = NSMutableArray()
        sexArray.add(male)
        sexArray.add(femail)
        
        return sexArray
    }
    
    
    
    func getJobType() throws -> NSDictionary {
        
        let xmlStr = "<ws_masterJobType xmlns='http://tempuri.org/' />"
        
        var soapResp = NSDictionary()
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_JOB_TYPE)
            
            return soapResp
        }catch {
            throw error
        }
        
    }
    
    func getEducation() throws -> NSDictionary {
        
        let xmlStr = "<ws_masterEducation xmlns='http://tempuri.org/' />"
        
        var soapResp = NSDictionary()
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_EDUCATION)
            
            return soapResp
        }catch {
            throw error
        }
    }
    
    func getDepartment(_ degreeID : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_masterDepartment xmlns='http://tempuri.org/'><degreeID>\(degreeID)</degreeID></ws_masterDepartment>"
        
        var soapResp = NSDictionary()
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_DEPARTMENT)
            
            return soapResp
        }catch {
            throw error
        }
    }
    
    func getSuggestJobPosition(_ keyword : String) throws -> NSDictionary {
        
        let xmlStr = "<ws_suggestJobPosition xmlns='http://tempuri.org/'><keyword>\(keyword)</keyword></ws_suggestJobPosition>"
        
        var soapResp = NSDictionary()
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_DEPARTMENT)
            
            return soapResp
        }catch {
            throw error
        }
    }
    
    func getTitleName() throws -> NSDictionary {
        
        let xmlStr = "<ws_masterTitleName xmlns='http://tempuri.org/' />"
        
        var soapResp = NSDictionary()
        do{
            try soapResp = SOAPServiceHelper.sharedInstance.invoke(xmlStr, withService: ServiceConstant.SERVICE_MASTER_TITLE_NAME)
            
            return soapResp
        }catch {
            throw error
        }
    }
    
    func getMonthNameFromInt(_ monthID : Int) -> String {
    
        let monthArray = NSMutableArray()
        
        monthArray.insert("มกราคม", at: 0)
        monthArray.insert("กุมภาพันธ์", at: 1)
        monthArray.insert("มีนาคม", at: 2)
        monthArray.insert("เมษายน", at: 3)
        monthArray.insert("พฤษภาคม", at: 4)
        monthArray.insert("มิถุนายน", at: 5)
        monthArray.insert("กรกฎาคม", at: 6)
        monthArray.insert("สิงหาคม", at: 7)
        monthArray.insert("กันยายน", at: 8)
        monthArray.insert("ตุลาคม", at: 9)
        monthArray.insert("พฤศจิกายน", at: 10)
        monthArray.insert("ธันวาคม", at: 11)
        
        return monthArray.object(at: monthID - 1) as! String

    
    }


}
