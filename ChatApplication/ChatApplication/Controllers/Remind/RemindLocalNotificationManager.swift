//
//  RemindLocalNotificationManager.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 6/11/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import UserNotifications

struct MyNotification {
    var id:String
    var title:String
    var datetime:DateComponents
}

class RemindLocalNotificationManager: NSObject {
    static let shared = RemindLocalNotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    static let remindNotificationKey = "remindNotificationBN"
    
    override init() {
        super.init()
        self.notificationCenter.delegate = self
        // TODO: for test
//        self.notificationCenter.removeAllDeliveredNotifications()
//        self.notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func listScheduledNotifications() {
        notificationCenter.getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted != true || error != nil {
                UIAlertController.showAlertToSettings(title: "Bạn cần bật thông báo để có thể sử dụng tính năng này")
            }
        }
    }
    
    func schedule(for remind: RemindModel) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self.requestAuthorization()
            case .authorized, .provisional:
                DispatchQueue.main.async { self.scheduleNotifications(remind: remind) }
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications(remind: RemindModel) {
        guard let remindText = remind.text else { return }
        guard let remindTimeID = remind.timeId else { return }
        guard let remindDate = remind.date?.toDate(format: Constants.dateTimeFormatTime),
            let minute = remindDate.minute,
            let hour = remindDate.hour else { return }
        if remind.weekDays.isEmpty {
            addRemindNotification(message: remindText, hour: hour, minute: minute, id: remindTimeID)
        } else {
            for weekDay in remind.weekDays {
                addRemindNotification(message: remindText, hour: hour, minute: minute, id: remindTimeID, weekday: weekDay.weekDay)
            }
        }
    }
    
    func addRemindNotification(message: String, hour: Int, minute: Int, id: String, weekday: Int? = nil) {
        var day: Int?
        if let d = weekday {
            day = RemindModel.toWeekday17(weekday: d)
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour, minute: minute, weekday: day), repeats: weekday != nil)
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "YTBN"
        let indentifier = id + "_" + "\(weekday ?? -1)" + "_" + RemindLocalNotificationManager.remindNotificationKey
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            guard error == nil else { return }
            print("Notification scheduled!")
        }
    }
    
    func getPendingNotiRequest() {
        notificationCenter.getPendingNotificationRequests(completionHandler: { (requests) in
            for request in requests {
                print("noti request Id: ", request)
            }
        })
    }
    
    func removeNotification(remind: RemindModel, weekday: Int? = nil) {
        guard let remindTimeID = remind.timeId else { return }

        if let weekday = weekday {
            let id = remindTimeID + "_" + "\(weekday)" + "_" + RemindLocalNotificationManager.remindNotificationKey
            notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        } else {
            var ids: [String] = []
            if remind.weekDays.isEmpty {
                ids = remind.weekDays.map { remindTimeID + "_" + "\($0.weekDay)" + "_" + RemindLocalNotificationManager.remindNotificationKey }
            } else {
                ids = [remindTimeID + "_" + "\(-1)" + "_" + RemindLocalNotificationManager.remindNotificationKey]
            }
            notificationCenter.removeDeliveredNotifications(withIdentifiers: ids)
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    
    func notification(title: String, body: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        if let body = body {
            content.body = body
        }
        content.sound = .default
        let request = UNNotificationRequest(identifier: "identify\(Date().millis)", content: content, trigger: nil)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
                return
            }
            print("scheduled")
        }
    }
}

extension RemindLocalNotificationManager: UNUserNotificationCenterDelegate {
    
    // Calls when a notification will be display when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
        if id.hasSuffix(RemindLocalNotificationManager.remindNotificationKey) {
                presentReminderVC(notification: notification)
//                completionHandler([.alert, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    // Calls when a notification will be clicked when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        if id.contains(RemindLocalNotificationManager.remindNotificationKey) {
            presentReminderVC(notification: response.notification)
            return
        }
//        completionHandler()
    }
    
    func presentReminderVC(notification: UNNotification) {
        let vc = RemindingVC()
        vc.remindContent = notification.request.content.body
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        VCService.present(controller: vc)
    }
}

