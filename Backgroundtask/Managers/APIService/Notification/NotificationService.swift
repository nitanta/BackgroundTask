//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   
import Combine
import Foundation

protocol NotificationServiceProtocol {
    func fetchNotification() -> AnyPublisher<[NotificationResponse], Error>
    func sendMotificationData(id: String) -> AnyPublisher<SuccessResponse, Error>
}


class NotificationService: NotificationServiceProtocol {
    
    /// API provider
    private let apiProvider = APIProvider<AppEndpoint>()
        
    init() {}
    
    func fetchNotification() -> AnyPublisher<[NotificationResponse], Error> {
        return apiProvider.getData(
            from: .fetchNotifications(email: Global.email)
        )
        .decode(type: [NotificationResponse].self, decoder: Container.jsonDecoder)
        .receive(on: RunLoop.main)
        .mapError({ error -> Error in
            return error
        })
        .map{
            return $0
        }
        .eraseToAnyPublisher()
    }
    
    func sendMotificationData(id: String) -> AnyPublisher<SuccessResponse, Error> {
        return apiProvider.getData(
            from: .sendNotificationData(notificationId: id)
        )
        .decode(type: SuccessResponse.self, decoder: Container.jsonDecoder)
        .receive(on: RunLoop.main)
        .mapError({ error -> Error in
            return error
        })
        .map{
            return $0
        }
        .eraseToAnyPublisher()
    }
    
}
