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
        }
    }
    
    private func engText() -> String {
        switch self {
        case .navigationTitle:
            return "Payment history"
        }
    }
}
