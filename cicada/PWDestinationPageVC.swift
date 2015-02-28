//
//  PWDestinationPageVC.swift
//  cicada
//
//  Created by Ping on 4/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class PWDestinationPageVC: UIViewController, PWCountryTableVCDelegate, PWDestinationTableVCDelegate {
    // outlet
    @IBOutlet var destinationTextView: UITextView!
    @IBOutlet var countryButton: UIButton!
    
    // state
    var country: Country? = nil
    var countryCode : String? = nil
    var destination: PWDestination? = nil
    
    // service
    var geocoder = CLGeocoder()

    // info
    let reminderSelectDestination = "Please select destination"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerAction(destinationTextView, action:"showDestinationTableVC")
        //        destinationTextView.sizeToFit()

        if country == nil {
            setDefaultLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func registerAction(view: UIView, action: String) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - set default location
    private func setDefaultLocation() {
        // default to user's current location
        var manager: OneShotLocationManager? = OneShotLocationManager()
        manager!.fetchWithCompletion { (location, error) in
            // get user current location
            if let loc = location {
                self.getCountryByLocation(loc) { (placemark: CLPlacemark) in
                    // get user current location's readable placemark
                    self.logPlacemark(placemark)
                    
                    // find corresponding country entity by country name
                    let country = DataDao.findCountryBy(placemark.country)
                    if let foundCountry = country {
                        self.country = foundCountry
                        self.countryButton.setTitle(foundCountry.name, forState: UIControlState.Normal)
                        // TODO set current location as destination
                    }
                }
            } else if let err = error {
                // Failed to get country information. Do nothing
                println(err.localizedDescription)
            }
            
            // release memory
            manager = nil
        }
        
        
        destinationTextView.text = reminderSelectDestination
    }
    
    private func logPlacemark(placemark: CLPlacemark) {
        let addressStr: String = "Address = \(placemark.subThoroughfare), \(placemark.thoroughfare), \(placemark.locality), \(placemark.ISOcountryCode), \(placemark.country)"
        println("****** For given location, get placemark = \(addressStr) ***")
    }
    
    private func searchCountryBy(ISOCountryCode: String) -> Country? {
        // ref: http://en.wikipedia.org/wiki/ISO_3166-1
        // Remember: Apple Geocoder returns Alpha-2 country code rather than Alpha-3 country code
        
        return nil
    }
    
    // Get the countryInformation for given CLLocation. If succeed, call the placemarkHandler. Otherwise, silently do nothing
    private func getCountryByLocation(location: CLLocation, placemarkHandler: (placemark: CLPlacemark) -> Void ) {
        geocoder.reverseGeocodeLocation(location) {
            (placemarks: [AnyObject]!, error: NSError!) in
            
            if let err = error {
                println("Cannot get country code from GeocodeLocation. Reason: error occured.")
                return
            }
            
            if placemarks != nil && placemarks.count > 0 {
                let top: CLPlacemark = placemarks[0] as CLPlacemark
                placemarkHandler(placemark: top)
            } else {
                println("Cannot get country code from GeocodeLocation. Reason: placemarks arrya is nil or empty.")
            }
        }
    }
    
    private func isCountrySelected() -> Bool {
        if (self.country == nil) {
            PWViewControllerUtils.showAlertMsg(self, title: "Sorry", message: "Please choose country first")
            return false
        } else {
            return true
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showCountryTableSegue" {
            let vc = segue.destinationViewController as PWCountryTableVC
            vc.delegate = self
        } else {
            println("*** Unrecongnized segue name \(segue.identifier) in PWDestinationPageVC.prepareForSegue. Do nothing ***")
        }
    }
    
    func showDestinationTableVC() {
        if !isCountrySelected() {
            return
        }
        
        //self.performSegueWithIdentifier("segueShowMap", sender: nil)
        let destinationTableVC = self.storyboard!.instantiateViewControllerWithIdentifier("destionationTableVC") as PWDestinationTableVC
        
        destinationTableVC.country = self.country
        destinationTableVC.delegate = self
        
        // iOS7 comptible
        // self.navigationController?.pushViewController(destinationTableVC, animated: true)
        
        // iOS8 comptible
        self.showViewController(destinationTableVC as UIViewController, sender: self)
    }
    
    // MARK: - selection callback
    func didSelectCountry(controller: PWCountryTableVC, selectedCountry: Country) {
        // if country changes, reset the destination
        if self.country != selectedCountry {
            self.destinationTextView.text = reminderSelectDestination
            self.destination = nil
        }
        
        self.country = selectedCountry
        countryButton.setTitle(country!.name, forState: UIControlState.Normal)
    }
    
    func didSelectDestination(controller: PWDestinationTableVC, selectedDestination: PWDestination) {
        self.destination = selectedDestination
        displayDestination(selectedDestination)
    }
    
    private func displayDestination(destination: PWDestination) {
        // To show destination details
        var text: String = ""
        if (destination.town != nil) {
            text = PWStringUtils.concatString(destination.town!, append: destination.city, newLine: false)
        } else {
            text = destination.city
        }
        
        text = PWStringUtils.concatString(text, append: destination.state, newLine: true)
        text = PWStringUtils.concatString(text, append: destination.postCode, newLine: true)
        
        destinationTextView.text = text
    }
}
