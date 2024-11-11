//
//  handleNotifications.swift
//  simple notes
//
//  Created by Manuel Braun on 11.11.24.
//

import Foundation
import SwiftUI


///  Schedule a local notificationn with this parameters:
/// - Parameters:
///   - reminderDate: date and time for the notification
///   - reminderID: id which is also stored in swift data
///   - title: note.title
///   - body: note.note_text
func scheduleNotification(reminderDate: Date, reminderID: String, title: String, body: String){
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = truncatedText(body, limit: 20)
    content.sound = .default
    
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(identifier: reminderID, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error)")
        }
    }
}

/// Request the Permission to add notifications
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error {
            print(error.localizedDescription)
        }
    }
}

/// Remove the pending local notification with id
/// - Parameter id: notification id (identifier)
func removeNotification(id: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
}


