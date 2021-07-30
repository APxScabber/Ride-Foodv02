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
    case cardNumber
    case topTitle
    case cashTV
    case bankCardTV
    case scoresTV
    case addCardTV
    
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
        case .cardNumber:
            return "Карта ****"
        case .topTitle:
            return "Способы оплаты"
        case .cashTV:
            return "Наличные"
        case .bankCardTV:
            return "Банковская карта"
        case .scoresTV:
            return "Баллы"
        case .addCardTV:
            return "Добавить карту"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .addButtonText:
            return "Link card"
        case .cardNumber:
            return "Card ****"
        case .topTitle:
            return "Payment ways"
        case .cashTV:
            return "Cash"
        case .bankCardTV:
            return "Bank card"
        case .scoresTV:
            return "Scores"
        case .addCardTV:
            return "Add card"
        }
    }
}
