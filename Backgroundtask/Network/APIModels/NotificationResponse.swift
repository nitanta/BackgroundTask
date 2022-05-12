//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import Foundation

struct NotificationResponse: Codable {
    let notificationId: String
    let notification: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case notificationId = "NotificationID"
        case notification = "Notification"
        case date = "NotificationDate"
    }
}

extension NotificationResponse {
    var scheduleDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
    
    var getComponents: DateComponents {
        var component = DateComponents()
        let calendar = Calendar.current
        component.calendar = calendar
        
        let hour = calendar.component(.hour, from: scheduleDate)
        let minute = Calendar.current.component(.minute, from: scheduleDate)
        let weekday = Calendar.current.component(.weekday, from: scheduleDate)
        
        component.hour = hour
        component.minute = minute
        component.weekday = weekday
        
        return component
    }
}
