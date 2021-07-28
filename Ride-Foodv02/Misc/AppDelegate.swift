//
//  AppDelegate.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit
import UserNotifications
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let loginInteractor = LoginInteractor()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Проверяем, зарегистрирован пользователь или нет
        if loginInteractor.loginCheck() {
            let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainScreenViewController
            self.window?.rootViewController = vc
        }
        
        //настраиваем LocalNotification
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}


