//
//  ConfirmText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation


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
    
    
    #warning("Как использовать параметры внутри текста?")
    var infoTextView: String {
        get {
            switch self {
            case .russian:
                return "На номер отправлено смс с кодом. Повторная отправка через секунд"
                //return "На номер \(phoneNumber) отправлено смс с кодом. Повторная отправка через \(seconds) секунд"
            case .english:
                return "An SMS with a code was sent to the number. Resend in seconds"
                //return "An SMS with a code was sent to the number \(phoneNumber). Resend in \(seconds) seconds"
            }
        }
        
    }
 
    
}
