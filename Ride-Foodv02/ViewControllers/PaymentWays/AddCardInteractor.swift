//
//  AddCardInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 06.07.2021.
//

import Foundation
import UIKit

class AddCardInteractor {
    
    let separetion = SeparetionText()
    
    func postCardData(userID: String, passData: [String : String], completion: @escaping (PaymentWaysModel?) -> Void) {

        let urlString = separetion.separation(input: addCardURL, insert: userID)
        
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
    
    func approvedCard(with id: Int, for userID: String) {

        let firstPartURL = separetion.separation(input: addCardURL, insert: userID)
        
        let approvedURL = firstPartURL + "/" + String(id) + "/approved"
        
        guard let url = URL(string: approvedURL) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post.rawValue
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest).resume()
    }

    func createShortCardNumber(text cardNumber: String) -> String {
        
        let text = ConfirmCardViewText.confirmText.text()
        let formatedCardNumber = "****" + " " + cardNumber.suffix(4)
        let textArray = text.components(separatedBy: "@#^")
        let addCardInfo = textArray[0] + formatedCardNumber + textArray[1]
        
        return addCardInfo
    }
}
