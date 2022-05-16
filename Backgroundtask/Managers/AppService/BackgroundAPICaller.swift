//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import Foundation
import Combine

final class BackgroundAPICaller {
    let service: NotificationServiceProtocol
    private var bag = Set<AnyCancellable>()

    init() {
        service = NotificationService()
    }
    
    func fetchNotification(completion: @escaping (Result<[NotificationResponse], Error>) -> Void) {
        self.service.fetchNotification().sink { (error) in
            switch error {
            case .failure(let error):
                completion(.failure(APIProviderErrors.customError(error.localizedDescription)))
            case .finished:
                break
            }
        } receiveValue: { (response) in
            completion(.success(response))
        }.store(in: &bag)
    }
    
    func sendNotification(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.service.sendNotificationId(id: id, completion: completion)
    }
}

extension BackgroundAPICaller {
    func postNotificationData(list: [NotificationResponse],  completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        list.forEach { item in
            group.enter()
            self.sendNotification(id: item.notificationId) { result in
                print("Post notification success")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Notification posting complete")
            completion()
        }
    }
}
