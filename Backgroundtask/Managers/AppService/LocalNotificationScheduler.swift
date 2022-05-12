//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import Foundation
import UserNotifications

final class LocalNotificationScheduler {
    let notificationCenter: UNUserNotificationCenter
    
    init() {
        notificationCenter = UNUserNotificationCenter.current()
        requestPermission()
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotifications(lists: [NotificationResponse]) {
        removePandingNotifications()
        lists.filter { $0.scheduleDate > Date() }.forEach { item in
            
            let content = UNMutableNotificationContent()
            content.title = Global.appName
            content.subtitle = item.notification
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents(
                    [.day, .month, .year, .hour, .minute],
                    from: item.scheduleDate),
                repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: item.notificationId, content: content, trigger: trigger)

            // add our notification request
            notificationCenter.add(request)
        }
        
    }
    
    func removePandingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
}
