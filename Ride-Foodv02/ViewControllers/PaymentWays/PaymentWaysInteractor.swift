//
//  PaymentWaysInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation

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
}
