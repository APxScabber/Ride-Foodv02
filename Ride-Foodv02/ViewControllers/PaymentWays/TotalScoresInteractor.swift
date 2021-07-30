//
//  TotalScoresInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.07.2021.
//

import Foundation
import UIKit

class TotalScoresInteractor {
    
    func loadScores(userID: String, completion: @escaping (TotalScoresModel) -> Void) {
        
        let stringURL = separategURL(url: totalScoresURL, userID: userID)
        
        let url = URL(string: stringURL)
        
        
        LoadManager.shared.loadData(of: TotalScoresDataModel.self, from: url!,
                                    httpMethod: .get, passData: nil) { result in
            
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
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separatedTotal(scores: String, text: String) -> String {
        
        let textArray = text.components(separatedBy: "@#^")
        
        let finalUrl = textArray[0] + scores + textArray[1]
        
        return finalUrl
    }
    
    //Создаем атребуты для инфо поля, для выделения номера добавляемой карты
    func createTextAttribute(for text: String) -> NSMutableAttributedString {
        
        let infoText = text
        let attributedString = NSMutableAttributedString(string: infoText)
        
        switch UserDefaultsManager().getLanguage() {
        case "rus":
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.yellowColor.value], range: NSRange(location: 6, length: text.count - 6))
        case "eng":
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.yellowColor.value], range: NSRange(location: 9, length: text.count - 9))
        default:
            attributedString.addAttributes([ .foregroundColor : PaymentWaysColors.yellowColor.value], range: NSRange(location: 0, length: 0))
        }
        return attributedString
    }
}
