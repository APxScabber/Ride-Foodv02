//
//  PaymentWaysInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation
import UIKit

class PaymentWaysInteractor {
    
    let separetion = SeparetionText()
    
    // Загружаем данные с сервера
    func loadPaymentData(userID: String, completion: @escaping ([PaymentWaysModel]) -> Void) {
        
        let urlString = separetion.separation(input: paymentWaysURL, insert: userID)

        guard let url = URL(string: urlString) else { return }
        
        LoadManager.shared.loadData(of: PaymentWaysDataModel.self,
                                    from: url,
                                    httpMethod: .get,
                                    passData: nil) { result in
            switch result {
            case .success(let model):
                completion(model.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filter(text: String) -> Bool {
        
        var isCard = false

        let decimalCharacters = CharacterSet.decimalDigits

        let decimalRange = text.rangeOfCharacter(from: decimalCharacters)

        if decimalRange != nil {
            
            isCard = true
        } else {
            isCard = false
        }
        
        return isCard
    }
}
