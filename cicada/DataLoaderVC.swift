//
//  DataLoaderVC.swift
//  cicada
//
//  Created by Ping on 10/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import Alamofire

class DataLoaderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: *** Experiment networking ***
    @IBAction func getDataFromServer(sender: AnyObject) {
        Alamofire.request(.GET, "http://www.google.com", parameters: nil)
            .response { (request, response, data, error) in
                println("request=\(request)")
                println("response=\(response)")
                println("error=\(error)")
        }
        
        // parse JSON
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON {(request, response, JSON, error) in
                println("JSON=\(JSON)")
        }
        
        println("Finished request. This line is hit before the callback methods as the request is asynchronized.")
        // also note that the callback of httpbin is hit BEFORE that of Google. That might be becase httpbin.org replies faster than google to respond.
    }
    

    @IBAction func logonToCicada(sender: UIButton) {
        logon()
    }
    
    @IBAction func getData(sender: UIButton) {
        let url: String = PWNetworkService.sharedInstance.getURLBase() + "/country/list"
        callCicadaServer(url)
    }
    
    @IBAction func getData2(sender: AnyObject) {
        let url: String = PWNetworkService.sharedInstance.getURLBase() + "/country/list"
        callCicadaServer(url)
    }
    
    private func logon() {
        // TODO - remove it
        PWUserService.sharedInstance.logon(userName: "admin", password: "password", callBack: {response, data, error in
            println("loggin finished. data=\(data)")
            if let err = error {
                println("Failed to call my server. Error code=\(err.code), domain=\(err.domain)")
                println("Failed to call my server. response=\(response)")
                println("Failed to call my server. Error description=\(err.description)")
                println("Failed to call my server. Error userInfo=\(err.userInfo)")
            } else if data != nil {
                // TODO
                // To check returned data to be {OK} or {DENIED}. 
                // You cannot rely on HTTP STATUS CODE as it might be just a 200 response with a login page!
                
                
                
                // _TtSq means optional
                // _TtSS means String
                // See http://www.eswick.com/2014/06/inside-swift/ to decipher the mysterous Swift type names
                println("Succeeded to call my server. Data Class=\(_stdlib_getTypeName(data!)) class=\(NSStringFromClass(data!.dynamicType)).")
                println("AppDelegate:Succeeded to call my server. Data=\(data!)")
                
                //self.callCicadaServer()
            }
        })

    }
    
    private func callCicadaServer(url: String) {
        Alamofire.request(.GET, url, parameters: nil)
            .validate()
            //.validate(contentType: ["application/json"])
            .responseJSON { (request, response, json, error) in
                println("response code=\(response!.statusCode)")
                // normal code 200 doesn't gurantee the request passes authentication,
                // which is because server might deny the access and return a login form
                // Therefore, it's essential to parse and check the returned data
                
                println("error=\(error)")
                if error != nil {
                    PWNetworkService.logHttpResponse(request, response: response, data: json, error: error)
                    println("Failed to call my server. response=\(response)")
                } else if json != nil {
                    println("Succeeded to call my server. Data=\(json)")
                }
        }
    }
    
    private func experimentAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON {(request, response, JSON, error) in
                // expect success
                println("JSON=\(JSON)")
                println("error=\(error)")
        }
        
        Alamofire.request(.GET, "http://httpbin.org/html")
            .responseJSON {(request, response, JSON, error) in
                // expect error because response is HTML rather than JSON
                println("JSON=\(JSON)")
                println("error=\(error)")
        }
        
        Alamofire.request(.GET, "http://httpbin.org/html")
            .responseString {(request, response, string, error) in
                // expect success
                println("string=\(string)")
                println("error=\(error)")
        }
    }
    
    
    // MARK: ******* destination data *******
    @IBAction func createDestination(sender: AnyObject) {
        print("creating destination...")
        
        let dataloader = PWDestinationLoader()
        dataloader.createDestinations()
    }
    
    @IBAction func deleteDestination(sender: AnyObject) {
        print("deleting destination...")
        
        let dataloader = PWDestinationLoader()
        
        print("******** To Be Implemented *******")
    }
    
    @IBAction func listDestination(sender: AnyObject) {
        print("listing destination...")
        let dataloader = PWDestinationLoader()
        let destinations = dataloader.getDestinationList()
        dataloader.display(destinations)
    }
    
    // MARK: ********* country data *********
    @IBAction func loadCountryData(sender: AnyObject) {
        let dataloader = PWCountryLoader()
        dataloader.createCountries();
    }

    @IBAction func deleteCounties(sender: AnyObject) {
        let dataloader = PWCountryLoader()
        dataloader.deleteAllCountries();
    }
    
    @IBAction func listCountries(sender: AnyObject) {
        let dataloader = PWCountryLoader()
        let countries = dataloader.getCountryList();
        dataloader.display(countries)
    }


    // MARK: ******* request data *******
    @IBAction func createRequest(sender: AnyObject) {
        let dataloader = PWRequestLoader()
        let requests = dataloader.createRequests();
    }
    
    @IBAction func deleteRequest(sender: AnyObject) {
        let dataloader = PWRequestLoader()
        dataloader.deleteAllRequests();
    }
    
    @IBAction func listRequest(sender: AnyObject) {
        let dataloader = PWRequestLoader()
        let requests = dataloader.getRequestList();
        dataloader.display(requests)
    }
    
    // MARK: ******* quote data *******
    @IBAction func createQuote(sender: AnyObject) {
        let dataloader = PWQuoteLoader()
        dataloader.createQuotes()
    }
    
    @IBAction func deleteQuote(sender: AnyObject) {
        let dataloader = PWQuoteLoader()
        dataloader.deleteAllQuotes()
    }
    
    @IBAction func listQuote(sender: AnyObject) {
        let dataloader = PWQuoteLoader()
        let quotes = dataloader.getQuotetList()
        dataloader.display(quotes)
    }
}
