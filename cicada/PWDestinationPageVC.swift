//
//  PWDestinationPageVC.swift
//  cicada
//
//  Created by Ping on 4/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import UIKit

class PWDestinationPageVC: UIViewController, PWCountryTableVCDelegate {

    @IBOutlet var destinationTextView: UITextView!
    
    @IBOutlet var countryButton: UIButton!
    
    var country: Country? = nil
    
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
        println("************ Destination text view clicked")
        //self.performSegueWithIdentifier("segueShowMap", sender: nil)
        
        
        let destinationTableVC = self.storyboard!.instantiateViewControllerWithIdentifier("destionationTableVC") as UIViewController

        // hook data
        // mapVC.businessEntity = selectedBusinessEntity
        
        // iOS7 comptible
        // self.navigationController?.pushViewController(destinationTableVC, animated: true)
        
        // iOS8 comptible
        self.showViewController(destinationTableVC as UIViewController, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showCountryTableSegue" {
            println("*** Will show country table ***")
            let vc = segue.destinationViewController as PWCountryTableVC
            vc.delegate = self
            
        } else {
            println("*** Unrecongnized segue name \(segue.identifier) in PWDestinationPageVC.prepareForSegue. Do nothing ***")
        }
    }
    
    // MARK: PWCountryTableVC selection delegate callback
    func didSelectCountry(controller: PWCountryTableVC, selectedCountry: Country) {
        self.country = selectedCountry
        countryButton.setTitle(country!.name, forState: UIControlState.Normal)
    }
}
