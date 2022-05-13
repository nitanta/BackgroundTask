//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    
    let service = BackgroundAPICaller()
    let scheduler = LocalNotificationScheduler()
    
    var body: some View {
        Button("Simulate process") {
            simulateFlow()
        }
    }
    
    func simulateFlow() {
        service.fetchNotification(completion: { result in
            switch result {
            case .success(let list):
                scheduler.scheduleNotifications(lists: list)
                service.postNotificationData(list: list)
            default: break
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
