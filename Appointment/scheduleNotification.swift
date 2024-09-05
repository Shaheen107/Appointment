import UserNotifications
import SwiftUI

func scheduleNotification(for appointment: Appointment) {
    let content = UNMutableNotificationContent()
    content.title = appointment.title
    
    // Create a DateFormatter to format the date for the notification body
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    let formattedDate = dateFormatter.string(from: appointment.date)
    
    content.body = "Reminder for your appointment at \(formattedDate)"
    content.sound = .default
    
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: appointment.date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    let request = UNNotificationRequest(
        identifier: appointment.id.uuidString,
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
}
