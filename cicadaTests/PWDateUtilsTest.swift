//
//  PWDateUtilsTest.swift
//  cicada
//
//  Created by Ping on 14/04/2015.
//  Copyright (c) 2015 Yang Ltd. All rights reserved.
//

import UIKit
import XCTest

class PWDateUtilsTest: XCTestCase {
    let calendar = NSCalendar.currentCalendar()
    let tzSydney = NSTimeZone(name: "Australia/Sydney")!
    let tzGMT0 = NSTimeZone(name: "GMT+0000")!

    override func setUp() {
        super.setUp()

        calendar.timeZone = tzSydney
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDiffInDaysFromDate() {
        let date1 = calendar.dateWithEra(1, year: 2015, month: 4, day: 16, hour: 17, minute: 56, second: 0, nanosecond: 0)!
        let date2 = calendar.dateWithEra(1, year: 2015, month: 4, day: 17, hour: 3, minute: 56, second: 0, nanosecond: 0)!
        
        testDiffInDaysFromDate(date1, date2: date2, expectedDayAcrossMidnight: 1)
    }
    
    func testDiffInDaysFromDateAcrossYear() {
        let date1 = calendar.dateWithEra(1, year: 2015, month: 12, day: 31, hour: 11, minute: 56, second: 0, nanosecond: 0)!
        let date2 = calendar.dateWithEra(1, year: 2016, month: 01, day: 01, hour: 3, minute: 56, second: 0, nanosecond: 0)!
        
        testDiffInDaysFromDate(date1, date2: date2, expectedDayAcrossMidnight: 1)
        
    }
    
    func testDiffInDays2Days() {
        let date1 = calendar.dateWithEra(1, year: 2015, month: 4, day: 15, hour: 17, minute: 56, second: 0, nanosecond: 0)!
        let date2 = calendar.dateWithEra(1, year: 2015, month: 4, day: 17, hour: 3, minute: 56, second: 0, nanosecond: 0)!
        
        testDiffInDaysFromDate(date1, date2: date2, expectedDayAcrossMidnight: 2)
    }
    
    private func testDiffInDaysFromDate(date1: NSDate, date2: NSDate, expectedDayAcrossMidnight: Int) {
        //        let date1 = NSDate()
        //        let timeInterval = NSTimeInterval(10 * 60  * 60) // arbitary hours
        //        let date2 = date1.dateByAddingTimeInterval(timeInterval)
        
        PWDateUtils.printDateWithTimeZone(date1, timeZone: tzSydney)
        PWDateUtils.printDateWithTimeZone(date2, timeZone: tzSydney)
        
        let daysDiff2: Int = PWDateUtils.diffInDaysAcrossMidNight(date1, end: date2, timeZone: tzSydney)
        println("****** daysDiff2: diffInDaysFromDate = \(daysDiff2)")
        XCTAssertEqual(daysDiff2, expectedDayAcrossMidnight, "Across midnight in target timeZone. Expected day difference to be 1.")
    }
}
