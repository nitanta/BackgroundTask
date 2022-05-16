//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   
import Combine
import Foundation

protocol NotificationServiceProtocol {
    func fetchNotification() -> AnyPublisher<[NotificationResponse], Error>
    func sendNotificationId(id: String, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func sendNotificationId(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let request = apiProvider.performRequest(for: .sendNotificationData(notificationId: id)) else {
            return completion(.failure(APIProviderErrors.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(APIProviderErrors.customError("Invalid status code")))
            }
            
            return completion(.success(()))
            
        }
        
        task.resume()
    }
    
}
