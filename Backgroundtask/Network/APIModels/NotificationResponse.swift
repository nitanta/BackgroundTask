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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //return formatter.date(from: date) ?? Date()
        return formatter.date(from: "2022-05-12T16:10:59.827") ?? Date()
    }
}
