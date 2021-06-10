//
//  ConfirmInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation
import UIKit

class ConfirmInteracor {
    
    //Отправляем код подтверждения и получаем данные пользователя
    func passConfirmationCode(phoneNumber: String, code: String, compitition: @escaping (Error?) -> Void ) {

        let url =  URL(string: confirlURL)
        
        let formatedPhoneNumber = phoneNumber.applyPatternOnNumbers(pattern: LoginText.phoneFormatEasy.rawValue,
                                                                    replacmentCharacter: "#")
        
        let passData = ["phone" : formatedPhoneNumber, "code" : code]
        
        LoadManager.shared.loadData(of: ConfirmResponsesModel.self, from: url!, httpMethod: .post,
                                    passData: passData) { result in
            
            switch result {
            case .success(let model):
                let confirmModel = model.data
                let userId = confirmModel.id
                //TODO: - Сохранить можель пользователя в CoreData
                print("USER ID: \(userId)")
                print(confirmModel.created_at)
                
                DispatchQueue.main.sync {
                    compitition(nil)
                }
                
            case .failure(let error):
                DispatchQueue.main.sync {
                    compitition(error)
                }
            }
        }
    }
}
