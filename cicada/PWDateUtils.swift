//
//  PWDateUtils.swift
//  cicada
//
//  Created by Ping on 14/04/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import Foundation

// MARK: - Handy date extension.

// NOTE: NSCalendar.currentCalendar() is used, which might impact performance
// Tech memo:
// http://stackoverflow.com/questions/27182023/swift-getting-the-difference-between-two-nsdates-in-months-days-hours-minutes
extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

// Apple Site:
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
// Not timezone friendly. So, deprecated
extension NSCalendar {
    // Apple
    // returns days between two dates. If hour difference is less than 24 hours but across midnight boundary For Greenwich TimeZone, returns 1
     private func diffInDaysFromDate(start: NSDate, end: NSDate, timeZone: NSTimeZone?) -> Int {
        // approach in Apple Listing 13
        let calendar = PWDateUtils.CurrentCalendar
        if let tz = timeZone {
            calendar.timeZone = tz
        }
        
        let startDay = calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitEra, forDate: start)
        let endDay = calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitEra, forDate: end)
        
        return endDay - startDay
    }
}

extension NSDateFormatter {
    // The following API returns self, which allows chained function invoktion on NSDateFormatter
    func applyStyleFull() -> NSDateFormatter {
        self.dateStyle  = NSDateFormatterStyle.FullStyle
        self.timeStyle = NSDateFormatterStyle.FullStyle
        return self
    }
    
    func applyStyleFullNoTime() -> NSDateFormatter {
         self.dateStyle  = NSDateFormatterStyle.FullStyle
         self.timeStyle = NSDateFormatterStyle.NoStyle
        return self
    }
    
    func applyStyleMediumNoTime() -> NSDateFormatter {
        self.dateStyle  = NSDateFormatterStyle.MediumStyle
        self.timeStyle = NSDateFormatterStyle.NoStyle
        return self
    }
    
    func applyStyleShortNoTime() -> NSDateFormatter {
        self.dateStyle  = NSDateFormatterStyle.ShortStyle
        self.timeStyle = NSDateFormatterStyle.NoStyle
        return self
    }
    
    func applyStyle(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> NSDateFormatter {
        self.dateStyle  = dateStyle
        self.timeStyle = timeStyle
        return self
    }
}

// MARK: - PWDateUtils
// WARNING: This utility class is NOT thread-safe regarding timeZone. This is because the functions rely on cached singleton NSCalendar and NSDateFormatter instances.
//       If thread-safety is required, create new NSCalendar and NSDateFormatter instance with desired timeZone
class PWDateUtils {
    // User might change current calendar. Listens to current calendar change! // TODO
    private class var CurrentCalendar: NSCalendar {
        struct Singleton {
            static let instance = NSCalendar.currentCalendar()
        }
        
        return Singleton.instance
    }
    
    private class var dictionaryDateFormatter: NSMutableDictionary {
        struct Singleton {
            static let instance = NSMutableDictionary()
        }
        
        return Singleton.instance
    }
    
    // MARK: - Get DateFormatter
    class func getDateFormatterInTimeZoneName(timeZoneName: String) -> NSDateFormatter {
        let tz: NSTimeZone? = NSTimeZone(name: timeZoneName)
        return self.getDateFormatterInTimeZone(tz)
    }
    
    class func getDateFormatterInTimeZone(timeZone: NSTimeZone?) -> NSDateFormatter {
        var tz: NSTimeZone!
        if timeZone == nil {
            // if given timeZone is nil, GMT0 will be used
            tz = NSTimeZone(name: "GMT+0000")!
        } else {
            tz = timeZone
        }
        
        if let df: NSDateFormatter = self.dictionaryDateFormatter[tz] as? NSDateFormatter {
            return df
        } else {
            //  create and add new instance to singleton dictionary
            let df = NSDateFormatter()
            df.timeZone = tz

            // df.dateStyle  = NSDateFormatterStyle.FullStyle
            // df.timeStyle = NSDateFormatterStyle.FullStyle
            
            self.dictionaryDateFormatter[tz] = df
            return df
        }
    }
    
    // print out date with timeZone GMT+0000 and specied timeZone for debugging purpose
    class func printDateWithTimeZone(date: NSDate, timeZone: NSTimeZone) {
        var dateStr = PWDateUtils.toStringFull(date, timeZone: timeZone)
        println("date=\(date), dateStr = \(dateStr)")
    }

