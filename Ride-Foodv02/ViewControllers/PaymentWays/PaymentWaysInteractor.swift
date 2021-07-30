//
//  PaymentWaysInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation
import UIKit

class PaymentWaysInteractor {
    
    var userID: String?
    
    func loadPaymentData(completion: @escaping ([PaymentWaysModel]) -> Void) {
        
        guard let userID = userID else { return }
        
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
    
    //Получаем ID пользователя для дальнейшего использования в запросах к серверу
    func getUserID() {
        
        CoreDataManager.shared.fetchCoreData { [weak self] result in
            
            switch result {
            case .success(let model):
                let userData = model.first
                self?.userID = String(describing: userData!.id!)
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
    
//    func filter(text: String) -> (String, NSMutableAttributedString) {
//
//        var formatedCardNumber = ""
//        var textattribute = NSMutableAttributedString()
//
//        let decimalCharacters = CharacterSet.decimalDigits
//
//        let decimalRange = text.rangeOfCharacter(from: decimalCharacters)
//
//        if decimalRange != nil {
//            formatedCardNumber = "Карта ****" + " " + text.suffix(4)
//            textattribute = createTextAttribute(for: formatedCardNumber)
//        } else {
//            formatedCardNumber = text
//        }
//
//        return (formatedCardNumber, textattribute)
//    }
    
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
