//
//  AlarmScheduler.swift
//  WakyZzz
//
//  Created by Bjørn Lau Jørgensen on 04/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit

class AlarmScheduler {
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    let trigger: UNCalendarNotificationTrigger
    let id: String
    
    init(alarm: Alarm) {
        self.id = alarm.id
        self.content.title = "Tile"
        self.content.body = "Body"
        self.content.sound = .defaultCritical
        self.content.userInfo = ["alarmID": alarm.id]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: alarm.alarmDate!)
        self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    
    func sceduleNotification() {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print("Notification creation failed.")
            }
        }
    }
    
    // TODO: Remove user defaults?
    func cancelNotification(with id: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
