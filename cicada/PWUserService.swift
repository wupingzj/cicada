//
//  PWUserService.swift
//  cicada
//
//  Created by Ping on 31/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation
import Alamofire

class PWUserService {
    class var sharedInstance: PWUserService {
        struct Singleton {
            static let instance = PWUserService()
        }
        return Singleton.instance
    }
    
//    init() {
//    }
    
    var isLoggedIn: Bool = false
    
    func isLoggedon() -> Bool {
        return isLoggedIn
    }
    
    func isSessionExpired() -> Bool {
        // TODO
        // To implement the logic of invalidating the underlying session expiring after a period of non-activity
        // Not essentially for this stage yet
        return false
    }
    
    func logon(#userName: String, password: String, callBack: (response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void) {
        // Alamofire authenicate method should not be used as it support Basic Authentication only. It uses NSURLCredential and NSURLSessionAuthChallengeDisposition

        // underneath, a 302 and then 304 is returned. This might need to be changed
        let url: String = PWNetworkService.sharedInstance.getURLBase() + "/login"
        Alamofire.request(.POST, url, parameters: ["username":userName,"password":password])
            .validate()
            .responseString { (request, response, data, error) in
                PWNetworkService.logHttpResponse(request, response: response, data: data, error: error)
                
                if let err = error {
                    println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
                } else {
                    self.isLoggedIn = true
                    
                    println("Successfully logged in.")
                }
                
                // ALWAYS call callBack so that caller can handle successful and unsuccessful logon request
                callBack(response: response, data: data, error: error)
        }
    }
    
    func logoff() -> Bool {
        // TODO
        // - to be implemented
        return true
    }
    
    class func isRedirectToLogon(response: NSHTTPURLResponse?) -> Bool {
        if response == nil {
            return false
        } else {
            return response!.URL!.path == getLogonPath()
        }
    }
    
    // Not including baseURL
    class func getLogonPath() -> String {
        return "/login"
    }
}