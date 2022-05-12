//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   
import Foundation

/// HTTP methods
public enum HTTPMethod: String {
    case get
    case post
    case delete
    case update
    case put
}

/// Encoding type
public enum ParameterEncoding {
    case json
    case url
    case urlformencoded
    case none
}

protocol EndpointProtocol {
    var baseURL: String { get }
    var absoluteURL: String { get }
    var params: [String: Any] { get }
    var arrayParams: [Any] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}


enum AppEndpoint: EndpointProtocol {
    case fetchNotifications(email: String)
    case sendNotificationData(notificationId: String)

    var baseURL: String {
        return Global.baseUrl
    }
    
    var absoluteURL: String {
        switch self {
        case .fetchNotifications:
            return baseURL + "api/APPNotification"
        case .sendNotificationData:
            return baseURL + "api/APPNotification"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .fetchNotifications(let email):
            return [
               "emailaddress" : email
            ]
        case .sendNotificationData(let notificationId):
            return [
               "notificationid" : notificationId
            ]
        default:
            return [:]
        }
    }
    
    var arrayParams: [Any] {
        return []
    }
    
    var headers: [String: String] {
        return [
            "apikey" : Global.apiKey
        ]
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotifications:
            return .get
        case .sendNotificationData:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchNotifications, .sendNotificationData:
            return .url
        }
    }
}
