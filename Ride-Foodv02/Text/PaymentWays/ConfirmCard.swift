//
//  ConfirmCard.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 26.07.2021.
//

import Foundation

//Вся текстовая информация используемая в Confirm Card
enum ConfirmCardViewText {

    case confirm
    case confirmText
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
        case .confirm:
            return "Подтверждение"
        case .confirmText:
            return "Для подтверждения платёжеспособности с карты @#^ будет списан 1 руб. Сумма будет возвращена сразу после подтверждения из банка."
        case .confirmButtonText:
            return "Подтвердить"
        case .cancelButtonText:
            return "Отмена"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .confirm:
            return "Confirmation"
        case .confirmText:
            return "To confirm the solvency, 1 rub will be debited from the card @#^. The amount will be refunded immediately after confirmation from the bank."
        case .confirmButtonText:
            return "Confirm"
        case .cancelButtonText:
            return "Cancel"
        }
    }
}


