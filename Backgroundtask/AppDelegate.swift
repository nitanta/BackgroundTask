//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
      

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.upwork.backgroundtask.notificationfetch", using: .main) { [weak self] (task) in
            guard let self = self else { return }
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        configureUserNotifications()
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = AppDelegate.self
        return sceneConfig
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
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
            case .failure:
                break
            }
        }
        
        scheduleBackgroundRateFetch()
    }
    
    /// Schedule background tasks
    func scheduleBackgroundRateFetch() {
        let rateFetchTask = BGAppRefreshTaskRequest(identifier: "com.upwork.backgroundtask.notificationfetch")
        rateFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(Global.taskInterval))
        
        do {
          try BGTaskScheduler.shared.submit(rateFetchTask)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}


