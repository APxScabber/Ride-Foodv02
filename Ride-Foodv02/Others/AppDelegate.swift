//
//  AppDelegate.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            
            guard granted else { return }
            
            notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                
            }
        }
        return true
    }
}

