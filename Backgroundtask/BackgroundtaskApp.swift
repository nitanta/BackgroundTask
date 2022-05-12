//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

@main
struct BackgroundtaskApp: App {
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newValue in
            switch newValue {
            case .background:
                appDelegate.scheduleBackgroundRateFetch()
                print("Background task registered")
            @unknown default:
                break
            }
        }
    }
}
