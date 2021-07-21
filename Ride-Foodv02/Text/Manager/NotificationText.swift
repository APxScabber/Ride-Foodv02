//
//  NotificationText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 12.06.2021.
//

import Foundation

//Вся текстовая информация используемая в Уведомленях
enum NotificationText {
    
    case title
    
    func text() -> String {
        
        let userSettings = UserDefaultsManager.shared.userSettings
        let languageCode = userSettings?.userLanguage
        
        switch languageCode {
        case "rus":
            return rusText()
        case "eng":
            return engText()
        default:
            return ""
        }
    }
    
    private func rusText() -> String {
        switch self {
        case .title:
            return "Код подтверждения"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .title:
            return "Confirmation code"
        }
    }
}
