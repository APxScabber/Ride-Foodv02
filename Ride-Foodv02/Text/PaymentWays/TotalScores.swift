//
//  TotalScores.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.07.2021.
//

import Foundation

//Вся текстовая информация используемая в Total Scores
enum TotalScoresViewText {

    case infoTitle
    case newOrder
    case moreDetails
    
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
        case .infoTitle:
            return "У вас @#^ бонусных баллов"
        case .newOrder:
            return " Новый заказ"
        case .moreDetails:
            return "Подробнее"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .infoTitle:
            return "You have @#^ bonus credits"
        case .newOrder:
            return "New order"
        case .moreDetails:
            return "More details"
        }
    }
}
