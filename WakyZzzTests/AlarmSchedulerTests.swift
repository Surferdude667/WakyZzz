//
//  AlarmSchedulerTest.swift
//  WakyZzzTests
//
//  Created by Bjørn Lau Jørgensen on 06/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

// ATTENTION: In order for these tests to work you need to allow notifications on device first.
class AlarmSchedulerTests: XCTestCase {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let alarm = Alarm()
    var matchingID = ""
    var repeatedDayID = ""
    
    func testNotificationSetup() {
        let date = Date()
        let calender = Calendar.current
        var components = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = components.hour! + 1
        alarm.setTime(date: calender.date(from: components)!)
        alarm.repeatDays[0] = true
        
        let scheduler = AlarmScheduler(alarm: alarm)
        scheduler.setupNotification()
    
        // Checks if a notification is scheduled with the corosponnding alarm ID.
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
             for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == self.alarm.id {
                    self.matchingID = notificationRequest.identifier
                }
                
                if notificationRequest.identifier == "\(self.alarm.id)_weekday1" {
                    self.repeatedDayID = notificationRequest.identifier
                }
                
            }
            XCTAssert(self.matchingID == self.alarm.id)
            self.repeatedDayID = ""
            XCTAssert(self.repeatedDayID == "\(self.alarm.id)_weekday1")
            self.matchingID = ""
        }
    }
    
    
    func testNotificationRemoval() {
        AlarmScheduler.cancelNotification(with: matchingID)
        
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
             for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == self.alarm.id {
                    self.matchingID = notificationRequest.identifier
                }
                
                if notificationRequest.identifier == "\(self.alarm.id)_weekday1" {
                    self.repeatedDayID = notificationRequest.identifier
                }
            }
            XCTAssert(self.matchingID != self.alarm.id)
            XCTAssert(self.repeatedDayID != "\(self.alarm.id)_weekday1")
        }
        
    }

}
