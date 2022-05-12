//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

struct ContentView: View {
    init() {
        let service = BackgroundAPICaller()
        let scheduler = LocalNotificationScheduler()
        service.fetchNotification { result in
            switch result {
            case .success(let list):
                scheduler.scheduleNotifications(lists: list)
            default: break
            }
        }
    }
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
