//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
      

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.upwork.backgroundtask.Backgroundtask", using: .main) { [weak self] (task) in
            guard let self = self else { return }
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        return true
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
            case .failure:
                break
            }
        }
        
        scheduleBackgroundRateFetch()
    }
    
    /// Schedule background tasks
    func scheduleBackgroundRateFetch() {
        let rateFetchTask = BGAppRefreshTaskRequest(identifier: "com.upwork.backgroundtask.Backgroundtask")
        rateFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 20 * 60) //20 minutes background refresh
        
        do {
          try BGTaskScheduler.shared.submit(rateFetchTask)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}


