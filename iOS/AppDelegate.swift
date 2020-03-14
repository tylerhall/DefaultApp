//
//  AppDelegate.swift
//  DefaultApp-iOS
//
//  Created by Tyler Hall on 3/14/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDefaults()

        Constants.getHostname()

        UIApplication.shared.registerForRemoteNotifications()
        
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

    // Populates UserDefaults with the initial default settings for your app.
    // Those values will come from the Defaults.plist in the app bundle.
    func registerDefaults() {
        var defaults: [String: Any] = [:]

        if let defaultsPath = Bundle.main.path(forResource: "Defaults", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: defaultsPath) as? [String: Any] {
                defaults.merge(dict: dict)
            }
        }

        // You can use this opportunity to insert any default values that need
        //  to be computed at runtime and thus can't be stored in Defaults.plist.
        let computedDefaults: [String: Any] = [:]
        defaults.merge(dict: computedDefaults)

        UserDefaults.standard.register(defaults: defaults)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}
