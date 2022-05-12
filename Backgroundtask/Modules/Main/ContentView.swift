//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @EnvironmentObject var sceneDelegate: SceneDelegate
    
    let service = BackgroundAPICaller()
    let scheduler = LocalNotificationScheduler()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                service.fetchNotification(completion: { result in
                    switch result {
                    case .success(let list):
                        scheduler.scheduleNotifications(lists: list)
                    default: break
                    }
                })
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
