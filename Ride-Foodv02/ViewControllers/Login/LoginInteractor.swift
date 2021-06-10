//
//  LoginInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class LoginInteractor {
    
    //Получаем с сервера код подтверждения
    func reciveConfirmCode(from phoneNumber: String) {
        
        let formatedPhoneNumber = phoneNumber.applyPatternOnNumbers(pattern: LoginText.phoneFormatEasy.rawValue,
                                                                    replacmentCharacter: "#")
        
        let url =  URL(string: registrationURL)

        let passData = ["phone" : formatedPhoneNumber]
        
        LoadManager.shared.loadData(of: RegistrationResponsesModel.self, from: url!,
                                    httpMethod: .post, passData: passData) { result in

            switch result {

            case .success(let model):

                let confirmModel = model.data
                let confirmCode = String(confirmModel.code)
                LocalNotofications.shared.sendLocalNotifications(body: (confirmCode))

            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    //Метод для получения высоты клавиатуры
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        var keyboardHeight: CGFloat = 0.0
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        return keyboardHeight
    }
}