    // MARK: - Format a date to String with given timeZone
    // NOTE: df is thread-safe BUT the dateStyle and timeStyle are NOT thread-safe!!!
    // If the thread safety is required for date and time styles, please not use this df but create a new dateFormatter instance
    
    class func toStringFull(date: NSDate, timeZoneName: String) -> String {
        let timeZone = self.getTimeZoneOrGMT0(timeZoneName)
        return self.toStringFull(date, timeZone: timeZone)
        
    }
    
    class func toStringFull(date: NSDate, timeZone: NSTimeZone) -> String {
        return PWDateUtils.getDateFormatterInTimeZone(timeZone).applyStyleFull().stringFromDate(date)
    }
    
    class func toStringFullNoTime(date: NSDate, timeZoneName: String) -> String {
        let timeZone = self.getTimeZoneOrGMT0(timeZoneName)
        return self.toStringFullNoTime(date, timeZone: timeZone)

    }
    
    class func toStringFullNoTime(date: NSDate, timeZone: NSTimeZone) -> String {
        return PWDateUtils.getDateFormatterInTimeZone(timeZone).applyStyleFullNoTime().stringFromDate(date)
    }
    
    class func toStringMediumNoTime(date: NSDate, timeZoneName: String) -> String {
        let timeZone = self.getTimeZoneOrGMT0(timeZoneName)
        return self.toStringMediumNoTime(date, timeZone: timeZone)
    }
    
    class func toStringMediumNoTime(date: NSDate, timeZone: NSTimeZone) -> String {
        return PWDateUtils.getDateFormatterInTimeZone(timeZone).applyStyleMediumNoTime().stringFromDate(date)
    }
    
    // MARK: - Date difference calculation
    class func diffInDaysAcrossMidNight(start: NSDate, end: NSDate, timeZone: NSTimeZone) -> Int {
        // approach in Apple Listing 13
        let calendar = getCalendarForTimeZone(timeZone)
        
        let startDateAtMidNight: NSDate = getDateAtMidNight(start, timeZone: timeZone)
        let endDateAtMidNight: NSDate = getDateAtMidNight(end, timeZone: timeZone)
        
        //self.printDateWithTimeZone(startDateAtMidNight, timeZone: timeZone)
        //self.printDateWithTimeZone(endDateAtMidNight, timeZone: timeZone)
        
        return calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: startDateAtMidNight, toDate: endDateAtMidNight, options: nil).day
    }

    class func getDateAtMidNight(date: NSDate, timeZone: NSTimeZone) -> NSDate {
        let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
        let calendar = getCalendarForTimeZone(timeZone)
        
        let components: NSDateComponents = calendar.components(flags, fromDate: date)
        println("components=\(components)")
        
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    // Note: For performance, a cached calendar singleton instance is returned
    // So, the returned calendar is not thread-safe in terms of timeZone.
    // If a thread-safe calendar for a given timeZone is required, create a new NSCalendar instance with given timeZone
    class func getCalendarForTimeZone(timeZone: NSTimeZone?) -> NSCalendar {
        let calendar = PWDateUtils.CurrentCalendar
        if let tz = timeZone {
            calendar.timeZone = tz
        }
        
        return calendar
    }
    
    // Get a timeZone with given timeZone name or, if the name is invalid, the Greenwich GMT+0000 timeZone
    class func getTimeZoneOrGMT0(timeZoneName: String) -> NSTimeZone {
        var timeZone: NSTimeZone!

        if let tz = NSTimeZone(name: timeZoneName) {
            timeZone = tz
        } else {
            println("***** WARNING: Invalid timeZone=\(timeZoneName)")
            timeZone = NSTimeZone(name: "GMT+0000")
        }
    
        return timeZone
    }
    
    
    // Deprecated: The following method is more for demo of threadDictionary only.
    class func getDateFormatterThreadSafe() -> NSDateFormatter {
        let PWDateFormatterName = "dateFormatter"
        
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
}

// Tech memo:
// If you cache date formatters (or any other objects that depend on the user’s current locale), you should subscribe to the NSCurrentLocaleDidChangeNotification notification and update your cached objects when the current locale changes.
// http://www.alexcurylo.com/blog/2011/07/05/threadsafe-date-formatting/
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
// http://oleb.net/blog/2011/11/working-with-date-and-time-in-cocoa-part-2/
