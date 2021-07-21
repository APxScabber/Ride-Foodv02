//
//  UserDefaultsManagerText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import Foundation

//Перечень ключей используемых в UserDefaults
enum UserDefaultKeys: String {
    case userSettings = "userSettings"
    case language = "language"
}

//Перечень значений используемых в UserDefaults
enum UserDefaultLanguage: String {
    case rus = "rus"
    case eng = "eng"
}

enum NewCardsDataKey: String {
    case newCard = "newCard"
}
