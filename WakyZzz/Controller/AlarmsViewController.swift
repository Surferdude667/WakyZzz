//
//  AlarmsViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var alarms = [Alarm]()
    var editingIndexPath: IndexPath?
    let karma = ["Message a friend asking how they are doing.", "Connect with a family member by expressing a kind thought.", "Water your plants."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
    }
    
    func alarm(at indexPath: IndexPath) -> Alarm? {
        return indexPath.row < alarms.count ? alarms[indexPath.row] : nil
    }
    
    func deleteAlarm(at indexPath: IndexPath) {
        tableView.beginUpdates()
        AlarmScheduler.cancelNotification(with: alarms[indexPath.row].id)
        alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func editAlarm(at indexPath: IndexPath) {
        editingIndexPath = indexPath
        presentAlarmViewController(alarm: alarm(at: indexPath))
    }
    
    func addAlarm(_ alarm: Alarm, at indexPath: IndexPath) {
        tableView.beginUpdates()
        alarms.insert(alarm, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        scheduleAlarm(alarm: alarm)
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error { print("Error: ", error) }
        }
    }
    
    func scheduleAlarm(alarm: Alarm) {
        let alarmScheduler = AlarmScheduler(alarm: alarm)
        alarmScheduler.setupNotification()
    }
    
    func sortAlarms(alarms: [Alarm]) {
        let sorted = alarms.sorted(by: { $0.time < $1.time })
        self.alarms = sorted
        tableView.reloadData()
    }
    
    func presentSnoozeAlertController(from alarm: Alarm) {
        let alert = UIAlertController(title: "Alarm! \(alarm.caption)", message: "It's time to wake up! 🥳", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Snooze", style: .default, handler: { (_) in
            AlarmScheduler.cancelNotification(with: alarm.id)
            
            switch alarm.level {
            case .defaultAlarm:
                alarm.level = .high
            case .high:
                alarm.level = .evil
            case .evil:
                break
            }
            
            alarm.incrimentAlarm()
            let scheduler = AlarmScheduler(alarm: alarm)
            scheduler.setupNotification()
        }))
        
        alert.addAction(UIAlertAction(title: "Turn off", style: .cancel, handler: { (_) in
            alarm.returnToOriginalTime()
            alarm.level = .defaultAlarm
            // Stop alarm sound here....
            
            if alarm.repeatDays.allSatisfy({$0 == false }) {
                alarm.enabled = false
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: {
            // Start alarm sound here...
        })
    }
    
    func presentEvilAlertController(from alarm: Alarm) {
        let karmaMessage = karma.randomElement()
        let alert = UIAlertController(title: "Balance the karma after snoozing!", message: karmaMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Promish to do it now", style: .default, handler: { (_) in
            print("Promish to do it now")
            // Stop alarm sound
        }))
        
        alert.addAction(UIAlertAction(title: "Remind me later", style: .cancel, handler: { (_) in
            let karmaScheduler = KarmaScheduler(date: alarm.alarmDate!, message: karmaMessage!)
            karmaScheduler.setupNotification()
            // Stop alarm sound
        }))
        
        self.present(alert, animated: true, completion: {
            // Start alarm sound here...
            alarm.returnToOriginalTime()
            alarm.level = .defaultAlarm
            
            // Turn alarm off (Since Evil is the last point) Unless it's repeating,
            if alarm.repeatDays.allSatisfy({$0 == false }) {
                alarm.enabled = false
                self.tableView.reloadData()
            } else {
                AlarmScheduler.cancelNotification(with: alarm.id)
                let scheduler = AlarmScheduler(alarm: alarm)
                scheduler.setupNotification()
            }
        })
    }
    
    func presentAlarmViewController(alarm: Alarm?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        let alarmViewController = popupViewController.viewControllers[0] as! AlarmViewController
        alarmViewController.alarm = alarm
        alarmViewController.delegate = self
        present(popupViewController, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPress(_ sender: Any) {
        presentAlarmViewController(alarm: nil)
    }
    
}
// MARK:- UITableViewDelegate
extension AlarmsViewController: UITableViewDelegate { }

// MARK:- UITableViewDataSource
extension AlarmsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { alarms.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmTableViewCell
        cell.delegate = self
        
        if let alarm = alarm(at: indexPath) {
            cell.populate(caption: alarm.caption, subcaption: alarm.repeating, enabled: alarm.enabled, alarm: alarm)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteAlarm(at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editAlarm(at: indexPath)
        }
        
        return [delete, edit]
    }
}

// MARK:- AlarmCellDelegate
extension AlarmsViewController: AlarmCellDelegate {
    func alarmCell(_ cell: AlarmTableViewCell, enabledChanged enabled: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let alarm = self.alarm(at: indexPath) {
                alarm.enabled = enabled
                
                if enabled == false {
                    if let id = cell.alarm?.id {
                        AlarmScheduler.cancelNotification(with: id)
                    }
                } else {
                    if let alarm = cell.alarm {
                        let scheduler = AlarmScheduler(alarm: alarm)
                        scheduler.setupNotification()
                    }
                }
            }
        }
    }
}


// MARK:- AlarmViewControllerDelegate
extension AlarmsViewController: AlarmViewControllerDelegate {
    
    func alarmViewControllerDone(alarm: Alarm) {
        if let editingIndexPath = editingIndexPath {
            AlarmScheduler.cancelNotification(with: alarm.id)
            let scheduler = AlarmScheduler(alarm: alarm)
            scheduler.setupNotification()
            tableView.reloadRows(at: [editingIndexPath], with: .automatic)
        } else {
            addAlarm(alarm, at: IndexPath(row: alarms.count, section: 0))
        }
        editingIndexPath = nil
        sortAlarms(alarms: alarms)
    }
    
    func alarmViewControllerCancel() {
        editingIndexPath = nil
    }
    
}

// MARK:- UNUserNotificationCenterDelegate
extension AlarmsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let alarmID = userInfo["alarmID"] as? String {
            
            func cleanID(of: String, from: String) -> String {
                let cleanID = from.replacingOccurrences(of: "_\(of)", with: "")
                return cleanID
            }
            
            // DEFAULT ALARM
            if alarmID.contains(AlarmLevel.defaultAlarm.rawValue) {
                let id = cleanID(of: AlarmLevel.defaultAlarm.rawValue, from: alarmID)
                let alarm = alarms.first(where: {$0.id == id})
                if let alarm = alarm { presentSnoozeAlertController(from: alarm) }
            }
            
            // HIGH ALARM
            if alarmID.contains(AlarmLevel.high.rawValue) {
                let id = cleanID(of: AlarmLevel.high.rawValue, from: alarmID)
                let alarm = alarms.first(where: {$0.id == id})
                if let alarm = alarm { presentSnoozeAlertController(from: alarm) }
            }
            
            // EVIL ALARM
            if alarmID.contains(AlarmLevel.evil.rawValue) {
                let id = cleanID(of: AlarmLevel.evil.rawValue, from: alarmID)
                let alarm = alarms.first(where: {$0.id == id})
                if let alarm = alarm { presentEvilAlertController(from: alarm) }
            }
        }
        completionHandler()
    }
}
