//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //Schedule background fetch operation
        (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundRateFetch()
    }

}

