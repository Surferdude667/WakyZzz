//
//  AlarmTests.swift
//  WakyZzzTests
//
//  Created by Bjørn Lau Jørgensen on 29/07/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class AlarmTests: XCTestCase {
    
    func testAlarmDefaultTime() {
        let alarm = Alarm()
        let defaultTime = alarm.defaultTime()
        let calender = Calendar.current
        
        let h = calender.component(.hour, from: defaultTime)
        let m = calender.component(.minute, from: defaultTime)
        
        XCTAssert(h == 8)
        XCTAssert(m == 0)
    }
    
    
    func testRepeatingDays() {
        let alarm = Alarm()
        
        // Checks if repeating days are default false, default output is correct.
        XCTAssert(alarm.repeatDays == [false, false, false, false, false, false, false])
        XCTAssert(alarm.repeating == "One time alarm")
        
        // Checks if the output string is correct if all days are set to true.
        alarm.repeatDays = [true, true, true, true, true, true, true]
        XCTAssert(alarm.repeating == "Sun, Mon, Tue, Wed, Thu, Fri, Sat")
    }
    
    func testCaption() {
        let alarm = Alarm()
        let defaultTime = alarm.defaultTime()
        alarm.setTime(date: defaultTime)
        XCTAssert(alarm.caption == "8:00 AM")
    }
    
    func testAlarmUpdate() {
        let alarm = Alarm()
        let defaultTime = alarm.defaultTime()
        let calender = Calendar.current
        
        alarm.setTime(date: defaultTime)
    
        // Testing if default time is set
        if let date = alarm.alarmDate {
            let h = calender.component(.hour, from: date)
            let m = calender.component(.minute, from: date)
            
            XCTAssert(h == 8)
            XCTAssert(m == 0)
        } else {
            XCTFail()
        }
        
        // Testing if the alarm time changed.
        let newCalender = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 55
        let newDate = newCalender.date(from: dateComponent)
        
        if let newDate = newDate {
            alarm.setTime(date: newDate)
            
            let h = calender.component(.hour, from: alarm.alarmDate!)
            let m = calender.component(.minute, from: alarm.alarmDate!)
            
            XCTAssert(h == 10)
            XCTAssert(m == 55)
        } else {
            XCTFail()
        }
    }
    
    // TODO: This test makes no sense, test if delegate function works instead. Probabely in another file.
    func testAlarmOnOff() {
        let alarm = Alarm()
        
        // Testing if default is true
        XCTAssert(alarm.enabled == true)
        
        alarm.enabled = false
        XCTAssert(alarm.enabled == false)
    }
}
