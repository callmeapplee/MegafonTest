//
//  NotificationService.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 27/01/25.
//

import UserNotifications
import UIKit

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleCheckInReminder(for date: Date, withMessage message: String? = nil) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hotel Stay"
        content.body = message ?? "Your check-in date is tomorrow. Don't forget to get ready for your trip!"
        content.sound = .default
        content.categoryIdentifier = "hotelStayReminder"
        
        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? Date()
        
        let timeInterval = triggerDate.timeIntervalSinceNow
        
        let trigger: UNTimeIntervalNotificationTrigger
        
        if timeInterval > 0 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: "checkInReminderImmediate", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error notification: \(error)")
            }
        }
    }

    
    func configureNotificationSettings() {
        let checkInCategory = UNNotificationCategory(identifier: "hotelStayReminder", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([checkInCategory])
    }
}
