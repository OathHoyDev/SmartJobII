//
//  EGAHelper.swift
//  SmartJob
//
//  Created by SilVeriSm on 12/9/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class EGAHelper: NSObject {
    
    func getTokenByCitizenID(_ citizenID : String) throws -> NSDictionary  {
        
        var tokenResp = NSDictionary()
        
        do{
            
            try tokenResp = SOAPServiceHelper.sharedInstance.invokeToEGAForGetToken(citizenID)
            
        }catch {
            
            throw error
            
        }
        
        return tokenResp
    }
    
    func getTokenByCitizenIDForLaserCode(_ citizenID : String) throws -> NSDictionary  {
        
        var tokenResp = NSDictionary()
        
        do{
            
            try tokenResp = SOAPServiceHelper.sharedInstance.invokeToEGAForGetTokenForLaserCode(citizenID)
            
        }catch {
            
            throw error
            
        }
        
        return tokenResp
    }
    
    func getSimpleProfileByCitizenID(_ citizenID : String , withToken token : String) throws -> NSDictionary {
    
        var resp = NSDictionary()
        
        do {
        
            resp = try SOAPServiceHelper.sharedInstance.invokeToEGAForGetSimpleProfile(citizenID, withToken: token)
            
            
        
        } catch {
            
            throw error
        
        }
        
        return resp
        
    }
    
    func checkLacerCodeByProfile(profile : NSDictionary) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        do {
            
            resp = try SOAPServiceHelper.sharedInstance.invokeCheckLasercode(profile: profile)
            
            
            
        } catch {
            
            throw error
            
        }
        
        return resp
        
    }
    
    func checkLacerCodeByProfile(profile : NSDictionary , withToken token : String) throws -> NSDictionary {
        
        var resp = NSDictionary()
        
        do {
            
            resp = try SOAPServiceHelper.sharedInstance.invokeCheckLasercode(profile: profile, withToken: token)
            
            
            
        } catch {
            
            throw error
            
        }
        
        return resp
        
    }


    
    func getErrorMessageFromErrorCode(_ errorcode : String) -> String {
        
        let egaErrorMessage = EGAErrorMessage()
    
        let errorDict = egaErrorMessage.getErrorDictinary()
        
        return errorDict.object(forKey: errorcode) as! String
    
    }
    
}
