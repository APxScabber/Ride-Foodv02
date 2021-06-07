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
        
        LoadManager.shared.createData(phone: formatedPhoneNumber) { result in

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
}

