//
//  PaymentWaysInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation
import UIKit

class PaymentWaysInteractor {
    
    func loadPaymentData(completion: @escaping ([PaymentWaysModel]) -> Void) {
        
        guard let userID = GetUserIDManager.shared.userID else { return }
        
        let urlString = separategURL(url: paymentWaysURL, userID: userID)
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
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separategURL(url: String, userID: String) -> String {
        
        let textArray = url.components(separatedBy: "@#^")
        let finalUrl = textArray[0] + userID + textArray[1]
        
        return finalUrl
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
    
    
    //Создаем атребуты для инфо поля, для выделения номера добавляемой карты
    func createTextAttribute(for text: String) -> NSMutableAttributedString {
        
        let licenseText = text
        let attributedString = NSMutableAttributedString(string: licenseText)

        switch UserDefaultsManager().getLanguage() {
        case "rus":
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.grayColor.value], range: NSRange(location: 6, length: 9))
        case "eng":
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.grayColor.value], range: NSRange(location: 5, length: 9))
        default:
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.grayColor.value], range: NSRange(location: 0, length: 0))
        }
        return attributedString
    }
    
    
}
