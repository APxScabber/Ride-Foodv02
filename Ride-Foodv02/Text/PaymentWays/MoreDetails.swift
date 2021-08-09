//
//  MoreDetails.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import Foundation

//Вся текстовая информация используемая в More Details
enum MoreDetailsViewText {

    case topTitle
    case infoText
    case buttonText
    
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
        case .topTitle:
            return "Пользуйтесь сервисом – копите баллы!"
        case .infoText:
            return "Программа лояльности для пользователей сервисами приложения «Ride & Drive». Программа предназначена для накопления баллов пользователем при оплате любым способом. 1 балл приравнивается к 1 рублю. При использовании сервиса «Такси» баллы начисляются согласно ставке 10% от суммы заказа свыше 800 рублей единовременно. При использовании сервиса «Еда» баллы начисляются согласно ставке 5% от суммы заказа свыше 1000 рублей единовременно. Использование баллов дает право пользователю на комбинированную оплату заказа. При оплате баллами заказа сервиса «Такси» минимальная сумма заказа – 200 рублей, максимальная оплата баллами – 50 баллов.  При оплате баллами заказа сервиса «Еда» минимальная сумма заказа – 300 рублей, максимальная оплата баллами – 50 баллов."
        case .buttonText:
            return "Начать копить баллы"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .topTitle:
            return "Use the service - collect credits!"
        case .infoText:
            return "Loyalty program for users of the services of the «Ride & Drive» application. The program is intended for the accumulation of credits by the user when paying in any way. 1 credit is equal to 1 ruble. When using the Taxi service, credits are awarded at a rate of 10% of the order amount over 800 rubles at a time. When using the «Food» service, credits are awarded at a rate of 5% of the order amount over 1000 rubles at a time. The use of credits entitles the user to a combined order payment. When paying with credits for ordering the Taxi service, the minimum order amount is 200 rubles, the maximum payment with credits is 50 credits. When paying with credits for ordering the «Food» service, the minimum order amount is 300 rubles, the maximum payment with credits is 50 credits."
        case .buttonText:
            return "Start collecting credits"
        }
    }
}
