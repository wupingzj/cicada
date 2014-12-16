//
//  PWDestinationPageVC.swift
//  cicada
//
//  Created by Ping on 4/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class PWDestinationPageVC: UIViewController, PWCountryTableVCDelegate, PWDestinationTableVCDelegate {

    @IBOutlet var destinationTextView: UITextView!
    
    @IBOutlet var countryButton: UIButton!
    
    var country: Country? = nil
    var destination: PWDestination? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryButton.setTitle("Australia", forState: UIControlState.Normal)

        registerAction(destinationTextView, action:"showDestinationTableVC")
        
        //        destinationTextView.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func registerAction(view: UIView, action: String) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        
        println("registering action action=\(action)")
        
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
    
    private func isCountrySelected() -> Bool {
        // TODO - if country not selected, show alert message
//        abort()
        
        if (self.country == nil) {
            self.showAlertMsg(self, title: "Sorry", message: "Please choose country first")
            return false
        } else {
            return true
        }
    }
    
    func showAlertMsg(viewVC: UIViewController, title: String, message: String) {
        // TODO: UIAlertController requires iOS8
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,
            handler: { action in
        })
        alertController.addAction(okAction)
        viewVC.presentViewController(alertController, animated: true, completion: nil)
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
    
    // MARK: - selection callback
    func didSelectCountry(controller: PWCountryTableVC, selectedCountry: Country) {
        self.country = selectedCountry
        countryButton.setTitle(country!.name, forState: UIControlState.Normal)
    }
    
    func didSelectDestination(controller: PWDestinationTableVC, selectedDestination: PWDestination) {
        self.destination = selectedDestination
        
        // To show destination details
        if let selectedDestination = self.destination {
            var text: String = selectedDestination.city
            
            text = concatString(text, append: selectedDestination.state)
            text = concatString(text, append: selectedDestination.postCode)
            
            destinationTextView.text = text
        }
    }
    
    private func concatString(aString: String, append: String?) -> String {
        if append == nil {
            return aString
        } else {
            return aString + "\n" + append!
        }
    }
}
