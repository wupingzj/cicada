//
//  PWStringUtils.swift
//  cicada
//
//  Created by Ping on 19/12/2014.
//  Copyright (c) 2014 Yang Ltd. All rights reserved.
//

import Foundation

let PWDateFormatterName = "dateFormatter"

class PWStringUtils {
    class func concatString(aString: String, append: String?, newLine: Bool) -> String {
        if append == nil {
            return aString
        } else if newLine {
            return aString + "\n" + append!
        } else {
            return aString + ", " + append!
        }
    }
    
    // TODO - Follow the sample below to cache expensive date formatter
    // If you cache date formatters (or any other objects that depend on the user’s current locale), you should subscribe to the NSCurrentLocaleDidChangeNotification notification and update your cached objects when the current locale changes.
    // http://www.alexcurylo.com/blog/2011/07/05/threadsafe-date-formatting/

    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
    
    // http://oleb.net/blog/2011/11/working-with-date-and-time-in-cocoa-part-2/
    class func formatDate(date: NSDate) -> String {
//        var dateFormatter = NSDateFormatter()
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        dateFormatter.locale = NSLocale.currentLocale()

        let dateFormatter = getDateFormatterThreadSafe()

        var strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    class func getDateFormatterThreadSafe() -> NSDateFormatter {
        let dictionary = NSThread.currentThread().threadDictionary
        var dateFormatter: NSDateFormatter? = dictionary[PWDateFormatterName] as? NSDateFormatter
        if dateFormatter == nil {
            let df = NSDateFormatter()
            
            df.dateStyle = NSDateFormatterStyle.MediumStyle
            df.timeStyle = NSDateFormatterStyle.NoStyle
            
            dictionary[PWDateFormatterName] = df
            return df
        } else {
            return dateFormatter!
        }
    }
    
    class func formatDate(date: NSDate, timeZone: NSTimeZone) -> String {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle

        dateFormatter.timeZone = timeZone
        
        var strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
}