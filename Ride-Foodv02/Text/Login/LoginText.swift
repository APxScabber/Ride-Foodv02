//
//  LoginText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

//Локализация приложения
enum Language: Equatable {
    case russian
    case english
}

//Код для установки нужного языка
extension Language {
    var code: String {
        switch self {
        case .russian: return "ru"
        case .english: return "en"
        }
    }
}

extension Language {
    
    //Устанока выбранного языка
    init?(_ languageCode: String?) {
        switch languageCode {
        case "ru":
            self = .russian
        case "en":
            self = .english
        default:
            return nil
        }
    }

    //Вся текстовая информация используемая в LoginViewController
    var phoneNumberLable: String {
        get {
            switch self {
            case .russian:
                return "Укажите номер телефона"
            case .english:
                return "Enter your phone number"
            }
        }
    }
    
    var licenseInfo: String {
        get {
            switch self {
            case .russian:
                return "Даю согласие на обработку персональных данных, с пользовательским соглашением ознакомлен"
            case .english:
                return "I agree to the processing of personal data, I have read the user agreement"
            }
        }
    }
    
    var buttonText: String {
        get {
            switch self {
            case .russian:
                return "Далее"
            case .english:
                return "Next"
            }
        }
    }
}

//Текс не нуждающийся в переводе
enum LoginText: String {
    case licenseLink = "https://www.google.com/"
    case phonePrefix = "+7"
    case phoneFormatFull = "+# (###) ###-##-##"
    case phoneFormatEasy = "###########"
}
