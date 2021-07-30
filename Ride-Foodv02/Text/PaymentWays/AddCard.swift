//
//  AddCard.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 28.07.2021.
//

import Foundation

//Вся текстовая информация используемая в Add Card
enum AddCardViewText {

    case newCard
    case cardNumberTF
    case cardDateTF
    case cardCVVTF
    
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
        case .newCard:
            return "Новая карта"
        case .cardNumberTF:
            return "Номер карты"
        case .cardDateTF:
            return "Срок действия"
        case .cardCVVTF:
            return "CVV"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .newCard:
            return "New card"
        case .cardNumberTF:
            return "Card number"
        case .cardDateTF:
            return "Validity"
        case .cardCVVTF:
            return "CVV"
        }
    }
}
