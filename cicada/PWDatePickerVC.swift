//
//  PWDatePickerVC.swift
//  cicada
//
//  Created by Ping on 8/03/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol PWDatePickerVCDelegate {
    func didSelectDate(selectedDate: NSDate, datePickerType: DatePickerType)
}

public enum DatePickerType: String {
    case ARRIVAL = "Arrival"
    case DEPARTURE = "Departure"
}

extension NSDate
{
    // TODO - high priority - use format cache to improve performance
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}

class PWDatePickerVC: UIViewController {
    @IBOutlet var pickedDateLabel: UILabel!
    @IBOutlet var destinationTimeZoneLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    // view controller input parameters
    var delegate: PWDatePickerVCDelegate? = nil
    var datePickerType: DatePickerType!
    // The following two input parameters are used to initialize the datePicker
    var currentArrivalDate: NSDate!
    var currentDepartureDate: NSDate!
    var destinationTimeZone: NSTimeZone!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.timeZone = destinationTimeZone
        datePicker.addTarget(self, action: Selector("datePickerChanged"), forControlEvents: UIControlEvents.ValueChanged)
  
        var today = NSDate()
        datePicker.minimumDate = today
        
        var date: NSDate!
        if datePickerType == DatePickerType.ARRIVAL {
            date = self.currentArrivalDate
        } else if datePickerType == DatePickerType.DEPARTURE {
            date = self.currentDepartureDate
        }
        datePicker.setDate(date, animated: true)
        destinationTimeZoneLabel.text = (destinationTimeZone.abbreviation!) + ",   " + (destinationTimeZone.name)
        
        // reflect date in label
        datePickerChanged()
    }
    
    func datePickerChanged() {
        if datePickerType == DatePickerType.ARRIVAL {
            self.title = "Arrival"
        } else {
            self.title = "Departure"
        }
        
        let dateStr = PWDateUtils.toStringFullNoTime(datePicker.date, timeZone: destinationTimeZone)
        pickedDateLabel.text = dateStr
        
        pickedDateLabel.numberOfLines = 0
        pickedDateLabel.sizeToFit()
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        let selectedDate = datePicker.date
        
        // callback the delegate
        if delegate != nil {
            delegate!.didSelectDate(selectedDate, datePickerType: datePickerType)
        }
        
        // programmatically click the Back button
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
