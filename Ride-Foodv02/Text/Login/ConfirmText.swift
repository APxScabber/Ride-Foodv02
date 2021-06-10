//
//  ConfirmText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

//Вся текстовая информация используемая в ConfirmViewController
extension Language {
    
    var textCodeConfirmLabel: String {
        get {
            switch self {
            case .russian:
                return "Код подтверждения"
            case .english:
                return "Confirmation code"
            }
        }
    }
    
    var infoTextView: String {
        get {
            switch self {
            case .russian:
                return "На номер @#^ отправлено смс с кодом. Повторная отправка через @#^ секунд"
              case .english:
                return "An SMS with a code was sent to the number @#^. Resend in @#^ seconds"
            }
        }
    }
    
    var alertButton: String {
        get{
            switch self {
            case .russian:
                return "Хорошо"
              case .english:
                return "OK"
            }
        }
    }
    
    var alertTitle: String {
        get{
            switch self {
            case .russian:
                return "Ошибка"
              case .english:
                return "Error"
            }
        }
    }
    
    var alertMessage: String {
        get{
            switch self {
            case .russian:
                return "Введен неправильный код проверки\nБудет выслан новый код проверки"
              case .english:
                return "Incorrect verification code entered\nA new verification code will be sent"
            }
        }
    }
 
    
}
