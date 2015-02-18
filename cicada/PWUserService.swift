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
        let networkService = PWNetworkService.sharedInstance

        // Alamofire authenicate method should not be used as it support Basic Authentication only. It uses NSURLCredential and NSURLSessionAuthChallengeDisposition
        //networkService.networkManager.request(.POST, "http://localhost:8080/login").authenticate(user: userName, password: password)

        // underneath, a 302 and then 304 is returned. This might need to be changed
        networkService.networkManager.request(.POST, "http://localhost:8080/login", parameters: ["username":userName,"password":password])
            .validate()
            .responseString { (request, response, data, error) in
                networkService.logHttpResponse(request, response: response, data: data, error: error)
                
                if let err = error {
                    println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
                } else {
                    println("Successfully logged in.")
                }
                
                // ALWAYS call callBack so that caller can handle successful and unsuccessful logon request
                callBack(response: response, data: data, error: error)
        }
    }
    
    
    
    func testPost(#username: String, password: String, callBack: (response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void) {
        let networkService = PWNetworkService.sharedInstance
        let serializer = Alamofire.Request.stringResponseSerializer(encoding: NSUTF8StringEncoding)
        
        networkService.networkManager.request(.POST, "http://localhost:8080/country/login", parameters: ["username":"x","password":"p"])
            //.authenticate(user: username, password: password)
            .responseJSON { (request, response, data, error) in
                networkService.logHttpResponse(request, response: response, data: data, error: error)
                
                if let err = error {
                    println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
                } else {
                    println("Successfully logged in.")
                    
                }
                
                // ALWAYS call callBack so that caller can handle successful and unsuccessful logon request
                callBack(response: response, data: data, error: error)
        }
    }

    
    class func logoff() -> Bool {
        // TODO
        // - to be implemented
        return true
    }
}