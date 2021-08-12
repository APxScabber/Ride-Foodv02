//
//  PaymentHistoryInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import Foundation
import UIKit

class PaymentHistoryInteractor {
    
//    var userID: String?
    
    func loadPaymentHistoryData(completion: @escaping ([PaymentHistoryModel]) -> Void) {
        
        let userID = GetUserIDManager.shared.userID
        
        guard let userID = userID else { return }
        
        print(userID)
        
        let urlString = separategURL(url: paymentHistoryURL, userID: userID)
        guard let url = URL(string: urlString) else { return }
        
        LoadManager.shared.loadData(of: PaymentHistoryDataModel.self,
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
    
    // Метод устанавливающий картинку Наличные или Карта
    func setImage(for cell: PaymentHistoryTableViewCell,
                  indexPath: IndexPath, from array: [PaymentHistoryModel]) {
        
        var cardNumber: String?
        let method = array[indexPath.row].method
        
        switch method {
        case "cash":
            
            cell.cardNumberLabel.alpha = 0
            cell.cardImage.image = UIImage(named: "cash")
        case "card":
            
            cardNumber = array[indexPath.row].payment_card?.number
            
            if let cardNumber = cardNumber {
                cell.cardNumberLabel.alpha = 1
                cell.cardNumberLabel.text = cardNumber
            }
            
            cell.cardImage.image = UIImage(named: "Visa")
        default:
            
            cell.cardNumberLabel.alpha = 0
            cell.cardImage.image = nil
        }
    }
}
