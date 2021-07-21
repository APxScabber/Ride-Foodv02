//
//  ConfirmText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

//Вся текстовая информация используемая в ConfirmViewController
enum ConfirmText {
    
    case label
    case info
    case button
    case alerButton
    case alertTitle
    case alertMessage
    
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
        case .label:
            return "Код подтверждения"
        case .info:
            return "На номер @#^ отправлено смс с кодом. Повторная отправка через @#^ секунд"
        case .alerButton:
            return "Хорошо"
        case .alertTitle:
            return "Ошибка"
        case .alertMessage:
            return "Введен неправильный код проверки\nБудет выслан новый код проверки"
        case .button:
            return "Далее"
        }
    }
    
    private func engText() -> String {
        switch self {
        case .label:
            return "Confirmation code"
        case .info:
            return "An SMS with a code was sent to the number @#^. Resend in @#^ seconds"
        case .alerButton:
            return "OK"
        case .alertTitle:
            return "Error"
        case .alertMessage:
            return "Incorrect verification code entered\nA new verification code will be sent"
        case .button:
            return "Next"
        }
    }
}
