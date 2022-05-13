//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
      

import Foundation
import UIKit
import BackgroundTasks

// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.upwork.notificationfetch"]

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.upwork.notificationfetch", using: .main) { [weak self] (task) in
            guard let self = self else { return }
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        configureUserNotifications()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
    
    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }
}

extension AppDelegate {
    
    /// Handles background refresh
    /// - Parameter task: task for the background operation
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        let apiCaller = BackgroundAPICaller()
        let notificationScheduler = LocalNotificationScheduler()
        
        apiCaller.fetchNotification { result in
            switch result {
            case .success(let list):
                notificationScheduler.scheduleNotifications(lists: list)
                apiCaller.postNotificationData(list: list)
            case .failure:
                break
            }
        }
        
        scheduleBackgroundRateFetch()
    }
    
    /// Schedule background tasks
    func scheduleBackgroundRateFetch() {
        let rateFetchTask = BGAppRefreshTaskRequest(identifier: "com.upwork.notificationfetch")
        rateFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(Global.taskInterval))
        
        do {
            try BGTaskScheduler.shared.submit(rateFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}


