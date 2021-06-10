//
//  ManagerText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

//Вся текстовая информация используемая в LocalNotifications
extension Language {
    
    var titleText: String {
        get {
            switch self {
            case .russian:
                return "Код подтверждения"
            case .english:
                return "Confirmation code"
            }
        }
    }
}
