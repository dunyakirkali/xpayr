//
//  AppDelegate.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager
import UserNotifications
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Configure Firebase
        FirebaseApp.configure()
        
        // Navigation bar
        // TODO: (dunyakirkali) Refactor to extension
        UINavigationBar.appearance().prefersLargeTitles = true

        // IQKeyboard
        // TODO: (dunyakirkali) Refactor to extension
        IQKeyboardManager.shared().isEnabled = true

        // Local Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("Granted? \(granted)")
        }

        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Trash", options: [.destructive])
        let category = UNNotificationCategory(identifier: "ItemCategory", actions: [deleteAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        // Theme
        Chameleon.setGlobalThemeUsingPrimaryColor(.flatBlue, with: .contrast)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        application.statusBarStyle = .lightContent

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print(response)
        if response.actionIdentifier == "DeleteAction" {
            print("OK")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShouldRefresh"), object: self)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShouldRefresh"), object: self)
    }
}

