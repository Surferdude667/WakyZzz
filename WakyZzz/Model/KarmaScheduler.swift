//
//  KarmaScheduler.swift
//  WakyZzz
//
//  Created by Bjørn Lau Jørgensen on 07/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit

class KarmaScheduler {
    
    let date: Date
    let calendar = Calendar.current
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var trigger: UNCalendarNotificationTrigger?
    let id = UUID().uuidString
    
    init(date: Date, message: String) {
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: date)
        
        // This is just for testing
        // Should be .hour +2 in the real app.
        components.minute = components.minute! + 3
    
        self.date = calendar.date(from: components)!
        self.content.title = "It's time for karma!"
        self.content.body = message
        self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    func setupNotification() {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil { print("Karma notification creation failed.") }
        }
    }
    
}
