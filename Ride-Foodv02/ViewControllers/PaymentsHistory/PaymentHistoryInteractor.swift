//
//  PaymentHistoryInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import Foundation
import UIKit

class PaymentHistoryInteractor {
    
    let separetion = SeparetionText()
    
    func loadPaymentHistoryData(userID: String, completion: @escaping ([PaymentHistoryModel]) -> Void) {

        let urlString = separetion.separation(input: paymentHistoryURL, insert: userID)
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
