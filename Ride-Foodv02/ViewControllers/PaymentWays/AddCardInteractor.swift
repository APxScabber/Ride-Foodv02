//
//  AddCardInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 06.07.2021.
//

import Foundation
import UIKit

class AddCardInteractor {
    
    func postCardData(passData: [String : String], completion: @escaping (PaymentWaysModel?) -> Void) {
        
        guard let userID = GetUserIDManager.shared.userID else { return }
        
        let urlString = separategURL(url: addCardURL, userID: userID)
        guard let url = URL(string: urlString) else { return }
        
        
        LoadManager.shared.loadData(of: PaymentWaysResponseData.self, from: url, httpMethod: .post,
                                    passData: passData) { result in
            
            switch result {
            case .success(let inputData):
                let data = inputData.data
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func approvedCard(with id: Int) {
        
        guard let userID = GetUserIDManager.shared.userID else { return }
        
        let firstPartURL = separategURL(url: addCardURL, userID: userID)
        
        let approvedURL = firstPartURL + "/" + String(id) + "/approved"
        
        guard let url = URL(string: approvedURL) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post.rawValue
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest).resume()
    }
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separategURL(url: String, userID: String) -> String {

        let textArray = url.components(separatedBy: "@#^")
        let finalUrl = textArray[0] + userID + textArray[1]

        return finalUrl
    }

    func separated(text cardNumber: String) -> String {
        
        let text = ConfirmCardViewText.confirmText.text()
        let formatedCardNumber = "****" + " " + cardNumber.suffix(4)
        let textArray = text.components(separatedBy: "@#^")
        let addCardInfo = textArray[0] + formatedCardNumber + textArray[1]
        
        return addCardInfo
    }
    
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
