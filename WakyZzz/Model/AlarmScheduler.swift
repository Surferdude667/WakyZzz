//
//  AlarmScheduler.swift
//  WakyZzz
//
//  Created by Bjørn Lau Jørgensen on 04/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit

class AlarmScheduler {
    
    let calendar = Calendar.current
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var trigger: UNCalendarNotificationTrigger?
    var id: String
    
    // TODO: This init is pretty much just a function. No need to do this...
    init(alarm: Alarm) {
        self.id = alarm.id
        
        self.content.title = "Alarm! \(alarm.caption)"
        self.content.body = "It's time to wake up! 🥳"
        self.content.sound = .defaultCritical
        self.content.userInfo = ["alarmID": alarm.id]
        
        if alarm.repeatDays.allSatisfy({$0 == false }) {
            let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: alarm.alarmDate!)
            self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            sceduleNotification(id: id, trigger: trigger!)
        } else {
            for day in 0..<alarm.repeatDays.count {
                if alarm.repeatDays[day] == true {
                    let repeatingID = "\(id)_weekday\(day + 1)"
                    
                    var components = calendar.dateComponents([.hour, .minute, .weekday], from: alarm.alarmDate! as Date)
                    components.weekday = day + 1
                    
                    self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    sceduleNotification(id: repeatingID, trigger: trigger!)
                }
            }
        }
    }
    
    fileprivate func sceduleNotification(id: String, trigger: UNCalendarNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        print("Adding alarm for: \(trigger.dateComponents) with notification id: \(id)")
        center.add(request) { (error) in
            if error != nil { print("Notification creation failed.") }
        }
    }
    
    // TODO: Remove user defaults?
    static func cancelNotification(with id: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
