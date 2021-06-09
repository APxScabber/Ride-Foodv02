//
//  ConfirmInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

class ConfirmInteracor {
    
    //Отправляем код подтверждения и получаем данные пользователя
    func passConfirmationCode(phoneNumber: String, code: String) {
        
        let url =  URL(string: "https://skillbox.cc/api/auth/confirm")
        
        let formatedPhoneNumber = phoneNumber.applyPatternOnNumbers(pattern: LoginText.phoneFormatEasy.rawValue,
                                                                    replacmentCharacter: "#")
        
        let passData = ["phone" : formatedPhoneNumber, "code" : code]
        
        LoadManager.shared.loadData(of: ConfirmDataModel.self, from: url!, httpMethod: .post,
                                    passData: passData) { result in
            
            switch result {
            case .success(let model):
                let confirmModel = model.data
                let userId = confirmModel.id
                print("USER ID: \(userId)")
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
        
        
    }
}
