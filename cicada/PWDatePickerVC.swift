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
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var pickedDateLabel: UILabel!
    
    // view controller input parameters
    var delegate: PWDatePickerVCDelegate? = nil
    var datePickerType: DatePickerType!
    // The following two input parameters are used to initialize the datePicker
    var currentArrivalDate: NSDate?
    var currentDepartureDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerChanged"), forControlEvents: UIControlEvents.ValueChanged)
  
        var today = NSDate()
        datePicker.minimumDate = today
        var date = today
        if datePickerType == DatePickerType.ARRIVAL {
            if let currentDate = self.currentArrivalDate {
                date = currentDate
                datePicker.minimumDate = currentDate
            }
        } else if datePickerType == DatePickerType.DEPARTURE {
            if let currentDate = self.currentDepartureDate {
                date = currentDate
            }
            
            // departure date's minmum date
            if let currentArrivalDate = self.currentArrivalDate {
                datePicker.minimumDate = currentArrivalDate
            } else {
                datePicker.minimumDate = today
            }
        }
        
        println("datePicker.minimumDate=\(datePicker.minimumDate)")
        // TODO - maximum date
        
        datePicker.setDate(date, animated: true)

        // reflect date in label
        datePickerChanged()
    }
    
    func datePickerChanged() {
        if datePickerType == DatePickerType.ARRIVAL {
            pickedDateLabel.text = "Arrival Date: Show TimeZone, localized timeformat"
        } else {
            pickedDateLabel.text = "Departure Date: "
        }
        
        pickedDateLabel.text! += formatDate(datePicker.date)
        pickedDateLabel.numberOfLines = 0
        pickedDateLabel.sizeToFit()
    }
    
    private func formatDate(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        // TODO
        let selectedDate = datePicker.date
        
        // callback the delegate
        if delegate != nil {
            delegate!.didSelectDate(selectedDate, datePickerType: datePickerType)
        }
        
        // programmatically click the Back button
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
