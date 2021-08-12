//
//  PaymentHistoryText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import Foundation

//Вся текстовая информация используемая в Payment History
enum PaymentHistoryText {
    
    case navigationTitle
    case date
    case service
    case orderNumber
    case price
    case button
    case emptyList
    
    func text() -> String {
        
        switch UserDefaultsManager().getLanguage() {
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
        case .navigationTitle:
            return "История платежей"
        case .date:
            return "7 сентября, 09:20"
        case .service:
            return "/ Услуги такси"
        case .orderNumber:
            return "Платёж № "
        case .price:
            return " руб"
        case .button:
            return "Отправить на mail"
        case .emptyList:
            return "Здесь пока пусто..."
        }
    }
    
    private func engText() -> String {
        switch self {
        case .navigationTitle:
            return "Payment history"
        case .date:
            return "september 7, 09:20"
        case .service:
            return "/ Taxi service"
        case .orderNumber:
            return "Payment № "
        case .price:
            return " rub"
        case .button:
            return "Send to mail"
        case .emptyList:
            return "It's empty here for now ..."
        }
    }
}
