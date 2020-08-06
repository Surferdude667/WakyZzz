//
//  AlarmSchedulerTest.swift
//  WakyZzzTests
//
//  Created by Bjørn Lau Jørgensen on 06/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class AlarmSchedulerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
