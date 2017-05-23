//
//  SOAPServiceHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/15/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

typealias ServiceResponse = (String) -> Void

class SOAPServiceHelper: NSObject , UIAlertViewDelegate {
    
    static let sharedInstance = SOAPServiceHelper()
    
    //let urlString = "http://111.223.34.154/ws_ega1503/services.asmx"
    
    let soapHeader = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body>"
    
    let soapFooter = "</soap:Body></soap:Envelope>"
    
    func createSOAPXML(_ requestXML : String) -> String {
        
        let soapMessage = "\(soapHeader)\(requestXML)\(soapFooter)"
        
        return soapMessage
        
    }
    
    func invoke(_ requestString : String , withService serviceString:String) throws -> NSDictionary {
        
        let url = URL(string: "\(ServiceConstant.SERVICE_URL)?op=\(serviceString)")
        let request = NSMutableURLRequest(url: url! , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        let soapMessage = createSOAPXML(requestString)
        
        //print("soapMessage : \(soapMessage)")
        
        let msgLength = "\(soapMessage.characters.count)"
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }
    
    func invokeToEGAForGetToken(_ citizenID : String) throws -> NSDictionary {
        
        let url = URL(string: "\(ServiceConstant.SERVICE_EGA_URL_GET_TOKEN)?ConsumerSecret=\(ServiceConstant.CONSUMER_SECRET)&AgentID=\(ServiceConstant.AGENT_ID)")
        let request = NSMutableURLRequest(url: url! , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        //let soapMessage = createSOAPXML(requestString)
        
        //let msgLength = "\(soapMessage.characters.count)"
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue(ServiceConstant.CONSUMER_KEY, forHTTPHeaderField: "Consumer-Key")
        request.httpMethod = "GET"
        //request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }
    
    func invokeToEGAForGetTokenForLaserCode(_ citizenID : String) throws -> NSDictionary {
        
        let url = URL(string: "\(ServiceConstant.SERVICE_EGA_URL_GET_TOKEN)?ConsumerSecret=\(ServiceConstant.LASERCODE_CONSUMER_SECRET)&AgentID=\(ServiceConstant.LASERCODE_AGENT_ID)")
        let request = NSMutableURLRequest(url: url! , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        //let soapMessage = createSOAPXML(requestString)
        
        //let msgLength = "\(soapMessage.characters.count)"
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue(ServiceConstant.LASERCODE_CONSUMER_KEY, forHTTPHeaderField: "Consumer-Key")
        request.httpMethod = "GET"
        //request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }
    
    func invokeToEGAForGetSimpleProfile(_ citizenID : String , withToken token : String) throws -> NSDictionary {
        
        let url = URL(string: "\(ServiceConstant.SERVICE_EGA_URL_GET_PROFILE)?CitizenID=\(citizenID)")
        let request = NSMutableURLRequest(url: url! , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        //let soapMessage = createSOAPXML(requestString)
        
        //let msgLength = "\(soapMessage.characters.count)"
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue(ServiceConstant.CONSUMER_KEY, forHTTPHeaderField: "Consumer-Key")
        request.addValue(token, forHTTPHeaderField: "Token")
        request.httpMethod = "GET"
        //request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }
    

    func invokeCheckLasercode(profile : NSDictionary) throws -> NSDictionary {
        
        //        ?CitizenID=<CitizenID>& FirstName=<FirstName>&LastName=<LastName>&BEBirthDate=<BEBirthDate>& LaserCode=<LaserCode>"
        
        let citizenId = profile.object(forKey: "CitizenID") as! String
        let firstName = profile.object(forKey: "FirstName") as! String
        let lastName = profile.object(forKey: "LastName") as! String
        let bebBirthDate = profile.object(forKey: "BEBirthDate") as! String
        let lasercode = profile.object(forKey: "LaserCode") as! String
        
        var str = "\(ServiceConstant.SERVICE_EGA_URL_CHECK_LASERCODE)?CitizenID=\(citizenId)&FirstName=\(firstName)&LastName=\(lastName)&BEBirthDate=\(bebBirthDate)&LaserCode=\(lasercode)"
        
        let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!

        
        let request = NSMutableURLRequest(url: url as! URL , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(ServiceConstant.LASERCODE_CONSUMER_KEY , forHTTPHeaderField: "Consumer-Key")
        request.addValue("", forHTTPHeaderField: "Token")
        request.httpMethod = "GET"
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }
    
    func invokeCheckLasercode(profile : NSDictionary , withToken token : String) throws -> NSDictionary {
        
        //        ?CitizenID=<CitizenID>& FirstName=<FirstName>&LastName=<LastName>&BEBirthDate=<BEBirthDate>& LaserCode=<LaserCode>"
        
        let citizenId = profile.object(forKey: "CitizenID") as! String
        let firstName = profile.object(forKey: "FirstName") as! String
        let lastName = profile.object(forKey: "LastName") as! String
        let bebBirthDate = profile.object(forKey: "BEBirthDate") as! String
        let lasercode = profile.object(forKey: "LaserCode") as! String
        
        var str = "\(ServiceConstant.SERVICE_EGA_URL_CHECK_LASERCODE)?CitizenID=\(citizenId)&FirstName=\(firstName)&LastName=\(lastName)&BEBirthDate=\(bebBirthDate)&LaserCode=\(lasercode)"
        
        let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        
        let request = NSMutableURLRequest(url: url as! URL , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(ServiceConstant.LASERCODE_CONSUMER_KEY , forHTTPHeaderField: "Consumer-Key")
        request.addValue(token, forHTTPHeaderField: "Token")
        request.httpMethod = "GET"
        
        var resp = NSDictionary()
        
        do {
            try resp = requestService(request)
            return resp
        }catch {
            throw error
        }
    }

    
    func requestService(_ request : NSMutableURLRequest) throws -> NSDictionary {
        
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        
        var jsonSource = Data()
        
        do {
            jsonSource = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response )
        }catch {
            //print("Error Connection")
            throw error
        }
        
        var responseData = NSString(data: jsonSource, encoding: String.Encoding.utf8.rawValue)! as String
        
        //print("responseData : \(responseData)")
        
        if responseData.contains("xml") {
            responseData = responseData.substring(to: responseData.range(of: "<?xml")!.lowerBound)
        }
        
        let jsonHelper = JSONHelper()
        
        return jsonHelper.convertToJSON(responseData)
        
    }
}
