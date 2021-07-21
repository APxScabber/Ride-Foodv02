//
//  AddCardInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 06.07.2021.
//

import Foundation

class AddCardInteractor {
    
    var userID: String?
    var cardID: Int?
    
    func postCardData(passData: [String : String], completion: @escaping (PaymentWaysModel?) -> Void) {
        
        guard let userID = userID else { return }
        
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
    
    func getCard(id: Int) {
        cardID = id
    }
    
}
