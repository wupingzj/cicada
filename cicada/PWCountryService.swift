//
//  PWCountryService.swift
//  cicada
//
//  Created by Ping on 5/01/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import Alamofire

let countryServiceInstance = PWCountryService()
typealias CountryTuple = (name: String, active: Bool, useState: Bool)
class PWCountryService {
    class var sharedInstance: PWCountryService {
        return countryServiceInstance
    }
    
    
    
    func downloadAllCountries(callBack: (countriesJSON: AnyObject?, error: NSError?) -> Void) {
        
//        let networkService = PWNetworkService.sharedInstance
//        networkService.setCookies()
        
        callBack(countriesJSON: nil, error: nil)
        
//        manager.request(.GET, "http://localhost:8080/login", parameters: ["username": "admin", "password": "password"])
//            .validate(statusCode: 200..<300)
//            .response(serializer: serializer){ (request, response, string, error) in
//                
//                if let err = error {
//                    println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
//                    println("Failed to call my server. response=\(response)")
//                    println("Failed to call my server. Error description=\(err.description)")
//                    println("Failed to call my server. Error userInfo=\(err.userInfo)")
//                } else {
//                    println("Successfully logged in.")
//                    
//                    // TODO: build URL
//                    manager.request(.GET, "http://localhost:8080/country/list", parameters: nil)
//                        .validate(statusCode: 200..<300)
//                        .validate(contentType: ["application/json"])
//                        .responseJSON { (request, response, data, error) in
//                            
//                            //self.logHttpResponse(request, response: response, data: data, error: error)
//                            
//                            // ALWAYS call callBack so that caller can handle normal and abnormal scenarios
//                            // Caller must check whether there is any error
//                            callBack(countriesJSON: data, error: error)
//                    }
//                }
//                //                XCTAssertNotNil(request, "request should not be nil")
//                //                XCTAssertNotNil(response, "response should not be nil")
//                //                XCTAssertNotNil(string, "string should not be nil")
//                //                XCTAssertNil(error, "error should be nil")
//        }
//        //self.login("admin", password: "password")
        
        
        
//        // TODO: build URL
//        manager.request(.GET, "http://localhost:8080/country/list", parameters: nil)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: ["application/json"])
//            .responseJSON { (request, response, data, error) in
//
//                //self.logHttpResponse(request, response: response, data: data, error: error)
//                
//                // ALWAYS call callBack so that caller can handle normal and abnormal scenarios
//                // Caller must check whether there is any error
//                callBack(countriesJSON: data, error: error)
//        }
    }
    
    
    // For debugging only
    private func logHttpResponse(request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) {
        println("request=\(request)")
        println("response=\(response)")
        println("response code=\(response?.statusCode)")
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
    
    func parseAndPersistCountries(json: JSON) -> Bool {
        let count: Int? = json.array?.count
        var parseJsonOK = true
        var countryTuples: [CountryTuple] = []
        if let ct = count {
            println("found \(ct) countries")

            for index in 0...ct-1 {
                let jsonItem = json[index]
                println("The json[\(index)]=\(jsonItem)")

                let name = jsonItem["name"].string
                let active = jsonItem["active"].bool
                let useState = jsonItem["useState"].bool

                if (name != nil && active != nil && useState != nil) {
                    let countryTuple = (name: name!, active: active!, useState: useState!)
                    countryTuples.append(countryTuple)
                } else {
                    parseJsonOK = false
                }
            }
        } else {
            // invalid country list json data
            return false
        }
        
        if parseJsonOK {
            updateOrCreateCountry(countryTuples)
            
            var error: NSError? = DataService.sharedInstance.saveContext()
            if let err = error {
                println("**** Failed to save data context. \(err.userInfo)")
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }

    func updateOrCreateCountry(countryTuples: [CountryTuple]) {
        let (entities, error) = DataDao.listEntities(Country.getName())
        if error == nil {
            let countries = entities as [Country]
            for countryTuple in countryTuples {
                if let country = findCountry(countryTuple.name, countries: countries) {
                    // overwrite existing country values
                    country.name = countryTuple.name
                    country.active = countryTuple.active
                    country.useState = countryTuple.useState
                } else {
                    // Not exist. Create a new country
                    Country.createCountry(name: countryTuple.name, active: countryTuple.active, useState: countryTuple.useState)
                }
            }
        }
    }
    
    func findCountry(name: String, countries: [Country]) -> Country? {
        // This works only for a small set of data. Feel free to improve for better performance
        for country in countries {
            if country.name == name {
                return country
            }
        }
        
        return nil
    }
}