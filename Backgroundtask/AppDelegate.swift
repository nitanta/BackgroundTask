//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
      

import Foundation
import UIKit
import BackgroundTasks

// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.upwork.notificationfetch"]

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    let service = BackgroundAPICaller()
    let scheduler = LocalNotificationScheduler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.upstem.notificationfetch", using: .main) { [weak self] (task) in
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
            task.setTaskCompleted(success: true)
        }
        
        self.service.fetchNotification { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.scheduler.scheduleNotifications(lists: list)
                self.service.postNotificationData(list: list) {
                    task.setTaskCompleted(success: true)
                }
            case .failure:
                break
            }
        }
        
        scheduleBackgroundRateFetch()
    }
    
    /// Schedule background tasks
    func scheduleBackgroundRateFetch() {
        let rateFetchTask = BGAppRefreshTaskRequest(identifier: "com.upstem.notificationfetch")
        rateFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(Global.taskInterval))
        
        do {
            try BGTaskScheduler.shared.submit(rateFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}


