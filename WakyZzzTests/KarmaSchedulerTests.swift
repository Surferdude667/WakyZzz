//
//  KarmaSchedulerTests.swift
//  WakyZzzTests
//
//  Created by Bjørn Lau Jørgensen on 11/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class KarmaSchedulerTests: XCTestCase {

    let notificationCenter = UNUserNotificationCenter.current()
    var matchingID = ""
    
    // Testing if notification is scheduled and if the message is passed along correctley.
    func testKarmaNotificationSetup() {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        
        let karmaScheduler = KarmaScheduler(date: calender.date(from: components)!, message: "test")
        karmaScheduler.setupNotification()
        
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
             for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == karmaScheduler.id {
                    self.matchingID = notificationRequest.identifier
                    XCTAssert(notificationRequest.content.body == "test")
                }
            }
            XCTAssert(self.matchingID == karmaScheduler.id)
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [karmaScheduler.id])
        }
        
        
    }

}
