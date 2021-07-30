//
//  AddCardInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 06.07.2021.
//

import Foundation
import UIKit

class AddCardInteractor {
    
    var userID: String?
   // var cardID: Int?
    
//    func postCardData(passData: [String : String], completion: @escaping (PaymentWaysModel?) -> Void) {
//
//        guard let userID = userID else { return }
//
//        let urlString = separategURL(url: addCardURL, userID: userID)
//        guard let url = URL(string: urlString) else { return }
//
//
//        LoadManager.shared.loadData(of: PaymentWaysResponseData.self, from: url, httpMethod: .post,
//                                    passData: passData) { result in
//
//            switch result {
//            case .success(let inputData):
//                let data = inputData.data
//                completion(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//
//            }
//        }
//    }
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
//    func separategURL(url: String, userID: String) -> String {
//
//        let textArray = url.components(separatedBy: "@#^")
//        let finalUrl = textArray[0] + userID + textArray[1]
//
//        return finalUrl
//    }
    
    //Получаем ID пользователя для дальнейшего использования в запросах к серверу
//    func getUserID() {
//
//        CoreDataManager.shared.fetchCoreData { [weak self] result in
//
//            switch result {
//            case .success(let model):
//                let userData = model.first
//                self?.userID = String(describing: userData!.id!)
//            case .failure(let error):
//                print(error)
//            case .none:
//                return
//            }
//        }
//    }
//
//    func getCard(id: Int) {
//        cardID = id
//    }
    
    
    
    
    func separated(text cardNumber: String) -> String {
        
        let text = ConfirmCardViewText.confirmText.text()
        let formatedCardNumber = "****" + " " + cardNumber.suffix(4)
        let textArray = text.components(separatedBy: "@#^")
        let addCardInfo = textArray[0] + formatedCardNumber + textArray[1]
        
        return addCardInfo
    }
    
//    func colorize(text: String) {
//
//        let attributedString = NSMutableAttributedString(string: text)
//
//        attributedString.addAttributes([ .foregroundColor : LoginColors.blueColor.value], range: NSRange(location: 0, length: text.count))
//
//
//
//        infoTextView.attributedText = attributedString
//    }
    
    //Создаем атребуты для инфо поля, для выделения номера добавляемой карты
    func createTextAttribute(for text: String) -> NSMutableAttributedString {
        
        let licenseText = text
        let attributedString = NSMutableAttributedString(string: licenseText)
        
        let font = UIFont.SFUIDisplayBold(size: 12)
        switch UserDefaultsManager().getLanguage() {
        case "rus":
            attributedString.addAttributes([ .font : font!], range: NSRange(location: 45, length: 9))
        case "eng":
            attributedString.addAttributes([ .font : font!], range: NSRange(location: 61, length: 9))
        default:
            attributedString.addAttributes([ .font : font!], range: NSRange(location: 0, length: 0))
        }
        return attributedString
    }
}
