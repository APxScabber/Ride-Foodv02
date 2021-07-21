//
//  LoginText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

//Вся текстовая информация используемая в LoginViewController
enum LoginText {
    
    case phoneNumberLable
    case licenseInfo
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
        case .phoneNumberLable:
            return "Укажите номер телефона"
        case .licenseInfo:
            return "Даю согласие на обработку персональных данных, с пользовательским соглашением ознакомлен"
        case .buttonText:
            return "Далее"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .phoneNumberLable:
            return "Enter your phone number"
        case .licenseInfo:
            return "I agree to the processing of personal data, I have read the user agreement"
        case .buttonText:
            return "Next"
        }
    }
}
