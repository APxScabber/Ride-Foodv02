//
//  PaymentMain.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 04.07.2021.
//

import Foundation

//Вся текстовая информация используемая в PaymentMain
enum PaymentMainViewText {
    
    case addButtonText
    case confirmButtonText
    case cancelButtonText
    
    func text() -> String {
        
        switch UserDefaultsManager.shared.getLanguage() {
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
        case .addButtonText:
            return "Привязать карту"
        case .confirmButtonText:
            return "Подтвердить"
        case .cancelButtonText:
            return "Отмена"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .addButtonText:
            return "Link card"
        case .confirmButtonText:
            return "Confirm"
        case .cancelButtonText:
            return "Cancel"
        }
    }
}
