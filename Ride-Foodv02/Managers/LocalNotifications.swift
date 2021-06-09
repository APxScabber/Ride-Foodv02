//
//  LocalNotifications.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation
import UserNotifications

#warning("Что будет если пользователь отклонит уведомления?")
//Класс для работы с локальными уведомлениями
class LocalNotofications {
    
    static let shared = LocalNotofications()
    
    func sendLocalNotifications(body: String) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Код подтверждения"
        content.body = body
        content.sound = UNNotificationSound.default
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: triger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }
}
