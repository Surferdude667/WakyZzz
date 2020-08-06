//
//  Alarm.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import Foundation 

class Alarm {

    static let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var time = 0
    let id = UUID().uuidString
    let incrimentInterval = 1
    var repeatDays = [false, false, false, false, false, false, false]
    var enabled = true
    var level: AlarmLevel = .defaultAlarm
    
    var alarmDate: Date? {
        let date = Date()
        let calendar = Calendar.current
        let h = time / 3600
        let m = time / 60 - h * 60
        
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        
        components.hour = h
        components.minute = m
        
        return calendar.date(from: components)
    }
    
    var caption: String {        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self.alarmDate!)
    }
    
    var repeating: String {
        var captions = [String]()
        for i in 0 ..< repeatDays.count {
            if repeatDays[i] {
                captions.append(Alarm.daysOfWeek[i])
            }
        }
        return captions.count > 0 ? captions.joined(separator: ", ") : "One time alarm"
    }
    
    func setTime(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        
        time = components.hour! * 3600 + components.minute! * 60        
    }
    
    func defaultTime() -> Date {
        let calender = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.hour = 08
        dateComponent.minute = 00
        
        return calender.date(from: dateComponent)!
    }
    
    func incrimentAlarm() {
        let calender = Calendar.current
        let originalComponents = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: alarmDate! as Date)
        var updatedComponents = originalComponents
        updatedComponents.minute = updatedComponents.minute! + incrimentInterval
        
        setTime(date: calender.date(from: updatedComponents)!)
    }
    
    func returnToOriginalTime() {
        let calender = Calendar.current
        let originalComponents = calender.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: alarmDate! as Date)
        var updatedComponents = originalComponents
        
        switch level {
        case .defaultAlarm:
            setTime(date: alarmDate!)
        case .high:
            updatedComponents.minute = updatedComponents.minute! - incrimentInterval
            setTime(date: calender.date(from: updatedComponents)!)
        case .evil:
            updatedComponents.minute = updatedComponents.minute! - (incrimentInterval * 2)
            setTime(date: calender.date(from: updatedComponents)!)
        }
    }
    
}
