//
//  AppDelegate.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/12/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let defaults = UserDefaults.standard
        
//        if defaults.object(forKey: "isFirstLaunch") == nil {
//            defaults.set(true, forKey: "isFirstLaunch")
//            defaults.set("kmh", forKey: "unitOfSpeed")
//            defaults.set("cycling", forKey: "activityType")
//        }

        if defaults.object(forKey: "unitOfSpeed") == nil {
            defaults.set("kmh", forKey: "unitOfSpeed")
        }

        if defaults.object(forKey: "activityType") == nil {
            defaults.set("cycling", forKey: "activityType")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

