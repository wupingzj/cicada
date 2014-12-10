//
//  DataLoaderVC.swift
//  cicada
//
//  Created by Ping on 10/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class DataLoaderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func listCountries(sender: AnyObject) {
        let dataloader = PWDataLoader()
        let countries = dataloader.getCountryList();
        dataloader.display(countries)
    }

    @IBAction func deleteCounties(sender: AnyObject) {
        let dataloader = PWDataLoader()
        dataloader.deleteAllCountries();
    }
    
    @IBAction func loadCountryData(sender: AnyObject) {
        let dataloader = PWDataLoader()
        dataloader.createCountries();
    }
}
