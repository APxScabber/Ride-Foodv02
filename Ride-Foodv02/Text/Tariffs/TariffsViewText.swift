//
//  TariffsViewText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation

//Вся текстовая информация используемая в ConfirmViewController
enum TariffsViewText {
    
    case standartLabel
    case premiumLabel
    case businessLabel
    case carLabel
    case emptyText
    case aboutTariffs
    case taxiOrderButton
    
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
        case .standartLabel:
            return "Стандарт"
        case .premiumLabel:
            return "Премиум"
        case .businessLabel:
            return "Бизнес"
        case .carLabel:
            return "Автомобили:"
        case .emptyText:
            return ""
        case .aboutTariffs:
            return "О тарифах"
        case .taxiOrderButton:
            return "Заказать такси"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .standartLabel:
            return "Standart"
        case .premiumLabel:
            return "Premium"
        case .businessLabel:
            return "Business"
        case .carLabel:
            return "Cars:"
        case .emptyText:
            return ""
        case .aboutTariffs:
            return "About"
        case .taxiOrderButton:
            return "Order a taxi"
        }
    }
}
