//
//  handleNotifications.swift
//  simple notes
//
//  Created by Manuel Braun on 11.11.24.
//

import Foundation
import SwiftUI


func scheduleNotification(reminderDate: Date, reminderID: String, title: String, body: String){
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = truncatedText(body, limit: 20)
    content.sound = .default
    
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error)")
        }
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error {
            print(error.localizedDescription)
        }
    }
}

