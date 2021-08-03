//
//  AddScores.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 28.07.2021.
//

import Foundation

//Вся текстовая информация используемая в Add Scores
enum AddScoresViewText {

    case congratulations
    case youHave
    case scoresInfo
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
        case .congratulations:
            return "Поздравляем! 🎉"
        case .youHave:
            return "У вас @#^ бонусных баллов"
        case .scoresInfo:
            return "Количество баллов всегда можно посмотреть в данном разделе, либо при оплате заказа"
        case .newOrder:
            return "Новый заказ"
        case .moreDetails:
            return "Подробнее"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .congratulations:
            return "Congratulations! 🎉"
        case .youHave:
            return "You have @#^ bonus credits"
        case .scoresInfo:
            return "The number of credits can always be viewed in this section, or when paying for an order"
        case .newOrder:
            return "New order"
        case .moreDetails:
            return "More details"
        }
    }
}
