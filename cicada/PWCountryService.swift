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
    
    func downloadAllCountries(callBack: (countriesJSON: AnyObject?, error: NSError?, redirectToLogon: Bool) -> Void) {
        // TODO: build URL
        
        let url: String = PWNetworkService.sharedInstance.getURLBase() + "/country/list"
        
        let request =  Alamofire.request(.GET, url, parameters: nil)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    //PWNetworkService.logHttpResponse(request, response: response, data: json, error: error)
                    println("Failed to call my server. response=\(response)")
                } else if json != nil {
                    println("Succeeded to call my server. Data=\(json)")
                }

                // ALWAYS call callBack so that caller can handle normal and abnormal scenarios
                // Caller must check whether there is any error
                var redirectToLogon = PWUserService.isRedirectToLogon(response)
                callBack(countriesJSON: json, error: error, redirectToLogon: redirectToLogon)
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
        let (entities, error) = DataDao.listEntities(Country.getEntityName())
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