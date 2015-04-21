//
//  PWDestinationPageVC.swift
//  cicada
//
//  Created by Ping on 4/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class PWDestinationPageVC: UIViewController, PWCountryTableVCDelegate, PWDestinationTableVCDelegate, PWDatePickerVCDelegate {
    // outlet
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var destinationImageView: UIImageView!
    @IBOutlet var destinationTextView: UITextView!
    @IBOutlet var arrivalDateButton: UIButton!
    @IBOutlet var departureDateButton: UIButton!
    @IBOutlet var currentArrivalDateLabel: UILabel!
    @IBOutlet var currentDepartureDateLabel: UILabel!
    
    // state
    var country: Country? = nil
    var destination: PWDestination? = nil
    var currentArrivalDate: NSDate? = nil
    var currentDepartureDate: NSDate? = nil
    
    // service
    var geocoder = CLGeocoder()

    // info
    let reminderSelectDestination = "Where to go?"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerAction(destinationTextView, action:"showDestinationTableVC")
        // destinationTextView.sizeToFit()

        if country == nil {
            loadCountryFromPreferenceOrCurrentLocation()
        }
        
        if destination == nil {
            destinationTextView.text = reminderSelectDestination
        }
        
        loadDestinationImageFromLocalFile()
        displayDestinationImage()
        
        destinationTextView.textColor = PWHighlightColor
        timeZoneDidChange()
    }
    
    private func getImageUrl() -> String? {
        if let checkedCountry = country {
            return checkedCountry.imageUrl
        } else {
            return nil
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
    private func loadCountryFromPreferenceOrCurrentLocation() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countryString = defaults.stringForKey(PWPreference_Country_Key) {
            updateCountryWith(countryString)
        } else {
            searchCurrentLocation()
        }
    }
    
    private func searchCurrentLocation() {
        // search and set user's current location: Country and Destination
        var manager: OneShotLocationManager? = OneShotLocationManager()
        manager!.fetchWithCompletion { (location, error) in
            // get user current location
            if let loc = location {
                self.getCountryByLocation(loc) { (placemark: CLPlacemark?, ok: Bool) in
                    if !ok || placemark == nil {
                        self.updateCountryWith(PWDefault_Country_Value)
                    } else {
                        // get user current location's readable placemark
                        self.logPlacemark(placemark!)
                        
                        // find corresponding country entity by country name
                        self.updateCountryWith(placemark!.country)
                        self.updateDestinationWith(placemark!)
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
    
    private func updateCountryWith(countryName: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(countryName, forKey: PWPreference_Country_Key)

        let country: Country? = DataDao.findCountryBy(countryName)
        
        if let foundCountry = country {
            // update Country Button with found country entity
            self.country = foundCountry
            self.countryButton.setTitle(foundCountry.name, forState: UIControlState.Normal)
        }
    }
    
    private func updateDestinationWith(placemark: CLPlacemark) {
        // TODO set current location as destination
        // Should or Should NOT set current location as destination?
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
    private func getCountryByLocation(location: CLLocation, placemarkHandler: (placemark: CLPlacemark?, ok: Bool) -> Void ) {
        geocoder.reverseGeocodeLocation(location) {
            (placemarks: [AnyObject]!, error: NSError!) in
            
            if let err = error {
                println("Cannot get country code from GeocodeLocation. Reason: error occured.")
                placemarkHandler(placemark: nil, ok: false)
                return
            }
            
            if placemarks != nil && placemarks.count > 0 {
                let top: CLPlacemark = placemarks[0] as CLPlacemark
                placemarkHandler(placemark: top, ok: true)
            } else {
                println("Cannot get country code from GeocodeLocation. Reason: placemarks arrya is nil or empty.")
                placemarkHandler(placemark: nil, ok: false)
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
    
    // MARK: - set country image / destination image
    private func displayDestinationImage() {
        if let imageUrl = getImageUrl() {
            // load destination image at imageUrl from server
            loadDestinationImage(imageUrl) { (ok: Bool) in
                if !ok {
                    // Failed loading from server, load destination image from local file
                    self.loadDestinationImageFromLocalFile()
                }
            }
        }
    }
    
    private func loadDestinationImage(imageUrl: String, completionHandler:(ok: Bool) -> Void) {
        // TODO
        // if wi-fi, load multiple images
        // if mobile-data, load only two images

        // ref: http://stackoverflow.com/questions/24231680/swift-loading-image-from-url
        //      http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
        //      http://www.raywenderlich.com/87595/intermediate-alamofire-tutorial
        //      for synchronous and asynchronous image loading
        let fullImageUrl: String = PWNetworkService.sharedInstance.getURLBase() + imageUrl
        
        // approach 1: synchrnously fetch image
        /* if let url = NSURL(string: fullImageUrl) {
            if let imageData = NSData(contentsOfURL: url) {
                self.destinationImageView.image = UIImage(data: imageData)
            } else {
                println("Failed to load data with URL \(url)")
            }
        } else {
            println("Invalid urlStr: \(fullImageUrl)")
        } */
        
        // approach 2: asynchronously fetch image
        Alamofire.request(.GET, fullImageUrl)
            .validate()
            .response() { (request, response, data, error) in
                var ok = false
                
                if error == nil && data != nil {
                    if let image = UIImage(data: data! as NSData) {
                        // self.destinationImageView.image = image
                        
                        // TODO - animate multiple images
                        var images: [UIImage] = []
                        images.append(image)
                        images.append(image)
                        images.append(image)
                        self.destinationImageView.animationImages = images
                        self.destinationImageView.animationDuration = 5
                        self.destinationImageView.startAnimating()
                        
                        //                    self.imageView.frame = self.centerFrameFromImage(image)
                        //                    self.spinner.stopAnimating()
                        //                    self.centerScrollViewContents()
                        
                        ok = true
                    }
                } else {
                    println("Failed to retrieve image at URL: \(fullImageUrl)")
                }
                
                if !ok {
                    println("Download destination image failed. Use default image instead.")
                    // TODO - load default local country image
                    completionHandler(ok: false)
                }
            }
    }
    
    private func loadDestinationImageFromLocalFile() {
        if let c = self.country {
            //TODO
            let imageFileName = "NewZealand.3.jpg"
            if let image = UIImage(named: imageFileName) {
                println("Load image from local file \(imageFileName)")
                self.destinationImageView.image = image
            } else {
                // could not load the image
                println("Failed to load image from file \(imageFileName)")
            }
        }
    }

    // MARK: - Navigation - Segue
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    let COUNTRY_TABLE_SEGUE = "showCountryTableSegue"
    let ARRIVAL_DATE_PICKER_SEGUE = "showArrivalDatePickerSegue"
    let DEPARTURE_DATE_PICKER_SEGUE = "showDepartureDatePickerSegue"
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == ARRIVAL_DATE_PICKER_SEGUE || identifier == DEPARTURE_DATE_PICKER_SEGUE {
            if (self.destination == nil) {
                PWViewControllerUtils.showAlertMsg(self, title: "Sorry", message: "Please choose destination first")
                return false
            }
        }

        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier ==  COUNTRY_TABLE_SEGUE {
            // show country table
            let vc = segue.destinationViewController as PWCountryTableVC
            vc.delegate = self
        } else if segue.identifier == ARRIVAL_DATE_PICKER_SEGUE || segue.identifier == DEPARTURE_DATE_PICKER_SEGUE {
            // show date picker
            let vc = segue.destinationViewController as PWDatePickerVC
            vc.delegate = self
            // TODO
            vc.destinationTimeZone = NSTimeZone(name: self.destination!.timeZoneName)!
//            vc.destinationTimeZone = NSTimeZone(name: "GMT")
            
            if segue.identifier == ARRIVAL_DATE_PICKER_SEGUE {
                vc.datePickerType = DatePickerType.ARRIVAL
            } else if segue.identifier == DEPARTURE_DATE_PICKER_SEGUE {
                vc.datePickerType = DatePickerType.DEPARTURE
            }
            
            // if no dates have been selected before, use current date as intial vales for date picker
            if let arrivalDate = self.currentArrivalDate {
                vc.currentArrivalDate = arrivalDate
            } else {
                vc.currentArrivalDate = NSDate()
            }

            if let departureDate = self.currentDepartureDate {
                vc.currentDepartureDate = departureDate
            } else {
                vc.currentDepartureDate = NSDate()
            }
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
            self.destinationTextView.textColor = PWHighlightColor
            self.destination = nil
            
            timeZoneDidChange()
        }
        
        self.country = selectedCountry
        countryButton.setTitle(country!.name, forState: UIControlState.Normal)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(selectedCountry.name, forKey: PWPreference_Country_Key)
        
        displayDestinationImage()
    }
    
    func didSelectDestination(controller: PWDestinationTableVC, selectedDestination: PWDestination) {
        if selectedDestination == self.destination {
            // Destination is not chnaged. It's the same. Do nothing.
            return
        }
        
        var timeZoneChanged: Bool!
        if self.destination == nil {
            timeZoneChanged = true
        } else {
            timeZoneChanged = (self.destination!.timeZoneName != selectedDestination.timeZoneName)
        }
        // println("***timeZoneChanged=\(timeZoneChanged) selectedDestination.timeZone=\(selectedDestination.timeZoneName)")
        
        self.destination = selectedDestination
        displayDestinationText(selectedDestination)
        
        if timeZoneChanged == true {
            timeZoneDidChange()
        }
        
        // When destination is changed, always show date picker buttons
        changeDateComponentsVisibility(hidden: false)
        
        displayDestinationImage()
    }
    
    // PWDatePickerVCDelegate call back
    func didSelectDate(selectedDate: NSDate, datePickerType: DatePickerType) {
        println("Date picker date=\(selectedDate), datePickerType=\(datePickerType)")
        var dateLabel: UILabel!
        if datePickerType == DatePickerType.ARRIVAL {
            self.currentArrivalDate = selectedDate
            self.arrivalDateButton.tintColor = self.view.tintColor
            dateLabel = self.currentArrivalDateLabel
        } else if datePickerType == DatePickerType.DEPARTURE {
            self.currentDepartureDate = selectedDate
            self.departureDateButton.tintColor = self.view.tintColor
            dateLabel = self.currentDepartureDateLabel
        } else {
            println("Not supported datePickerType=\(datePickerType)")
        }
        
        let tzName = self.destination!.timeZoneName
        dateLabel.text = PWDateUtils.toStringMediumNoTime(selectedDate, timeZoneName: tzName)
        
        dateLabel.numberOfLines = 0
        dateLabel.sizeToFit()
    }
    
    private func displayDestinationText(destination: PWDestination) {
        // To show destination details
        var text: String = ""
        if (destination.town != nil) {
            text = PWStringUtils.concatString(destination.town!, append: destination.city, newLine: false)
        } else {
            text = destination.city
        }
        
        text = PWStringUtils.concatString(text, append: destination.state, newLine: true)
        
        destinationTextView.text = text
        destinationTextView.textColor = self.view.tintColor
    }
    
    // a listener to timeZone change, which fires the event to reset selected dates
    private func timeZoneDidChange() {
        // clear selected dates
        self.currentArrivalDate = nil
        self.currentDepartureDate = nil
        self.currentArrivalDateLabel.text = "-"
        self.currentDepartureDateLabel.text = "-"
        
        // highlight date pciker buttons
        self.arrivalDateButton.tintColor = PWHighlightColor
        self.departureDateButton.tintColor = PWHighlightColor
        
        changeDateComponentsVisibility(hidden: true)
    }
    
    private func changeDateComponentsVisibility(#hidden: Bool) {
        self.arrivalDateButton.hidden = hidden
        self.departureDateButton.hidden = hidden
        self.currentArrivalDateLabel.hidden = hidden
        self.currentDepartureDateLabel.hidden = hidden
    }
}


    

