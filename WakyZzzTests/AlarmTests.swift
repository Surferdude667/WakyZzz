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
        }
    }
    
    func testIncrimenter() {
        let alarm = Alarm()
        let date = Date()
        let calender = Calendar.current
        
        var components = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = 10
        components.minute = 1
        alarm.setTime(date: calender.date(from: components)!)
        
        let originalTime = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        // Confirm original time is set
        XCTAssert(originalTime.hour == 10)
        XCTAssert(originalTime.minute == 1)
        
        // Confirming the time is incrimented
        alarm.incrimentAlarm()
        let newTime = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        XCTAssert(newTime.hour == 10)
        XCTAssert(newTime.minute == 2)
    }
    
    func testReturnToOrginalTime() {
        let alarm = Alarm()
        let date = Date()
        let calender = Calendar.current
        
        var components = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = 10
        components.minute = 1
        alarm.setTime(date: calender.date(from: components)!)
        
        let originalTime = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        // Confirm original time is set
        XCTAssert(originalTime.hour == 10)
        XCTAssert(originalTime.minute == 1)
        
        // Confirming the time is incrimented
        alarm.incrimentAlarm()
        let newHighTime = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        XCTAssert(newHighTime.hour == 10)
        XCTAssert(newHighTime.minute == 2)
        
        // Confirming time is doubble incrimented
        alarm.incrimentAlarm()
        let newEvilTime = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        XCTAssert(newEvilTime.hour == 10)
        XCTAssert(newEvilTime.minute == 3)
        alarm.level = .evil
        
        // Confirming the time is set back to original
        alarm.returnToOriginalTime()
        let backFromEvil = calender.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        XCTAssert(backFromEvil.hour == 10)
        XCTAssert(backFromEvil.minute == 1)
    }
}
