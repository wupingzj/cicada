//
//  PWNetworkService.swift
//  cicada
//
//  Created by Ping on 13/02/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import Alamofire

class PWNetworkService {
    class var sharedInstance: PWNetworkService {
        struct Singleton {
            static let instance = PWNetworkService()
        }
        return Singleton.instance
    }
    
    var networkManager: Alamofire.Manager!
    let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    // To show cookies: println(self.cookies.cookiesForURL(NSURL(string: "http://httpbin.org/cookies")!))

    init() {
        println("Configuring networkManager singleton.")
        networkManager = configureManager()
    }
    
    func configureManager() -> Alamofire.Manager {
        let serializer = Alamofire.Request.stringResponseSerializer(encoding: NSUTF8StringEncoding)
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.HTTPCookieStorage = cookies
        return Alamofire.Manager(configuration: cfg)
    }
    
    func getURLBase() -> String {
        // TODO - use HTTPS instead
        // TODO - use DNS name instead of IP Address
        //return "http://localhost:8080"
        return "http://192.168.0.8:8080"
    }
    
/* Ref: http://stackoverflow.com/questions/26537075/remembering-cookies-with-alamofire
    
    func setCookies() {
        networkManager.request(NSURLRequest(URL: NSURL(string: "http://httpbin.org/cookies/set?stack=overflow")!)).responseString {
            (_, _, response, _) in
            var resp = response // { "cookies": { "stack": "overflow" } }
            println(resp)
            
            println(self.cookies.cookiesForURL(NSURL(string: "http://httpbin.org/cookies")!))
            self.checkCookies()
        }
    }
    
    func checkCookies() {
        networkManager.request(NSURLRequest(URL: NSURL(string: "http://httpbin.org/cookies")!)).responseString {
            (_, _, response, _) in
            var resp = response // { "cookies": { "stack": "overflow" } }
            println("secookie= \(resp)")
        }
    } */
    
    
    class func logHttpResponse(request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) {
        println("request=\(request)")
        println("request.debugDescription=\(request.debugDescription)")
        println("response=\(response)")
        if let res = response {
            println("response code=\(response!.statusCode)")
        }
        println("error=\(error)")
        if let err = error {
            println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
            println("Failed to call my server. response=\(response)")
            println("Failed to call my server. Error description=\(err.description)")
            println("Failed to call my server. Error userInfo=\(err.userInfo)")
        } else if data != nil {
            // _TtSq means optional
            // _TtSS means String
            // See http://www.eswick.com/2014/06/inside-swift/ to decipher the mysterous Swift type names
            println("Succeeded to call my server. Data Class=\(_stdlib_getTypeName(data!)) class=\(NSStringFromClass(data!.dynamicType)).")
            println("Succeeded to call my server. Data=\(data)")
        }
    }
}