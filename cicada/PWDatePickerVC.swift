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
    func didSelectDate(selectedDate: NSDate)
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
    
    var delegate: PWDatePickerVCDelegate? = nil
    var datePickerType: DatePickerType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerType = DatePickerType.ARRIVAL
        datePickerChanged()
        
        datePicker.addTarget(self, action: Selector("datePickerChanged"), forControlEvents: UIControlEvents.ValueChanged)
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
        println("SELECTED DATE=\(selectedDate)")
        
        // callback the delegate
        if delegate != nil {
            delegate!.didSelectDate(selectedDate)
        }
        
        // programmatically click the Back button
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
