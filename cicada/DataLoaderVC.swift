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
    
    @IBAction func getDataFromServer(sender: AnyObject) {
        Alamofire.request(.GET, "http://www.google.com", parameters: nil)
            .response { (request, response, data, error) in
                println("request=\(request)")
                println("response=\(response)")
                println("error=\(error)")
        }
    }
    
    // ******** destination data *************
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
    
    // ********* country data *********
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
}
