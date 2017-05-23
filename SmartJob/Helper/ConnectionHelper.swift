//
//  ConnectionHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/14/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

protocol ConnectionHelperProtocol {
    func didReceiveResults(_ results: NSString?)
}

class ConnectionHelper: NSObject , URLSessionDelegate, URLSessionTaskDelegate {
    
    let urlString = "http://111.223.34.154/ws_ega1503/services.asmx"
    
    let soapHeader = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body>"
    
    let soapFooter = "</soap:Body></soap:Envelope>"
    
    var data = NSMutableData()
    
    
    var delegate: ConnectionHelperProtocol?
    
    init(delegate: ConnectionHelperProtocol?) {
        self.delegate = delegate
    }
    
    
    typealias Callback = ((String?, NSString?) -> ())
    
    func invokeService(_ requestString : String , withService serviceString:String , callback: Callback){
        
        self.requestService(requestString, withService: serviceString) {
            (data, error) -> Void in
            if (error == nil){
                self.delegate?.didReceiveResults(data as NSString?)
            }
        }
    }
    
    
    func createSOAPXML(_ requestXML : String) -> String {
        
        let soapMessage = "\(soapHeader)\(requestXML)\(soapFooter)"
        
        return soapMessage
        
    }

    func requestService(_ requestString : String , withService serviceString:String , callback: @escaping Callback) {
        
        let url = URL(string: "\(urlString)?op=\(serviceString)")
        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        
        let soapMessage = createSOAPXML(requestString)
        
        let msgLength = "\(soapMessage.characters.count)"
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        //print("Request : \(request)")
        
        httpRequest(request as URLRequest!){
            (data, error) -> Void in
            callback(data, error)
        }
        
        
    }
    
    func httpRequest(_ request: URLRequest!, callback: @escaping Callback){
        
        var responseData = ""
    
        let session = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if error != nil {
//                print("error=\(error)")
                callback(nil, error!.localizedDescription as NSString?)
            }else{
                responseData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                responseData = responseData.substring(to: responseData.range(of: "<?xml")!.lowerBound)
                callback(responseData , nil)
                //print("responseData : \(responseData)")
            }
        })
        //session.resume()
    
    }
    
    func convertToJSON(_ responseData : String) -> NSDictionary {
        
        let data = responseData.data(using: String.Encoding.utf8)
        var json = NSDictionary()
        
        // convert NSData to 'AnyObject'
        json =  (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
        
        return json
    }
    
    
    
}
